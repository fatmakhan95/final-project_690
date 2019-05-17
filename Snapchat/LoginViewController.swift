//
//  LoginViewController.swift
//  Snapchat
//
//  Created by Fatma Khan on 5/16/19.
//  Copyright © 2019 sadiw wafi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    var signUpMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func presentAlert(alert:String){
        let alertVC =  UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let theAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(theAction)
        present(alertVC, animated: true, completion: nil)
    }
    @IBAction func loginbuttonTapped(_ sender: Any) {
        if let email = emailTextField.text{
            if let password = passwordTextField.text{
                if signUpMode {
                    // we need to sign up
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error{
                            self.presentAlert(alert: error.localizedDescription)
                        }else{
                            if let user = user {
                                FIRDatabase.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                                self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            }
                        }
                    })
                    
                }else{
                    // we log in
                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error{
                            self.presentAlert(alert: error.localizedDescription)
                        }else{
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    })
                }
                
            }
        }
    
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        if signUpMode {
            signUpMode = false
            loginButton.setTitle("Sign In", for: .normal)
            signUpButton.setTitle("Create account", for: .normal)
            
        }else{
            signUpMode = true
            loginButton.setTitle("Sign Up", for: .normal)
            signUpButton.setTitle("Sign In", for: .normal)
        }
    }
    
}

