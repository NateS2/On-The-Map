//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Nathan  on 1/20/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBAction func logIn(_ sender: Any) {
        getAuthorization()
    }
    
    private let udacityClient: UdacityClient = UdacityClient.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 7
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func getAuthorization() {
        guard let username = emailTextField.text, username != "" else { return }
        guard let password = passwordTextField.text, password != "" else { return }
        udacityClient.getSessionID(username: username, password: password, completion: { (success) in
            if success {
                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                    self.present(controller, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Login failed", message: "Unable to log in, either an incorrect email or password", preferredStyle: .alert)
                self.presentAlert(alert: alert)
            }
        }) {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet", preferredStyle: .alert)
            self.presentAlert(alert: alert)
        }
    }
    
    func presentAlert(alert: UIAlertController) {
        performUIUpdatesOnMain {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
