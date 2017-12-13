//
//  Pin.swift
//  Project5
//
//  Created by Claudio Carnino on 12/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa
import MapKit


final class Pin: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var color: NSColor
    
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, color: NSColor = .green) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.color = color
    }
    
}
