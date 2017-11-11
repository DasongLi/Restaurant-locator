//
//  RestaurantDetailViewController.swift
//  Restaurant Locator
//  restaurant detail view controller
//  Created by pro on 2017/9/4.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class RestaurantDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var isneednotifiaction: UISwitch!
    @IBOutlet weak var customradius: UITextField!
    
    /*var image = ""
    var na = ""
    var cate = ""
    var lo = ""
    var r = ""
    var d = ""*/
    var r = ""
    var d = ""
    var one_rest: Restaurant!
    
    // keyboardwillshow ---- the view lift up ---- copy them from stackflow
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height + 150
            }
        }
    }
    // keyboardwillHide ---- the view down ---- copy them from stackflow
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height - 150
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(image,na,cate,lo,r,d)
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantDetailViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantDetailViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        //imageview.image = UIImage(named: one_rest.logo!)
        imageview.image = UIImage(data: one_rest.logo as! Data)
        tableview.delegate = self
        tableview.dataSource = self
        //mapview.delegate = self as! MKMapViewDelegate
        // Do any additional setup after loading the view.
        let location: FencedAnnotation = FencedAnnotation(newTitle: one_rest.name!, newSubtitle: one_rest.location!, lat: one_rest.latitude, long: one_rest.longitude, one_rest.radius, one_rest.isneedpublish)
        //location.
        focusOn(annotation: location as! MKAnnotation)
        addAnnotation(annotation: location as! MKAnnotation)
        isneednotifiaction.isOn = one_rest.isneedpublish
        customradius.text = String(one_rest.radius)
    }
    
// savenotification() --- save the changes of restaurant 's notification state and radius
@IBAction func savenotifiaction(_ sender: Any) {
        guard let tmp = Double(customradius.text!) else {
            let alter = UIAlertController(title: "warning", message: "please input right value for radius",preferredStyle: UIAlertControllerStyle.alert)
            let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                print("ok-operation")
            }
            alter.addAction(alertView1)
            self.present(alter, animated: true, completion: nil)
            return
        }
        guard tmp>0 else {
            let alter = UIAlertController(title: "warning", message: "please input right value for radius",preferredStyle: UIAlertControllerStyle.alert)
            let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                print("ok-operation")
            }
            alter.addAction(alertView1)
            self.present(alter, animated: true, completion: nil)
            return
        }
        one_rest.isneedpublish = isneednotifiaction.isOn
        one_rest.radius = tmp
        // --- need---fecth to update the value----
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        do {
            var results = try context.fetch(fetchRequest2)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let one = result.value(forKey: "name") as? String {
                        if (one == one_rest.name) {
                            result.setValue(one_rest.radius, forKey: "radius")
                            result.setValue(one_rest.isneedpublish, forKey: "isneedpublish")
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        }
                    }
                }
            }
        }
        catch {
            print("errot -- fecth ---")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        // --- no need to update the whole viewcontroller ----
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! RestaurantDetailTableViewCell
        //let cell = tableview.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = one_rest.name
        case 1:
            cell.fieldLabel.text = "Rating"
            cell.valueLabel.text = r
        case 2:
            cell.fieldLabel.text = "Category"
            cell.valueLabel.text = one_rest.category
        case 3:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = one_rest.location
        case 4:
            cell.fieldLabel.text = "Date"
            cell.valueLabel.text = d
        case 5:
            cell.fieldLabel.text = "need publish"
            //cell.valueLabel.text = one_rest.isneedpublish
            if (one_rest.isneedpublish) {
                cell.valueLabel.text = "YES"
            } else {
                cell.valueLabel.text = "NO"
            }
        default:
            cell.fieldLabel.text = ""
            cell.fieldLabel.text = ""
        }
        /*switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = na
        case 1:
            cell.textLabel?.text = "Rating"
            cell.detailTextLabel?.text = r
        case 2:
            cell.textLabel?.text = "Category"
            cell.detailTextLabel?.text = cate
        case 3:
            cell.textLabel?.text = "Location"
            cell.detailTextLabel?.text = lo
        case 4:
            cell.textLabel?.text = "Date"
            cell.detailTextLabel?.text = d
        case 5:
            cell.textLabel?.text = "need publish"
            cell.detailTextLabel?.text = "Yes"
        default:
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }*/
        return cell
    }
    
    // from tutorial
    func addAnnotation(annotation: MKAnnotation) {
        self.mapview.addAnnotation(annotation)
    }
    // from tutorial
    func focusOn(annotation: MKAnnotation) {
        self.mapview.centerCoordinate = annotation.coordinate
        self.mapview.selectAnnotation(annotation, animated: true)
    }

    // func touchesBegan() and textFieldShouldReturn() ----- use them to dismiss keyboard--- copy from stackflow
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}







