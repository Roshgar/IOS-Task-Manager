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
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    
    func viewDidLoad() {
        //super.viewDidLoad()
        taskLabel.textContainer.maximumNumberOfLines = 3
        
        /*
        if (importantButton.state == false) {
            importantButton.alpha = 0.5;
        }
        if (urgentButton.state == false) {
            urgentButton.alpha = 0.5;
        }
         */
    }
    
}
