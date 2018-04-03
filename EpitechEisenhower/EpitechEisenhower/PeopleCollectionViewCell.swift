//
//  PeopleCollectionViewCell.swift
//  EpitechEisenhower
//
//  Created by Mc Fly on 02/04/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class PeopleCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var profileImage: UIImageView!
    
    func viewDidLoad() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
        profileImage.clipsToBounds = true;
        
    }
    
}
