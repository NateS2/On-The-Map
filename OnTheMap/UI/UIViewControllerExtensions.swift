//
//  UIViewControllerExtensions.swift
//  OnTheMap
//
//  Created by Nathan  on 1/22/18.
//  Copyright © 2018 Nathan . All rights reserved.
// https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift code obtained from here

import Foundation
import UIKit

extension UIViewController  {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
