//
//  ViewController.swift
//  Restaurant Locator
//
//  Created by pro on 2017/9/3.
//  Copyright © 2017年 pro. All rights reserved.
//

// 2017/9/7 -- log
// fix -- bugs

// 1 --- update mapview ---
// 2 --- manually add one restaurant -- error -- I retry the restaurant and successed
// 3 --- add one restanurant or change some data of one restaurant but need to exit and enter the APP to check the new restaurant -- I want reload the viewcontroller
// 4 --- display more than one self annotation in map kit.

// solutions:
// change a lot of code in mapview controller
// 1 --- set region()
// 2 --- I can not reappear this bug
// 3 --- add tabbar click to call viewwillload()
// 4 --- add mapView.removeAnnotations(mapView.annotations)

import UIKit
import CoreData
import MapKit

// --- all category screen ---
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate  {
    @IBOutlet weak var tableview: UITableView!
    var items: [String] = ["We", "Heart", "Swift","all beautiful seats"]
    var image_list = ["cafelore.jpg","forkeerestaurant.jpg","posatelier.jpg","traif.jpg"]
    var image_list_rest = ["cafeloisl.jpg","caskpubkitchen.jpg","donostia.jpg","grahamavenuemeats.jpg","barrafina","bourkestreetbakery","confessional","haighschocolate","palominoespresso"]
    var currentLocation: CLLocationCoordinate2D?
    var locationManager: CLLocationManager = CLLocationManager()
    
    //var dataArray: NSMutableArray = ["a", "b", "c", "e"]
    var category_list = [Categoryss] ()
    var restaurant_list = [Restaurant] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            getdata() // --- get restaurant data ---
            getData() // --- get category data ---
            add_all_category_data() // --- initial data with three category
            add_all_restaurant_data() // --- initial data with nine restaurant
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        
        
        
    }
    // --- add one category data ---
    func add_one_category_data(_ name: String, _ index: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var flag = true
        for ele in category_list {
            if ele.name == name {
                flag = false
                break
            }
        }
        if (flag) {
            var data = NSEntityDescription.insertNewObject(forEntityName: "Categoryss", into: context) as! Categoryss
            data.name = name
            let imagedata = UIImagePNGRepresentation(UIImage(named: image_list[index])!)
            data.setValue(imagedata, forKey: "logo")
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    func add_one_restaurant_data(_ name: String, _ loca: String , _ logo_index: Int, category cate: String, rating rat: Int,_ year: Int, _ month: Int, _ day: Int, _ long: Double, _ lat: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var flag = true
        for ele in restaurant_list {
            if ele.name == name {
                flag = false
                break
            }
        }
        if (flag) {
            var data = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: context) as! Restaurant
            data.name = name
            let imagedata = UIImagePNGRepresentation(UIImage(named: image_list_rest[logo_index])!)
            data.setValue(imagedata, forKey: "logo")
            data.category = cate
            data.radius = 1000
            data.rating = Int16(rat)
            data.location = loca
            data.latitude = lat 
            data.longitude = long
            data.isneedpublish = true
            data.date_added_year = Int64(year)
            data.date_added_month = Int16(month)
            data.date_added_day = Int16(day)
            data.date_added_hour = 0
            data.date_added_minute = 0
            data.date_added_second = 0
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
    
    func add_all_category_data() {
        //--- insert three category
        // 1 - coffee || 2 - chinese food || 3 - American food
        //var data = NS
        add_one_category_data("coffee", 0)
        add_one_category_data("breakfast", 1)
        add_one_category_data("Chinese food", 2)
        
    }
    func add_all_restaurant_data() {
        //add_one_restaurant_data("dflsdf", "zero-zero", 1, category: "coffee",)
        add_one_restaurant_data("dfdsgdgd", "mcdksfsd", 0 , category: "coffee", rating: 2, 17, 7, 7, 145.050156, -37.875463)
        add_one_restaurant_data("fldpfpd", "nwkqle", 1 , category: "coffee", rating: 5, 17, 8, 8, 145.043590, -37.872076)
        add_one_restaurant_data("dejwrwe", "smfllw", 2 , category: "coffee", rating: 1, 17, 9, 1, 145.058259, -37.876073)
        add_one_restaurant_data("pkwkew", "sflsdlf", 3 , category: "breakfast", rating: 3, 17, 7, 7, 145.039720, -37.878783)
        add_one_restaurant_data("lpwqkeq", "mldas", 4 , category: "breakfast", rating: 2, 17, 8, 7, 145.030965, -37.886235)
        add_one_restaurant_data("pewqpe", "lpqwpe", 5 , category: "breakfast", rating: 4, 17, 9, 2, 145.023875, -37.872425)
        add_one_restaurant_data("pwprqew", "lpwqpewq", 6 , category: "Chinese food", rating: 3, 17, 7, 7, 145.018920, -37.895989)
        add_one_restaurant_data("mvncbv", "ewerwe", 7 , category: "Chinese food", rating: 4, 17, 6, 5, 145.116080, -37.848290)
        add_one_restaurant_data("asdsadd", "mvclv", 8 , category: "Chinese food", rating: 1, 17, 3, 19, 145.148696, -37.831751)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category_list.count
    }
    func getdata()  {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //tasks =  context.fetch(Task.fetchRequest())
        do {
            restaurant_list = try context.fetch(Restaurant.fetchRequest())
            //print(category_list.count)
        }
        catch {
            print("Fetching Failed")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc: CLLocation = locations.last!
        currentLocation = loc.coordinate
        getdata()
        check_number(currentLocation!)
    }
    func cal_distance(_ one_lat: Double, _ one_long: Double, _ two: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: CLLocationDegrees(one_lat), longitude: CLLocationDegrees(one_long))
        let location2 = CLLocation(latitude: CLLocationDegrees(two.latitude), longitude: CLLocationDegrees(two.longitude))
        let kilometers = location1.distance(from: location2)
        return kilometers as! Double
    }
    
    func check_number(_ loc: CLLocationCoordinate2D) {
        var number = 0
        for ele in restaurant_list {
            var distance = cal_distance(ele.latitude, ele.longitude, loc)
            if (distance <= 500) {
                number = number + 1
            }
        }
        if number > 0 {
            self.tabBarController?.tabBar.items?[1].badgeValue = String(number)
        }
    }
    
    // ----- I learn these code from youtube and change them ------
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //tasks =  context.ftetch(Task.fetchRequest())
        do {
            category_list = try context.fetch(Categoryss.fetchRequest())
            print(category_list.count)
        }
        catch {
            print("Fetching Failed")
        }
    }
    //------- I think these code for coredata is pretty universial
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let one_category = category_list[indexPath.row]
        cell.textLabel?.text = one_category.name!
        //cell.imageView?.image = UIImage(named: one_category.picture!)
        let image_one = UIImage(data: one_category.logo as! Data)
        let image_two = image_one?.resizeImageWith(newSize: CGSize(width:60, height:60))
        cell.imageView?.image = image_two
        return cell
    }
    
    // --- rearrange the order of the list --- just uncomment the code ---
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.category_list[sourceIndexPath.row]
        category_list.remove(at: sourceIndexPath.row)
        category_list.insert(movedObject, at: destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    // --- rearrange the order of the list  ---
    
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated:true)
    }*/
 
    // ---- click button to set the order, I get these code from stackflow -----
    @IBAction func change_order(_ sender: UIButton) {
        tableview.isEditing = !tableview.isEditing
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let one_category = category_list[indexPath.row]
            context.delete(one_category)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
            do {
                var results = try context.fetch(fetchRequest)
                //let one_category_s = self.category_list[indexPath.row]
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let one = result.value(forKey: "category") as? String {
                            if (one == one_category.name) {
                                //result.setValue(name.text!, forKey: "name")
                                context.delete(result)
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            }
                        }
                    }
                }
            }
            catch {
                print("errot -- fecth ---")
            }
            getData()
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // edit_action ------ I learnt the nextVC 's usage from stackflow ------
        let edit_action = UITableViewRowAction(style: .default, title: "edit", handler: { (action, indexPath) -> Void in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "next") as! AddCategoryViewController
            //nextVC.editing_name = "the original name is\(self.category_list[indexPath.row].name ?? "one") please input the new one"
            nextVC.editing_name = self.category_list[indexPath.row].name!
            nextVC.one_cate = self.category_list[indexPath.row]
            //self.present(view, animated: true, completion: nil)
            //let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! NextViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        })
        
        edit_action.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0) // just use one color
        
        //
        let delete_action = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) -> Void in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let one_category = self.category_list[indexPath.row]
            context.delete(one_category)
            // --- the coredata operation is from youtube -----
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
            do {
                var results = try context.fetch(fetchRequest)
                //let one_category_s = self.category_list[indexPath.row]
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let one = result.value(forKey: "category") as? String {
                            if (one == one_category.name) {
                                //result.setValue(name.text!, forKey: "name")
                                context.delete(result)
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            }
                        }
                    }
                }
            }
            catch {
                print("errot -- fecth ---")
            }
            
            
            self.getData()
            tableView.reloadData()
            
        })
        return [delete_action,edit_action]
    }
    
    // segue --- to RestaurantViewController --- spend a lot of time to debug it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showrestaurant" {
            if let indexpath = tableview.indexPathForSelectedRow {
                //print(category_list[indexpath.row].name!)
                let destinationController = segue.destination as! RestaurantViewController
                //print(category_list[indexpath.row].name!)
                destinationController.category = category_list[indexpath.row].name!
                //destinationController.
                //print(category_list[indexpath.row].name!)
            }
        }
    }
    
}







