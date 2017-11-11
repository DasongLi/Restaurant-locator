//
//  AddRestaurantViewController.swift
//  Restaurant Locator
//  add and edit the restaurant
//  Created by pro on 2017/9/4.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit
import MapKit

class AddRestaurantViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var rate: UITextField!
    @IBOutlet weak var isneed: UISwitch!
    @IBOutlet weak var imagelogo: UIImageView!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longtitude: UITextField!
    @IBOutlet weak var name_field: UILabel!
    @IBOutlet weak var localization_field: UILabel!
    @IBOutlet weak var notifi_field: UILabel!
    @IBOutlet weak var laitude_field: UILabel!
    @IBOutlet weak var longtitude_field: UILabel!
    
    var flag = false
    var cate = ""
    var restaurant: Restaurant!
    var image_list = ["cafeloisl.jpg","caskpubkitchen.jpg","donostia.jpg","grahamavenuemeats.jpg"]
    var image_index = 0
    

    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    func init_label() {
        name_field.text = NSLocalizedString("Name", comment: "name field")
        localization_field.text = NSLocalizedString("Location", comment: "location field")
        notifi_field.text = NSLocalizedString("Notification", comment: "notification field")
        latitude.text = NSLocalizedString("Latitude", comment: "latitude field")
        longtitude.text = NSLocalizedString("Longtitude", comment: "longtitude field")
    }
    // keyboardwillshow ---- the view lift up ---- copy them from stackflow
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height + 100
            }
        }
    }
    
    // keyboardwillHide ---- the view down ---- copy them from stackflow
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height - 100
            }
        }
    }
    
    // random select image from my dataset
    @IBAction func randomselect(_ sender: Any) {
        if flag == false {
            image_index = image_index + 1
            if (image_index >= image_list.count) {
                image_index = 0
            }
            imagelogo.image = UIImage(named: image_list[image_index])
        } else {
            imagelogo.image = UIImage(named: image_list[image_index])
            image_index = image_index + 1
            if (image_index >= image_list.count) {
                image_index = 0
            }
        }
    }
    // import image from library ---- search these code from stackflow :
    // @IBAction func importimage(_ sender: Any) and func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    // but a lot of code in imagePickerController() is written myself.
    @IBAction func selectfromlibrary(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let imageData = UIImageJPEGRepresentation(image, 0.6) {
                let compressedJPGImage = UIImage(data: imageData)
                let new_image = compressedJPGImage?.resizeImageWith(newSize: CGSize(width: 100, height: 100))
                imagelogo.image = compressedJPGImage
            }
        } else {
            print("Error: ------ for selecting image from library -----")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //name.delegate = self
        //location.delegate = self
        //rate.delegate = self
        
        // flag and editting name is designed to judge whether to edit or to add.
        init_label()
        if (flag) {
            //editting_label.text = "input the new value"
            self.title = "Edit the restaurant"
            name.text = restaurant.name
            location.text = restaurant.location
            rate.text = String(restaurant.rating)
            isneed.isOn = restaurant.isneedpublish
            latitude.text = String(restaurant.latitude)
            longtitude.text = String(restaurant.longitude)
            imagelogo.image = UIImage(data: restaurant.logo as! Data)
        } else {
            imagelogo.image = UIImage(named: image_list[image_index])
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        // copy Notifiaction.default from stackflaw
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantDetailViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantDetailViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }
    
    
    // locationManager ---- from the tutorial ----
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc: CLLocation = locations.last!
        currentLocation = loc.coordinate
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_click(_ sender: UIButton) {
        // save the data
        if (flag) {
            guard let tmp = Int(rate.text!) else {
                let alter = UIAlertController(title: "warning", message: "please input right number for rating",preferredStyle: UIAlertControllerStyle.alert)
                let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                    print("ok-operation")
                }
                alter.addAction(alertView1)
                self.present(alter, animated: true, completion: nil)
                return
            }
            if tmp<=0 || tmp>5 {
                let alter = UIAlertController(title: "warning", message: "please input right number for rating",preferredStyle: UIAlertControllerStyle.alert)
                let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                    print("ok-operation")
                }
                alter.addAction(alertView1)
                self.present(alter, animated: true, completion: nil)
                return
            }
            guard let longs = Double(longtitude.text!) else {
                let alter = UIAlertController(title: "warning", message: "wrong value for longitude",preferredStyle: UIAlertControllerStyle.alert)
                let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                    print("ok-operation")
                }
                alter.addAction(alertView1)
                self.present(alter, animated: true, completion: nil)
                return
            }
            guard let lat = Double(latitude.text!) else {
                let alter = UIAlertController(title: "warning", message: "wrong value for latitude",preferredStyle: UIAlertControllerStyle.alert)
                let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                    print("ok-operation")
                }
                alter.addAction(alertView1)
                self.present(alter, animated: true, completion: nil)
                return
            }
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let one_rest = restaurant
            //context.delete(one)
            context.delete(one_rest!)
            let one = Restaurant(context: context)
            one.name = name.text
            let imagedata = UIImagePNGRepresentation(imagelogo.image!)
            one.setValue(imagedata, forKey: "logo")
            one.rating = Int16(rate.text!)!
            one.location = location.text
            one.isneedpublish = isneed.isOn
            one.date_added_year = (one_rest?.date_added_year)!
            one.date_added_month = (one_rest?.date_added_month)!
            one.date_added_day = (one_rest?.date_added_day)!
            one.date_added_hour = (one_rest?.date_added_hour)!
            one.date_added_minute = (one_rest?.date_added_minute)!
            one.date_added_second = (one_rest?.date_added_second)!
            one.latitude = lat
            one.longitude = longs
            one.category = cate
            one.radius = (one_rest?.radius)!
            //print("343543")
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController!.popViewController(animated: true)
            return
        }
        guard let longs = Double(longtitude.text!) else {
            let alter = UIAlertController(title: "warning", message: "wrong value for longitude",preferredStyle: UIAlertControllerStyle.alert)
            let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                print("ok-operation")
            }
            alter.addAction(alertView1)
            self.present(alter, animated: true, completion: nil)
            return
        }
        guard let lat = Double(latitude.text!) else {
            let alter = UIAlertController(title: "warning", message: "wrong value for latitude",preferredStyle: UIAlertControllerStyle.alert)
            let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                print("ok-operation")
            }
            alter.addAction(alertView1)
            self.present(alter, animated: true, completion: nil)
            return
        }
        var timers: [Int] = []
        //let alter = UIAlertController(title: "warning", message: "please input right number for rating",preferredStyle: UIAlertControllerStyle.alert)
        guard let tmp = Int(rate.text!) else {
            let alter = UIAlertController(title: "warning", message: "please input right number for rating",preferredStyle: UIAlertControllerStyle.alert)
            let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                print("ok-operation")
            }
            alter.addAction(alertView1)
            self.present(alter, animated: true, completion: nil)
            return
        }
        if tmp<=0 || tmp>5 {
            let alter = UIAlertController(title: "warning", message: "please input right number for rating",preferredStyle: UIAlertControllerStyle.alert)
            let alertView1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in
                print("ok-operation")
            }
            alter.addAction(alertView1)
            self.present(alter, animated: true, completion: nil)
            return
        }

        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        timers.append(comps.year! % 2000)
        timers.append(comps.month!)
        timers.append(comps.day!)
        timers.append(comps.hour!)
        timers.append(comps.minute!)
        timers.append(comps.second!)
        timers.append(comps.weekday! - 1)
        print(timers)
        print(cate)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let one = Restaurant(context: context)
        one.name = name.text
        let imagedata = UIImagePNGRepresentation(imagelogo.image!)
        one.setValue(imagedata, forKey: "logo")
        one.rating = Int16(rate.text!)!
        one.location = location.text
        one.isneedpublish = isneed.isOn
        one.date_added_year = Int64(timers[0])
        one.date_added_month = Int16(timers[1])
        one.date_added_day = Int16(timers[2])
        one.date_added_hour = Int16(timers[3])
        one.date_added_minute = Int16(timers[4])
        one.date_added_second = Int16(timers[5])
        one.latitude = lat
        one.longitude = longs
        one.category = cate
        one.radius = 1000
        print("343543")
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
    }

    @IBAction func getCurrentPosition(_ sender: Any) {
        self.latitude.text = "\(currentLocation!.latitude)"
        self.longtitude.text = "\(currentLocation!.longitude)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // func touchesBegan() and textFieldShouldReturn() ----- use them to dismiss keyboard--- copy from stackflow
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



