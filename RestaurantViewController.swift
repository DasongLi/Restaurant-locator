//
//  RestaurantViewController.swift
//  Restaurant Locator
//
//  Created by pro on 2017/9/4.
//  Copyright © 2017年 pro. All rights reserved.
//


import UIKit
// restaurant single category screen
class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var restaurant_ss = [Restaurant]()
    var restaurant_list = [Restaurant]()
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        //print(category)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getdata()
        print(category) // print for test
        tableview.reloadData()
    }
    
    // get data when initializing or after updating data
    func getdata() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            restaurant_ss = try context.fetch(Restaurant.fetchRequest())
            print(restaurant_ss.count)
            print(restaurant_ss)
            restaurant_list.removeAll()
            for i in 0 ..< restaurant_ss.count {
                if (restaurant_ss[i].category == category) {
                    restaurant_list.append(restaurant_ss[i])
                }
            }
            print(restaurant_list)
        }
        catch {
            print("Fetching Failed")
        }
        
    }
    @IBAction func edit(_ sender: Any) {
        tableview.isEditing = !tableview.isEditing // tuggle for enter editing and exit editing
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant_list.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let one_rest = restaurant_list[indexPath.row]
            //context.delete(one)
            context.delete(one_rest)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            getdata()
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RestaurantTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! RestaurantTableViewCell
        let one_rest = restaurant_list[indexPath.row]
        cell.name.text = one_rest.name
        //cell.imageview.image = UIImage(named: one_rest.logo!)
        let image_one = UIImage(data: one_rest.logo as! Data)
        let image_two = image_one?.resizeImageWith(newSize: CGSize(width:60, height:60))
        cell.imageview.image = image_two
        cell.location.text = one_rest.location
        var ss = ""
        for _ in 0 ..< Int(one_rest.rating) {
            ss = ss + "⭐️"
        }
        cell.rating.text = ss
        /*if (one_rest.isneedpublish) {
            cell.editingAccessoryType = .checkmark
        }*/
        //cell.editingAccessoryType = .checkmark
        return cell
    }
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit_action = UITableViewRowAction(style: .default, title: "edit", handler: { (action, indexPath) -> Void in
            let view = AddCategoryViewController()
            view.editing_name = "the original name is\(self.category_list[indexPath.row].name ?? "one") please input the new one"
            //self.present(view, animated: true, completion: nil)
            self.navigationController?.pushViewController(view, animated: true)
        })
        edit_action.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        let delete_action = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) -> Void in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let one_category = self.category_list[indexPath.row]
            context.delete(one_category)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.getData()
            tableView.reloadData()
            
        })
        return [delete_action,edit_action]
    }*/
    
    // --- rearrange the order of the list ---
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.restaurant_list[sourceIndexPath.row]
        restaurant_list.remove(at: sourceIndexPath.row)
        restaurant_list.insert(movedObject, at: destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    // --- rearrange the order of the list  ---
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit_action = UITableViewRowAction(style: .default, title: "edit", handler: { (action, indexPath) -> Void in
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "next2") as! AddRestaurantViewController
            //nextVC.editing_name = "the original name is\(self.category_list[indexPath.row].name ?? "one") please input the new one"
            //nextVC.editing_name = self.category_list[indexPath.row].name!
            
            //self.present(view, animated: true, completion: nil)
            //let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as! NextViewController
            nextVC.flag = true
            nextVC.cate = self.category
            nextVC.restaurant = self.restaurant_list[indexPath.row]
            //nextVC.editting_label.text = "
            self.navigationController?.pushViewController(nextVC, animated: true)

            
        })
        edit_action.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        let delete_action = UITableViewRowAction(style: .default, title: "Delete", handler: {(action, indexPath) -> Void in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let one_rest = self.restaurant_list[indexPath.row]
            //context.delete(one)
            context.delete(one_rest)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.getdata()
            self.tableview.reloadData()
        })
        return [delete_action,edit_action]
    }
    
    // provide three ways for sorting
    @IBAction func sorting(_ sender: Any) {
        let alter = UIAlertController(title: "Choose new sorting", message: "please choose one new type of sorting",preferredStyle: UIAlertControllerStyle.alert)
        let alertView1 = UIAlertAction(title: "sorting by name", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.restaurant_list.sort(by: {(s1: Restaurant, s2: Restaurant) -> Bool in
                return s1.name! > s2.name!
            })
            self.tableview.reloadData()
        }
        
        let alertView2 = UIAlertAction(title: "sorting by rating", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.restaurant_list.sort(by: {(s1: Restaurant, s2: Restaurant) -> Bool in
                return s1.rating > s2.rating
            })
            self.tableview.reloadData()
        }
        let alertView4 = UIAlertAction(title: "sorting by date (default)", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            self.restaurant_list.sort(by: {(s1: Restaurant, s2: Restaurant) -> Bool in
                if (s1.date_added_year > s2.date_added_year) {
                    return true
                } else if s1.date_added_year < s2.date_added_year {
                    return false
                }
                if (s1.date_added_month > s2.date_added_month) {
                    return true
                } else if s1.date_added_month < s2.date_added_month {
                    return false
                }
                if (s1.date_added_day > s2.date_added_day) {
                    return true
                } else if s1.date_added_day < s2.date_added_day {
                    return false
                }
                if (s1.date_added_hour > s2.date_added_hour) {
                    return true
                } else if s1.date_added_hour < s2.date_added_hour {
                    return false
                }
                if (s1.date_added_minute > s2.date_added_minute) {
                    return true
                } else if s1.date_added_minute < s2.date_added_minute {
                    return false
                }
                if (s1.date_added_second > s2.date_added_second) {
                    return true
                } else if s1.date_added_second < s2.date_added_second {
                    return false
                }
                return true
                
            })
            self.tableview.reloadData()
        }

        
        let alertView3 = UIAlertAction(title: "cancel", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
            print("cancel")
        }
        alter.addAction(alertView1)
        alter.addAction(alertView2)
        alter.addAction(alertView4)
        alter.addAction(alertView3)
        self.present(alter, animated: true, completion: nil)
    }
    
    
    // addrest --- click the add button to call add new restaurant
    // restanrantdetail --- click the element in tableview to see the restaurant detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addrest" {
            let destinationController = segue.destination as! AddRestaurantViewController
            //destinationController.cate = category
            destinationController.cate = category
            print(category)
        
        } else if segue.identifier == "restaurantdetail" {
            if let indexpath = tableview.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                let one = restaurant_list[indexpath.row]
                var ss = ""
                for _ in 0 ..< Int(one.rating) {
                    ss = ss + "⭐️"
                }
                var dates = String(one.date_added_day) + " " + String(one.date_added_month) + " " + String(one.date_added_year)
                print("----------")
                print(dates,ss)
                print(one)
                print("----------")
                /*destinationController.cate = one.category!
                destinationController.d = dates
                destinationController.image = one.logo!
                destinationController.lo = one.location!
                destinationController.na = one.name!
                destinationController.r = ss*/
                destinationController.r = ss
                destinationController.d = dates
                destinationController.one_rest = one
            }
        }
    }
    

}
