//
//  YourProfileViewController.swift
//  EpitechEisenhower
//
//  Created by Mc Fly on 19/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let reuseIdentifier = "cell"
    
    
    
    override func viewDidLoad() {
        let currentUser = Auth.auth().currentUser
        let userID = currentUser?.uid
        let refDB = Database.database().reference()
        let items = ["testItem"]
        
    (refDB.child("users").child(userID!).child("tasks")).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print("task object")
            print(value)
            //let username = value?["username"] as? String ?? ""
           // let user = User(username: username)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TaskViewCellCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.taskLabel.text = "This is but a test"
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}

