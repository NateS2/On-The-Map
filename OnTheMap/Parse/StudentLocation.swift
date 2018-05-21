//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Nathan  on 1/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    let objectId: String
    var uniqueKey: String?
    let updatedAt: String
}

struct Results: Codable {
    let results: [StudentLocation]
}
