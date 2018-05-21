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
    
    private let parseClient: ParseClient = ParseClient.shared
    var students: [StudentLocations] = [StudentLocations]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateData()
    }
    
    func populateData() {
        parseClient.getStudentLocations(completion: { (students) in
            self.students = students
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
        cell?.textLabel?.text = student.firstName + " " + student.lastName
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
