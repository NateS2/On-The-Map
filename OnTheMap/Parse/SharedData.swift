//
//  SharedData.swift
//  OnTheMap
//
//  Created by Nathan  on 1/24/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import Foundation

class SharedData: Codable{
    
    static let sharedInstance = SharedData()
    var studentLocations: [StudentLocation] = []
    
    private init() {}
}
