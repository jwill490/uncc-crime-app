//
//  Crime.swift
//  mapTesting
//
//  Created by Dallas Sanchez on 11/20/15.
//  Copyright © 2015 Dallas Sanchez. All rights reserved.
//

import Foundation
import MapKit

class Crime: NSObject, MKAnnotation {
    let title: String?
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return "subtite placeholder String"
    }
    
    
    func pinColor() -> UIColor  {
        //Set the icons to display on the map depending on the type of crime
        switch discipline {
        case "Arson", "Violent":
            return UIColor.redColor()
        case "Drug & Alcohol", "Monument":
            return UIColor.greenColor()
        default:
            return UIColor.blueColor()
        }
    }
    
}