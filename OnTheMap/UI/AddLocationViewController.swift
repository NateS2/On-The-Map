//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Nathan  on 1/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//  used https://cocoacasts.com/forward-geocoding-with-clgeocoder for help
//  https://coderwall.com/p/su1t1a/ios-customized-activity-indicator-with-swift


import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocation(_ sender: Any) {
        showActivityIndicatory(uiView: self.view)
        guard let link = linkTextField.text else { return }
        if (locationTextField.text != "" && Int(link.count) > 4) {
            geocoder.geocodeAddressString(locationTextField.text!) { (locations, error) in
                // Process Response
                self.handleResponse(locations: locations, error: error)
                self.performSegue(withIdentifier: "ViewAddedLocations", sender: nil)
                self.hideActivityView()
            }

        } else {
            let alert = UIAlertController(title: "Empty URL or Link Textfield", message: "Make sure you enter a valid location and url", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: {
                self.hideActivityView()
            })
        }
    }
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    private let udacityClient: UdacityClient = UdacityClient.shared
    var coordinate2D: CLLocationCoordinate2D!
    lazy var geocoder = CLGeocoder()
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        activityIndicator.hidesWhenStopped = true
        udacityClient.getUserData(completion: {
            //user data request successful
        }) {
            //user data request failed
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewAddedLocations" {
            guard let location = locationTextField.text else { return }
            guard let link = linkTextField.text else { return }
            if let vc = segue.destination as? ViewAddedLocationViewController {
                vc.location = location
                vc.link = link
                vc.coordinate2D = coordinate2D
            }
        }
    }
    
    func handleResponse(locations: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            unableToFindLocationAlert()
            hideActivityView()
        } else {
            var location: CLLocation?
            
            if let placemarks = locations, placemarks.count > 0 {
                location = locations?.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
//                latitude = coordinate.latitude
//                longitude = coordinate.longitude
                coordinate2D = coordinate
            } else {
                unableToFindLocationAlert()
            }
        }
    }
    
    func unableToFindLocationAlert() {
        let alert = UIAlertController(title: "Unable to Find Location", message: "Make sure you enter a valid location", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideActivityView() {
        activityIndicator.stopAnimating()
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.view.viewWithTag(10) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func showActivityIndicatory(uiView: UIView) {
        var container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        container.tag = 100
        
        var loadingView: UIView = UIView()
        loadingView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(displayP3Red: 68/255, green: 68/255, blue: 68/255, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.tag = 10
        
//        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint.init(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
}


