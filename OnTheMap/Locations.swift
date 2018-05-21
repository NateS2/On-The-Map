//
//  Locations.swift
//  OnTheMap
//
//  Created by Nathan  on 1/21/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import MapKit

class Locations: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
}
