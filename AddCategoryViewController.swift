//
//  AddCategoryViewController.swift
//  Restaurant Locator
//  add and edit the category
//  Created by pro on 2017/9/4.
//  Copyright © 2017年 pro. All rights reserved.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imagelogo: UIImageView!
    @IBOutlet weak var name: UITextField!
    var editing_name = ""
    var flag = false
    var one_cate: Categoryss?
    var image_list = ["cafelore.jpg","forkeerestaurant.jpg","posatelier.jpg","traif.jpg"]
    var image_index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print(editing_name)
        // flag and editting name is designed to judge whether to edit or to add.

        if (editing_name != "") {
            name.text = editing_name
            //editing_label.text = "input the new name for this category"
            self.title = "Edit category"
            imagelogo.image = UIImage(data: self.one_cate?.logo! as! Data)
            flag = true
        } else {
            imagelogo.image = UIImage(named: image_list[image_index])
        }
        //editing_label?.text = editing_name
        // Do any additional setup after loading the view.
    }
    
    // import image from library ---- search these code from stackflow : 
    // @IBAction func importimage(_ sender: Any) and func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    // but a lot of code in imagePickerController() is written myself.
    @IBAction func importimage(_ sender: Any) {
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // random select image from my dataset
    @IBAction func random_select(_ sender: Any) {
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

    @IBAction func btn_click(_ sender: Any) {
        if flag == true {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            // --- I learn the fetch data method from youtube and I write these code myself.
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categoryss")
            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
            do {
                var results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let one = result.value(forKey: "name") as? String {
                            if (one == editing_name) {
                                result.setValue(name.text!, forKey: "name")
                                let imagedata = UIImagePNGRepresentation(imagelogo.image!)
                                result.setValue(imagedata, forKey: "logo")
                                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            }
                        }
                    }
                }
                results = try context.fetch(fetchRequest2)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let one = result.value(forKey: "category") as? String {
                            if (one == editing_name) {
                                result.setValue(name.text!, forKey: "category")
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
            
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let one_categoy = Categoryss(context: context)
            one_categoy.name = name.text
            //one_categoy.picture = "homei.jpg"
            let imagedata = UIImagePNGRepresentation(imagelogo.image!)
            one_categoy.setValue(imagedata, forKey: "logo")
            //one_categoy.logo
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        navigationController!.popViewController(animated: true)
    }
    
    // func touchesBegan() and textFieldShouldReturn() ----- use them to dismiss keyboard--- copy from stackflow
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
// image process  search them from stackflow
extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
