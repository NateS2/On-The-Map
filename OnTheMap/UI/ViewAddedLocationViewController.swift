//
//  ViewAddedLocationViewController.swift
//  OnTheMap
//
//  Created by Nathan  on 1/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit
import MapKit

class ViewAddedLocationViewController: UIViewController {
    
    var location: String = ""
    var link: String = ""
    var latitude = 0.0
    var longitude = 0.0
    var coordinate2D: CLLocationCoordinate2D!
    private let parseClient: ParseClient = ParseClient.shared
    
    @IBAction func finishAndPost(_ sender: Any) {
        let student = StudentLocation(createdAt: "", firstName: LoginCredentials.firstName, lastName: LoginCredentials.lastName, latitude: coordinate2D.latitude, longitude: coordinate2D.longitude, mapString: location, mediaURL: link, objectId: "", uniqueKey: LoginCredentials.sessionID, updatedAt: "")
        parseClient.postLocation(student: student) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Unable to Post Location", message: "We are unable to post your location, please check your network connection and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                performUIUpdatesOnMain {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: coordinate2D, span: span)
        mapView.setRegion(region, animated: true)
        let location = Locations(title: "\(LoginCredentials.firstName) \(LoginCredentials.lastName)", subtitle: link, coordinate: coordinate2D)
        mapView.addAnnotation(location)
    }

}
