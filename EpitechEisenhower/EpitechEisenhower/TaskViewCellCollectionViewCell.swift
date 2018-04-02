//
//  TaskViewCellCollectionViewCell.swift
//  EpitechEisenhower
//
//  Created by Mc Fly on 02/04/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class TaskViewCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskLabel: UITextView!
    
    func viewDidLoad() {
        //super.viewDidLoad()
        taskLabel.textContainer.maximumNumberOfLines = 3
        
    }
    
}
