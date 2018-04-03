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

extension UIColor {
    public convenience init?(hexString : String) {
        let r, g, b, a: CGFloat
        if (hexString.hasPrefix("#")) {
            let start = hexString.index(hexString.startIndex, offsetBy : 1)
            let hexColor = String(hexString[start...])
            if (hexColor.count == 8) {
                let scanner = Scanner(string : hexColor)
                var hexNumber: UInt64 = 0
                if (scanner.scanHexInt64(&hexNumber)) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}



class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = "cell"
    var items = [NSDictionary]()
    var taskToPass : Int!

    override func viewDidLoad() {
        let currentUser = Auth.auth().currentUser
        let userID = currentUser?.uid
        let refDB = Database.database().reference()
        refDB.child("users").child(userID!).child("tasks").observe(.childRemoved, with: {(snapshot) in
            self.collectionView!.reloadData()
        })
        refDB.child("users").child(userID!).child("tasks").observe(.childChanged, with: {(snapshot) in
                self.collectionView!.reloadData()
            })
        refDB.child("users").child(userID!).child("tasks").observe(.childAdded, with: { (snapshot) in
            let obj = snapshot.value as! NSDictionary
            self.items.append(Task(label: obj["label"]! as! String, desc: obj["desc"]! as! String, date: obj["date"]! as! String, urgent: Bool.init(obj["urgent"]! as! String)!, important: Bool.init(obj["important"]! as! String)!, id: snapshot.key).returnTaskAsDictionary())
            self.collectionView!.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ////print ("in collection view count ", self.items.count)
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (self.items.count == 0) {
            
        }
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TaskViewCellCollectionViewCell
        let isImportant = self.items[indexPath.row]["important"] as! Bool
        let isUrgent = self.items[indexPath.row]["urgent"] as! Bool
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.taskLabel.text = self.items[indexPath.row]["label"] as! String
        cell.taskDate.text = self.items[indexPath.row]["date"] as? String
        if (isImportant && isUrgent) {
            cell.backgroundColor = UIColor(hexString: "#ff3a07CC")
        }
        else if (isImportant) {
            cell.urgentButton.alpha = 0.2
            cell.backgroundColor = UIColor(hexString: "#0da0b2CC")
        }
        else if (isUrgent) {
            cell.importantButton.alpha = 0.2
            cell.backgroundColor = UIColor(hexString: "#7ed321CC")
        }
        else {
            cell.importantButton.alpha = 0.2
            cell.urgentButton.alpha = 0.2
            cell.backgroundColor = UIColor(hexString: "#f8e81c66")
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        //print("You selected cell #\(indexPath.item)!")
        self.taskToPass = indexPath.item
        self.performSegue(withIdentifier: "editTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editTask") {
            let destinationVC:TaskDetailsViewController = segue.destination as! TaskDetailsViewController
            destinationVC.task = self.items[self.taskToPass]
        }
        else if (segue.identifier == "addTask"){
            let destinationVC:TaskDetailsViewController = segue.destination as! TaskDetailsViewController
            destinationVC.task = nil
        }
    }
}

