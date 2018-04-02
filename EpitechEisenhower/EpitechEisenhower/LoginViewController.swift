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
    
    @IBOutlet weak var googleConnectButton: GIDSignInButton!;
    @IBOutlet weak var connectButton: UIButton!
    var refDB : DatabaseReference!;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refDB = Database.database().reference()
        title = "Login"
        connectButton.layer.cornerRadius = 5
        GIDSignIn.sharedInstance().uiDelegate = self
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
                
                // Add user to DB if not present
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
    
    // segue showHome is executed twice, TOFIX
    @IBAction func connect(_ sender: Any) {
        performSegue(withIdentifier: "showHome", sender: nil)
    }

}

