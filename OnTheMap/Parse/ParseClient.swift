//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Nathan  on 1/20/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    
    static let shared = ParseClient()
    private let sharedData: SharedData = SharedData.sharedInstance
    func getStudentLocations(completion:@escaping () ->(), failure:@escaping () ->()) {
        var request = URLRequest(url: URL(string: "\(constants.studentLocationURL)?limit=100&order=-updatedAt")!)
        request.addValue(constants.parseAppID, forHTTPHeaderField: constants.parseIDHeaderField)
        request.addValue(constants.RESTAPIKey, forHTTPHeaderField: constants.parseAPIKeyHeaderField)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                failure()
                print("error")
                return
            }
            do {
                let studentLocationStruct = try JSONDecoder().decode(Results.self, from: data!)
                self.sharedData.studentLocations = studentLocationStruct.results
                completion()
                
            } catch {
                print("other error")
                failure()
                //couldn't parse into expected dictionary
            }
            
        }
        task.resume()
    }
    
    func postLocation(student: StudentLocation, completion:@escaping (_ success: Bool) ->()) {
        let json: [String: Any] = ["uniqueKey": student.uniqueKey,
                                   "firstName": student.firstName,
                                   "lastName":  student.lastName,
                                   "mapString": student.mapString,
                                   "mediaURL":  student.mediaURL,
                                   "latitude":  student.latitude,
                                   "longitude": student.longitude]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: URL(string: constants.studentLocationURL)!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            completion(true)
        }
        task.resume()
    }
    
}
