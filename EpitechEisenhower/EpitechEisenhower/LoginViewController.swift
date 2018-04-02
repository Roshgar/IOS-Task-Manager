//
//  ViewController.swift
//  EpitechEisenhower
//
//  Created by fauquette fred on 25/09/17.
//  Copyright © 2017 Epitech. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseDatabase


class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleConnectButton: GIDSignInButton!;
    @IBOutlet weak var connectButton: UIButton!
    var refDB : DatabaseReference!;
    var appDelegate : AppDelegate!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = AppDelegate()
        self.refDB = Database.database().reference()
        title = "Login"
        connectButton.layer.cornerRadius = 5
        GIDSignIn.sharedInstance().uiDelegate = self
        if (Auth.auth().currentUser != nil) {
           // self.performSegue(withIdentifier: "showHome", sender: nil)
            
            do {
                try Auth.auth().signOut()
            }   catch let signOutError as NSError{
                    print("Error signing out : %@", signOutError)
                }
            }
    }

    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            //self.appDelegate.logToFirebase(credential: credential)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                self.appDelegate.tryAddUserToDB()
                // Add user to DB if not present
                /*
                let currentUser = Auth.auth().currentUser
                let userID = Auth.auth().currentUser?.uid
                //
                self.refDB.child("users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if (value == nil) {
                        self.refDB.child("users").child(userID!).setValue(["name" : currentUser?.displayName])
                    }
                    else {
                         print(currentUser?.displayName)
                    }
                   
                    
                })
 */
                // Redirect to Home
                self.performSegue(withIdentifier: "showHome", sender: nil)
                
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func googleConnect(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func logInFirebase(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

