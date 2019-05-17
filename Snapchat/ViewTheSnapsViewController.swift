//
//  ViewTheSnapsViewController.swift
//  Snapchat
//
//  Created by Fatma Khan on 5/16/19.
//  Copyright © 2019 sadiw wafi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage
class ViewTheSnapsViewController: UIViewController {

    @IBOutlet weak var messageLabelView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var imageName = ""
    var snap : FIRDataSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String {
                if let imageURL = snapDictionary["imageURL"] as? String {
                    messageLabelView.text = description
                    
                    if let url = URL(string: imageURL) {
                        
                        imageView.sd_setImage(with: url)
                    }
                    if let imageName = snapDictionary["imageName"] as? String {
                        self.imageName = imageName
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserUid = FIRAuth.auth()?.currentUser?.uid {
            
            if let key = snap?.key {
                FIRDatabase.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue()
                
                FIRStorage.storage().reference().child("images").child(imageName).delete(completion: nil)
            }
            
        }
        
        
    }
    

}
