//
//  SelectedViewController.swift
//  Snapchat
//
//  Created by Fatma Khan on 5/16/19.
//  Copyright © 2019 sadiw wafi. All rights reserved.
//

import UIKit
import FirebaseStorage
class SelectedViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
  
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func SelectPhotoTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func SelectCameraTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func presentAlert(alert:String){
        let alertVC =  UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let theAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(theAction)
        present(alertVC, animated: true, completion: nil)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
       
        imageAdded = true
        if let message = messageTextField.text {
            if imageAdded && message != "" {
                 let images_folder =  FIRStorage.storage().reference().child("images")
               if  let image = imageView.image {
                if let image_data = UIImageJPEGRepresentation(image, 0.1){
                    images_folder.child("\(NSUUID().uuidString).jpg").put(image_data, metadata: nil) { (metaata, error) in
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        }else{
                            if let downloadURL = metaata?.downloadURL()?.absoluteString{
                            self.performSegue(withIdentifier: "selectReciverSugue", sender: downloadURL)
                        
                            }
                        }
                        
                    }
                }
                }
             
                
             // Segue to the next controller
            }else{
               presentAlert(alert: "you must have photo and message for your snap")
            }
 }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectReceiverTableViewController {
             selectVC.downloadURL = downloadURL
                
               
            }
        }
    }
//
//    func presentAlert(alert:String) {
//        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
//            alertVC.dismiss(animated: true, completion: nil)
//        }
//        alertVC.addAction(okAction)
//        present(alertVC, animated: true, completion: nil)
//    }
}
