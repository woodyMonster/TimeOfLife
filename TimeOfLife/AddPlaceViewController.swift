//
//  addPlaceViewController.swift
//  bicyclePark
//
//  Created by 王志輝 on 2017/6/21.
//  Copyright © 2017年 Woody. All rights reserved.
//

import UIKit
import CoreData

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var timeOfLife:TimeOfLifeMO!

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    
    @IBAction func seveButton(_ sender: AnyObject) {
        if areaTextField.text == "" || dateTextField.text == "" || addressTextField.text == "" || descriptionTextfield.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "請輸入資料", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if let appDel = UIApplication.shared.delegate as? AppDelegate {
            timeOfLife = TimeOfLifeMO(context: appDel.persistentContainer.viewContext)
            timeOfLife.date = dateTextField.text
            timeOfLife.area = areaTextField.text
            timeOfLife.address = addressTextField.text
            timeOfLife.descriptions = descriptionTextfield.text
            
            if let timeOfLifeImage = photoImageView.image {
                if let imageData = UIImagePNGRepresentation(timeOfLifeImage) {
                    timeOfLife.image = NSData(data: imageData)
                }
            }
            appDel.saveContext()
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func pickerImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //  背景透明
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // 視窗動畫
        containerView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0, animations: { self.containerView.transform = CGAffineTransform.identity
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
