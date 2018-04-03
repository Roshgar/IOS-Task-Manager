//
//  NibTableViewCell.swift
//  EpitechEisenhower
//
//  Created by Mc Fly on 03/04/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//

import UIKit

class NibTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!

    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
