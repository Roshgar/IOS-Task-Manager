//
//  YourProfileViewController.swift
//  EpitechEisenhower
//
//  Created by Mc Fly on 19/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class YourProfileViewController: UIViewController {
  
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        profilePic.clipsToBounds = true;
    }
    
    
    
    /*
     let vc = UIStoryBoard(name:"Main", bundle : nil).instantiateViewController(withIdentifier: "HomeViewController")
     present(vc!, animated: true, completion: nil)
     */
    @IBAction func logUserOut(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
            // self.performSegue(withIdentifier: "showHome", sender: nil)
            
            do {
                try Auth.auth().signOut()
            }   catch let signOutError as NSError{
                print("Error signing out : %@", signOutError)
            }
        }
        //let vc = UIStoryboard(name:"Main", bundle : nil).instantiateViewController(withIdentifier: "LoginViewController")
        //present(vc, animated: true, completion: nil)
        
    }
    
}
