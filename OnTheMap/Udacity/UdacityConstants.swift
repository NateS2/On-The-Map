//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Nathan  on 1/20/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

extension UdacityClient {
    
    struct Constants {
        static let SessionURL = "https://www.udacity.com/api/session"
        static let userDataURL = "https://www.udacity.com/api/users/\(LoginCredentials.accountKey)"
    }
    
    struct account : Codable {
        let registered: Bool
        let key: String
    }
    
    struct session : Codable {
        let id: String
        let expiration: String
    }
    
    struct Response : Codable {
        let account: account
        let session: session
    }
    
}
