//
//  ViewController.swift
//  OnTheMap
//
//  Created by Nathan  on 1/20/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func reload(_ sender: Any) {
        populateData()
    }
    @IBAction func logOut(_ sender: Any) {
        udacityClient.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    private let udacityClient: UdacityClient = UdacityClient.shared
    private let parseClient: ParseClient = ParseClient.shared
    private let sharedData: SharedData = SharedData.sharedInstance
    var students: [StudentLocation] = [StudentLocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateData()
    }
    
    func populateData() {
        mapView.removeAnnotations(mapView.annotations)
        parseClient.getStudentLocations(completion: { () in
            self.students = self.sharedData.studentLocations
            for student in self.students {
                let location = Locations(title: "\(student.firstName ?? "") \(student.lastName ?? "")",
                    subtitle: student.mediaURL ?? "",
                    coordinate: CLLocationCoordinate2D(latitude: student.latitude ?? 0.0, longitude: student.longitude ?? 0.0))
                performUIUpdatesOnMain {
                    self.mapView.addAnnotation(location)
                }
            }
            
        }) {
            print("failure in getting request")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension MapViewController: MKMapViewDelegate {
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}

