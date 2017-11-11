//
//  RestaurantMapViewController.swift
//  Restaurant Locator
//  restaurant single category screen
//  Created by pro on 2017/9/5.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class RestaurantMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITabBarControllerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var Allrestaurant = [Restaurant] ()
    var regionRadius: CLLocationDistance = 500
    
    var locationManager: CLLocationManager = CLLocationManager()
    var geoLocation: CLCircularRegion?
    var currentLocation: CLLocationCoordinate2D?
    var pinAnnotationView: MKPinAnnotationView!
    var allAnnotation = [Any]()
    var vinity_restaurant_number = 0
    var report_flag = true
    var self_annotation: selfAnnotation!
    var add_annotation = false // a flag represent whether add all annotation
    
    
    // load restaurant data
    func getdata() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            Allrestaurant = try context.fetch(Restaurant.fetchRequest())
            print(Allrestaurant.count)
        }
        catch {
            print("Fetching Failed")
        }
    }
    // the method is to set the badgeValue to nil when click the tabbaritem
    
    
    // func tabbarcontroller -- call viewWillAppear() to reload the view when enter the second screen
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("------ detect the press button ------")
        let select_index = tabBarController.selectedIndex
        if select_index == 1 {
            add_annotation = false
            self.tabBarController?.tabBar.items?[1].badgeValue = nil
            self.viewWillAppear(true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //checkLocationAuthorizationStatus()
        mapView.delegate = self
        self.tabBarController?.delegate = self
        //self.tabBarController?.tabBar.items?[1].
        //locationManager(locationManager)
        //getdata()
        /*print(currentLocation?.latitude, currentLocation?.longitude)
        let location: FencedAnnotation = FencedAnnotation(newTitle: "me", newSubtitle: "myself", lat: currentLocation!.latitude, long: currentLocation!.longitude)*/
        //print(currentLocation?.latitude, currentLocation?.longitude)
        //focusOn(annotation: location as MKAnnotation)
        /*for ele in Allrestaurant {
            let location: FencedAnnotation = FencedAnnotation(newTitle: ele.name!, newSubtitle: ele.location!, lat: ele.latitude, long: ele.longitude)
            //location.
            focusOn(annotation: location as MKAnnotation)
            addAnnotation(annotation: location as MKAnnotation)
        }*/
    }
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        print("-----------------")
        print(currentLocation?.longitude, currentLocation?.latitude)
        print("-----------------")
        if let _ = currentLocation {
            print("lllllllllllllll")
            let region = MKCoordinateRegionMakeWithDistance(currentLocation!, regionRadius*2, regionRadius*2)
            mapView.setRegion(region, animated: true)
            var circle = MKCircle(center: currentLocation!, radius: regionRadius as CLLocationDistance)
            self.mapView.add(circle)
        }
        getdata()
        allAnnotation.removeAll()
        //print(Allrestaurant)
        // analyze all data and add annotation to MapView
        for ele in Allrestaurant {
            print("--------1------")
            var sub: String
            if (ele.isneedpublish) {
                sub = "can receive notification"
            } else {
                sub = "can't receive notification"
            }
            print("--------1------"+sub)
            let location: FencedAnnotation = FencedAnnotation(newTitle: ele.name!, newSubtitle: sub, lat: ele.latitude, long: ele.longitude, ele.radius, ele.isneedpublish)
            //location.image = ele.logo!
            //location.check(lat: (currentLocation?.latitude)!, long: (currentLocation?.longitude)!)
            location.image = UIImage(data: ele.logo as! Data)
            allAnnotation.append(location)
            print("--------1------"+sub)
            if (ele.isneedpublish) {
                geoLocation = CLCircularRegion(center: location.coordinate, radius: ele.radius, identifier: ele.name!)
                geoLocation!.notifyOnExit = true
                locationManager.startMonitoring(for: geoLocation!)
            }
            
            //pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
            //self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation1, reuseIdentifier: nil)
            /*pointAnnotation = CustomPointAnnotation()
            pointAnnotation.pinimage = ele.logo!
            print(ele.logo!)
            pointAnnotation.coordinate = location
            pointAnnotation.title = ele.name
            pointAnnotation.subtitle = ele.location
            
            pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
            //mapView.addAnnotation(annotation: pinAnnotationView.annotation!)
            mapView.addAnnotation(pinAnnotationView.annotation!)*/
            
        }
        //mapView.showAnnotations(mapView.annotations, animated: true)
        // when app get user's currentLocation, it will call setRegion() to center the location with one certain radius
        if !add_annotation && currentLocation != nil {
            checkandAddAnnotation()
            add_annotation = !add_annotation
            self_annotation = selfAnnotation(newTitle: "you", lat: (currentLocation?.latitude)!, long: (currentLocation?.longitude)!)
            mapView.addAnnotation(self_annotation)
            let region = MKCoordinateRegionMakeWithDistance(currentLocation!, regionRadius*2, regionRadius*2)
            mapView.setRegion(region, animated: true)
        }
        /*if let llll = currentLocation {
            //let region = MKCoordinateRegion(center: llll, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            let region = MKCoordinateRegionMakeWithDistance(llll, regionRadius * 2, regionRadius * 2)
            mapView.setRegion(region, animated: true)
        }*/
        //locationManager.startMonitoring(for: geoLocation!)
        print("--------------") // for testing
    }
    // geo-fencing , when user enter one restaurant's region, app will alter.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alter = UIAlertController(title: "notice", message: "there is \(region.identifier) nearby",preferredStyle: UIAlertControllerStyle.alert)
        let alertView5 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            print("ok")
        }
        alter.addAction(alertView5)
        self.present(alter, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // get current location --- add annotation and circle for the center.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc: CLLocation = locations.last!
        currentLocation = loc.coordinate
        //let region = MKCoordinateRegion(center: currentLocation!, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        let region = MKCoordinateRegionMakeWithDistance(currentLocation!, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
        self_annotation = selfAnnotation(newTitle: "you", lat: (currentLocation?.latitude)!, long: (currentLocation?.longitude)!)
        mapView.addAnnotation(self_annotation)
        var circle = MKCircle(center: currentLocation!, radius: regionRadius as CLLocationDistance)
        self.mapView.add(circle)
        if !add_annotation {
            checkandAddAnnotation()
            add_annotation = !add_annotation
            
        }
    }
    
    // calculate the vinity_restaurant_number
    func checkandAddAnnotation() {
        vinity_restaurant_number = 0
        for ele in allAnnotation {
            if ele is FencedAnnotation {
                let element = ele as! FencedAnnotation
                element.check(lat: (currentLocation?.latitude)!, long: (currentLocation?.longitude)!,regionRadius)
                if element.is_in {
                    vinity_restaurant_number = vinity_restaurant_number + 1
                }
                mapView.addAnnotation(element)
                /*if element.isneednotification {
                    //var circle = MKCircle(center: element.coordinate, radius: element.distance as CLLocationDistance)
                    var circle = MKCircle(center: element.coordinate, radius: element.distance as CLLocationDistance)
                    self.mapView.add(circle)
                    //var circle = MKCircle(center: element.coordinate, radius: element.distance as CLLocationDistance)
                    //self.mapView.add(circle)
                }*/ // --- delete the circles
            }
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
        if report_flag {
            alter_vinity_restaurant_number()
        }
        let region = MKCoordinateRegionMakeWithDistance(self.currentLocation!, self.regionRadius*2, self.regionRadius*2)
        self.mapView.setRegion(region, animated: true)
    }
    // alter the vinity_restaurant_number when open the app
    func alter_vinity_restaurant_number() {
        let alter = UIAlertController(title: "notification", message: "there is \(vinity_restaurant_number) restaurants in your vicnity",preferredStyle: UIAlertControllerStyle.alert)
        let alertView5 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.tabBarController?.tabBar.items?[1].badgeValue = nil
            let region = MKCoordinateRegionMakeWithDistance(self.currentLocation!, self.regionRadius*2, self.regionRadius*2)
            self.mapView.setRegion(region, animated: true)
        }
        alter.addAction(alertView5)
        present(alter, animated: true, completion: nil)
        report_flag = false
    }
    // from the tutorial
    func addAnnotation(annotation: MKAnnotation) {
        self.mapView.addAnnotation(annotation)
    }
    func focusOn(annotation: MKAnnotation) {
        self.mapView.centerCoordinate = annotation.coordinate
        self.mapView.selectAnnotation(annotation, animated: true)
    }
    // click button to edit the radius choice: 1000, 2000, 5000, cancel
    @IBAction func edit_radius(_ sender: Any) {
        let alter = UIAlertController(title: "Choose new radius", message: "please choose one new radius",preferredStyle: UIAlertControllerStyle.alert)
        let alertView1 = UIAlertAction(title: "radius: 200", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.regionRadius = 200
            if let llll = self.currentLocation {
                let region = MKCoordinateRegionMakeWithDistance(llll, self.regionRadius*2, self.regionRadius*2)
                self.mapView.setRegion(region, animated: true)
                self.add_annotation = false
                self.viewWillAppear(true)
            }
        }
        let alertView2 = UIAlertAction(title: "radius: 500", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.regionRadius = 500
            if let llll = self.currentLocation {
                let region = MKCoordinateRegionMakeWithDistance(llll, self.regionRadius*2, self.regionRadius*2)
                self.mapView.setRegion(region, animated: true)
                self.add_annotation = false
                self.viewWillAppear(true)
            }
        }
        let alertView3 = UIAlertAction(title: "radius: 1000", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.regionRadius = 1000
            if let llll = self.currentLocation {
                let region = MKCoordinateRegionMakeWithDistance(llll, self.regionRadius*2, self.regionRadius*2)
                self.mapView.setRegion(region, animated: true)
                self.add_annotation = false
                self.viewWillAppear(true)
            }
            
        }
        let alertView5 = UIAlertAction(title: "cancel", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            print("cancel")
        }
        alter.addAction(alertView1)
        alter.addAction(alertView2)
        alter.addAction(alertView3)
        alter.addAction(alertView5)
        self.present(alter, animated: true, completion: nil)
    }
    
    // add annotation 
    // FencedAnnotation --- the restaurant. red color means the restaurant is in vincity , green represents not in.
    // selfAnnotation ---- the user color is purple.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is FencedAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            pinView.isEnabled = true
            pinView.canShowCallout = true
            let notation = annotation as! FencedAnnotation
            //print(notation.image!)
            let immm = notation.image
            let en = immm?.resizeImageWith(newSize: CGSize(width: 22, height: 22))
            pinView.leftCalloutAccessoryView = UIImageView(image: en)
            let rightButton = UIButton(type: .detailDisclosure)
            //rightButton.tag = annotation.hash
            print(notation.is_in, notation.isneednotification, notation.title)
            if notation.is_in && notation.isneednotification {
                pinView.detailCalloutAccessoryView?.tintColor = UIColor.red
            }
            /*else {
                pinView.detailCalloutAccessoryView?.tintColor =
            }*/
            //pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            if notation.is_in {
                pinView.pinTintColor = MKPinAnnotationView.redPinColor()
            } else {
                pinView.pinTintColor = MKPinAnnotationView.greenPinColor()
            }
            //pinView.pinTintColor = notation.color.
            //pinView.image = UIImage(named: notation.image)
            
            return pinView

            /*else {
                let annotationView = MKPinAnnotationView(annotation:annotation, String(annotation.ha))
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                return annotationView
            }*/
        } else if annotation is selfAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            pinView.isEnabled = true
            pinView.canShowCallout = true
            let notation = annotation as! selfAnnotation
            pinView.pinTintColor = MKPinAnnotationView.purplePinColor()
            return pinView
        }
        
        print("343435435646")
        return nil
    }
    // circle -- search them from stackoverflow
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor(red: 10, green: 100, blue: 255, alpha: 0.15)
            circle.lineWidth = 1
            return circle
        }
        else {
            return MKPolylineRenderer()
        }
    }
    // I search this method name from stackoverflow the content is writen myself to navigate to the restaurant detail screen
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("button tapped")
            print(view.annotation?.title!, view.annotation?.subtitle!)
            
            // --- search the target from core data ---
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
            var res: Restaurant!
            do {
                var results = try context.fetch(fetchRequest2)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let one = result.value(forKey: "name") as? String {
                            if (one == (view.annotation?.title)!) {
                                res = result as! Restaurant
                                break
                            }
                        }
                    }
                }
            }
            catch {
                print("errot -- fecth ---")
            }
            // ----------------------------------------
            var ss = ""
            for _ in 0 ..< Int(res.rating) {
                ss = ss + "⭐️"
            }
            var dates = String(res.date_added_day) + " " + String(res.date_added_month) + " " + String(res.date_added_year)
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "next3") as! RestaurantDetailViewController
            nextVC.one_rest = res
            nextVC.d = dates
            nextVC.r = ss
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
    // func touchesBegan() ---- use it to dismiss keyboard--- copy from stackflow
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

