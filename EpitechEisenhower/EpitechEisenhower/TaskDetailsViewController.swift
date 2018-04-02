//
//  TaskDetailsViewController.swift
//  EpitechEisenhower
//
//  Created by Mc Fly on 19/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import Foundation
import UIKit

class TaskDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskLabel.textContainer.maximumNumberOfLines = 3
    }
    
    @IBAction func AddPeopleButton(_ sender: Any) {
        
    }
    
    
}
