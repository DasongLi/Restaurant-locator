//
//  fencedAnnotation.swift
//  Restaurant Locator
//
//  Created by pro on 2017/9/5.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit
import MapKit
class FencedAnnotation: NSObject, MKAnnotation {
    // from the tutorial, And I change a lot.
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage!
    var distance = 1000.0
    var is_in = false
    var isneednotification = false
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double, _ dist: Double,_ isneed: Bool) {
        title = newTitle
        subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D()
        coordinate.latitude = lat
        coordinate.longitude = long
        distance = dist
        isneednotification = isneed
    }
    public func check(lat: Double, long: Double, _ dist: Double) {
        // I search the method of calculating two point's distance in stackoverflow
        let location1 = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        let location2 = CLLocation(latitude: CLLocationDegrees(coordinate.latitude), longitude: CLLocationDegrees(coordinate.longitude))
        let kilometers = location1.distance(from: location2)
        if kilometers <= dist {
            is_in = true
        } else {
            is_in = false
        }
        
    }
}
