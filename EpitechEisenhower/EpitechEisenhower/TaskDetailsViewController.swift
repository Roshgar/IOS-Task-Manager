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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskLabel.textContainer.maximumNumberOfLines = 3
        
    }
    
    @IBAction func AddPeopleButton(_ sender: Any) {
        
    }
    
    
    @IBAction func saveTask(_ sender: Any) {
        let desc = taskDesc.text
        let date = dateTextField.text
        let label = taskLabel.text
        let currentUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        let refDB = Database.database().reference()
        
        let key = refDB.child("users").child(userID!).child("posts").childByAutoId().key
        let task = ["label" : label, "date": date, "desc": desc]
        
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
