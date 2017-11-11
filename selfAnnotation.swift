//
//  selfAnnotation.swift
//  Restaurant Locator
//
//  Created by pro on 2017/9/6.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit
import MapKit
class selfAnnotation: NSObject, MKAnnotation {
    // designed the user's location
    var coordinate: CLLocationCoordinate2D
    var title: String?
    init(newTitle: String, lat: Double, long: Double) {
        title = newTitle
        coordinate = CLLocationCoordinate2D()
        coordinate.latitude = lat
        coordinate.longitude = long
    }
}
