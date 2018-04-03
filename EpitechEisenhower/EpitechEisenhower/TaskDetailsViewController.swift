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

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskDesc: UITextView!
    @IBOutlet weak var taskLabel: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    
    @IBOutlet weak var peopleSearch: UIView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        importantButton.adjustsImageWhenHighlighted = false;
        urgentButton.adjustsImageWhenHighlighted = false;
        taskLabel.textContainer.maximumNumberOfLines = 3
        
    }
    
    @IBAction func AddPeopleButton(_ sender: Any) {
        
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
        
        let key = refDB.child("users").child(userID!).child("posts").childByAutoId().key
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
