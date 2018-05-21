//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Nathan  on 1/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocation(_ sender: Any) {
        if (locationTextField.text != nil && linkTextField.text != nil) {
            guard let link = linkTextField.text else { return }
            if (locationTextField.text != "" && Int(link.count) > 4) {
                performSegue(withIdentifier: "ViewAddedLocations", sender: nil)
            }
        }
    }
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewAddedLocations" {
            guard let location = locationTextField.text else { return }
            guard let link = linkTextField.text else { return }
            if let vc = segue.destination as? ViewAddedLocationViewController {
                vc.location = location
                vc.link = link
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


