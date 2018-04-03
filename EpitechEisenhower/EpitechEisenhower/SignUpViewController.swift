//
//  SignUpController.swift
//  EpitechEisenhower
//
//  Created by khaldor on 02/04/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    var appDelegateRef: AppDelegate!;
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegateRef = AppDelegate()
    }
    
    @IBAction func resgisterUser(_ sender: Any) {
        let login = loginTextField.text
        let email = emailTextField.text
        let passw = passwordTextField.text
        
        if ((login?.isEmpty)! || (email?.isEmpty)! || (passw?.isEmpty)!) {
            // Display error
            let myAlert = UIAlertController(title:"Error During SignUp", message:"All fields are required", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            myAlert.addAction(okAction)
            self.present(myAlert, animated:true, completion:nil)
            return;
        }
        else {
            Auth.auth().createUser(withEmail: email!, password: passw!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = login
                    changeRequest?.commitChanges{(error) in
                        print(Auth.auth().currentUser?.displayName)
                        print(error)
                        self.appDelegateRef.tryAddUserToDB()
                    }
                    let storyboard = UIStoryboard(name : "Main", bundle : nil)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let viewController : HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
                    rootViewController.pushViewController(viewController, animated : true)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
}
