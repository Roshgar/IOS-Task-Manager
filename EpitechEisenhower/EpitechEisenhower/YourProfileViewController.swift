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
import FirebaseDatabase
import FirebaseStorage


class YourProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descTextField: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var refDB : DatabaseReference!
    var refStorage: Storage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.refStorage = Storage.storage()
        let currentUser = Auth.auth().currentUser
        let userID = currentUser?.uid
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2;
        profilePic.clipsToBounds = true;
        self.refDB = Database.database().reference()
        self.refDB.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nameTextField.text = value?["name"] as? String
            self.emailTextField.text = currentUser?.email
            
            if (value?["desc"] != nil) {
                self.descTextField.text = value?["desc"] as! String
            }
            if (value?["img"] != nil) {
                let downloadUrl = value?["img"] as! String
                let storageRef = self.refStorage.reference(forURL: downloadUrl)
                print("hello, in retrieval")
                storageRef.getData(maxSize: 15 * 1024 * 1024) {(data, error) -> Void in
                    print("error is ", error)
                    let pic = UIImage(data: data!)
                    self.imageView.image = pic
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        self.refDB.child("users").child(userID!).child("img").observe(.childAdded, with : { (snapshot) in
            let downloadUrl = snapshot.value as! String
            let storageRef = self.refStorage.reference(forURL: downloadUrl)
            storageRef.getData(maxSize: 15 * 1024 * 1024) {(data, error) -> Void in
                let pic = UIImage(data: data!)
                self.imageView.image = pic
            }
        })
        
    }
    
    
    @IBAction func updateUser(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
        let userID = currentUser?.uid
        
        
        
        // Retrieve values of fields
        let nameField = nameTextField.text
        let descField = descTextField.text
        let emailField = emailTextField.text
        
        // Update fields individually (Less heavy than loading up all tasks and pushing everything)
        let updates = ["users/\(userID!)/name" : nameField,
                       "users/\(userID!)/desc" : descField,
                       "users/\(userID!)/email" : emailField]
        if (emailField != currentUser?.email) {
            currentUser?.updateEmail(to: emailField!)
        }
        refDB.updateChildValues(updates)
    }
    
    @IBAction func logUserOut(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            
            do {
                try Auth.auth().signOut()
            }   catch let signOutError as NSError{
                print("Error signing out : %@", signOutError)
            }
        }
    }
    
    
    @IBAction func resetPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) {(error) in
            if (error != nil) {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
           
        }
    }
    
    
    @objc func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info : [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion : nil)
        let userID = (Auth.auth().currentUser?.uid)!
        let storageRef = self.refStorage.reference().child(userID)
        if let uploadData = UIImagePNGRepresentation(self.imageView.image!) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print(error!)
                    return
                }
                let downloadURL = metadata.downloadURL()?.absoluteString
                let updates = ["users/\(userID)/img" : downloadURL as String!]
                self.refDB.updateChildValues(updates)
            
            
            }
        }
        
    }
    
    
    @IBAction func addUserImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated : true, completion : nil)
    }
    
    
    
}
