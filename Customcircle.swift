//
//  Customcircle.swift
//  Restaurant Locator
//
//  Created by 李洋 on 2017/9/7.
//  Copyright © 2017年 pro. All rights reserved.
//

import Foundation
import MapKit

enum states {
    case myself
    case in_need_notification
    case in_dont_need_notificaiton
    case out
}
// --- try to customcircle --- but I failed -----
class Customcircle: MKCircle {
    //var state: states!
    var color: UIColor = UIColor.red
    var rad: CLLocationDistance
    var center: CLLocationCoordinate2D
    init(center coord: CLLocationCoordinate2D, radius r: CLLocationDistance, _ state: states) {
        //super.init(center: coord, radius: r)
        center = coord
        rad = r
        switch state {
        case .in_dont_need_notificaiton:
            //color = UIColor
            break
        case .in_need_notification:
            color = UIColor.red
            break
        case .myself:
            color = UIColor.purple
            break
        case .out:
            color = UIColor.green
            break
        }
    }
}
