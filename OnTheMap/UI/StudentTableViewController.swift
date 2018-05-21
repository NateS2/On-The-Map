//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Nathan  on 1/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    @IBOutlet weak var studentTableView: UITableView!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateData()
    }
    
    func populateData() {
        parseClient.getStudentLocations(completion: { () in
            self.students = self.sharedData.studentLocations
            performUIUpdatesOnMain {
                self.studentTableView.reloadData()
            }
        }) {
            print("failure in getting request")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as UITableViewCell!
        
        // Configure the cell...
        cell?.textLabel?.text = (student.firstName ?? "") + " " + (student.lastName ?? "")
        cell?.detailTextLabel?.text = student.mediaURL
        cell?.imageView?.image = UIImage(named: "MapPin")
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[(indexPath as NSIndexPath).row]
        let app = UIApplication.shared
        guard let url = student.mediaURL as? String else { return }
        if (Int(url.count) > 4) {
            app.openURL(URL(string: url)!)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let student = students[(indexPath as NSIndexPath).row]
        //Hides all the empty cells
        if (student.firstName == "" || student.lastName == "") {
            return 0
        }
        if student.mediaURL == "" {
            return 0
        }
        return UITableViewAutomaticDimension
    }

}
