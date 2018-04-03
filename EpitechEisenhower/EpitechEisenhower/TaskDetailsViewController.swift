//
//  TaskDetailsViewController.swift
//  EpitechEisenhower
//
//  Created by Mc Fly on 19/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class TaskDetailsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var taskDesc: UITextView!
    @IBOutlet weak var taskLabel: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    
    @IBOutlet weak var peopleSearch: UIView!
    
    var task : NSDictionary!
    
    @IBAction func openPeopleSearchButton(_ sender: Any) {
        peopleSearch.isHidden = false;
    }
    
    @IBAction func CloseSearch(_ sender: Any) {
        peopleSearch.isHidden = true;
    }
    
    var importantState : Bool! = false
    @IBAction func importantButtonClicked(_ sender: UIButton) {
        
        if (importantState) {
            //Second Tap
            sender.alpha = 0.5;
            importantState = false
        } else {
            //First Tap
            sender.alpha = 1;
            importantState = true
        }
    }
    var urgentState : Bool! = false
    @IBAction func urgentButtonClicked(_ sender: UIButton) {
        
        if (urgentState) {
            //Second Tap
            sender.alpha =  0.5;
            urgentState = false
        } else {
            //First Tap
            sender.alpha = 1;
            urgentState = true
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    // get people list here
    let data = [
        "Jean Loic",
        "Jean Claude",
        "Jean Marie",
        "Jean délavé"
    ]
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importantButton.adjustsImageWhenHighlighted = false;
        urgentButton.adjustsImageWhenHighlighted = false;
        taskLabel.textContainer.maximumNumberOfLines = 3
            searchBar.placeholder = nil;
        
        
        if (self.task != nil) {
            taskDesc.text = self.task["desc"]! as! String
            taskLabel.text = self.task["label"]! as! String
            dateTextField.text = self.task["date"]! as? String
            importantState = Bool.init(exactly: self.task["important"]! as! NSNumber)
            urgentState = Bool.init(exactly: self.task["urgent"]! as! NSNumber)
        }

    
        tableView.dataSource = self
        searchBar.delegate = self
        filteredData = data
        
        let cellNib = UINib(nibName: "NibTableViewCell", bundle: Bundle.main)
        
    
        tableView.register(cellNib, forCellReuseIdentifier: "TableCell")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    @IBAction func deleteTask(_ sender: Any) {
        let key = self.task["uid"]! as! String
        let refDB = Database.database().reference()
        let currentUser = Auth.auth().currentUser

        let userID = currentUser?.uid
        print("In delete taks ", key)
    refDB.child("users").child(userID!).child("tasks").child(key).removeValue()
        let alertController = UIAlertController(title: "Deletion", message: "The task was correctly deleted. Due to the machinations of gremlins, please reload the home page to see updated list" , preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func saveTask(_ sender: Any) {
        let desc = taskDesc.text
        let date = dateTextField.text
        let label = taskLabel.text
        
        let important = String(importantState);
        let urgent = String(urgentState);
        
        let currentUser = Auth.auth().currentUser
        let userID = currentUser?.uid
        let refDB = Database.database().reference()
        var key: String
        
        if (self.task == nil) {
            key = refDB.child("users").child(userID!).child("tasks").childByAutoId().key
        }
        else {
            key = self.task["uid"]! as! String
        }
        
        let task = ["label" : label!, "date": date, "desc": desc, "important" : important, "urgent" : urgent]
        
        let childUpdates = ["users/\(userID!)/tasks/\(key)" : task]
        refDB.updateChildValues(childUpdates)
    }
    
    // Because apparently DatePickers weren't thought of when designing the template.
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(TaskDetailsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    // See above
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
}


