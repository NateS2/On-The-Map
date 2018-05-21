//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nathan  on 1/20/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

/** https://benscheirman.com/2017/06/swift-json/ // this snippet was referenced
 let jsonData = jsonString.data(encoding: .utf8)!
 let decoder = JSONDecoder()
 let beer = try! decoder.decode(Beer.self, for: jsonData)
 */

import UIKit

class UdacityClient: NSObject {
    
    static let shared = UdacityClient()
    
    func getSessionID(username: String, password: String, completion:@escaping (_ success: Bool) ->(), failure:@escaping () ->()) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                //network failure
                failure()
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print("This is the Response:" + String(data: newData!, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let jsonResponse = try decoder.decode(Response.self, from: newData!)
                LoginCredentials.sessionID = jsonResponse.session.id
                LoginCredentials.accountKey = jsonResponse.account.key
                completion(true)
            } catch {
                // if failed at this stage... login credentials would be wrong
                completion(false)
            }
        }
        task.resume()
    }
    
    func getUserData(completion:@escaping () ->(), failure:@escaping () ->()) {
        let request = URLRequest(url: URL(string: Constants.userDataURL)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                failure()
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            do {
                let parsedDataJSON = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
                self.parseJSONAsDictionary(parsedDataJSON)
                completion()
            } catch {
                print("other error")
                failure()
            }
        }
        task.resume()
    }
    
    func parseJSONAsDictionary(_ dictionary: NSDictionary) {
        guard let userDictionary = dictionary["user"] as? NSDictionary else {
            print("Cannot find key 'achievements' in \(dictionary)")
            return
        }
        guard let firstName: String = userDictionary["first_name"] as? String ?? "" else {
            print("Cannot find key 'firstName' in \(userDictionary)")
            return
        }
        guard let lastName: String = userDictionary["last_name"] as? String ?? "" else {
            print("Cannot find key 'lastName' in \(userDictionary)")
            return
        }
        print(firstName)
        print(lastName)
        LoginCredentials.firstName = firstName
        LoginCredentials.lastName = lastName
    }
    
    func logOut() {
        var request = URLRequest(url: URL(string: Constants.SessionURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
