//
//  PlantTableViewCell.swift
//  FMaandag-pset6
//
//  Cell in tableview with owned plants
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class PlantTableViewCell: UITableViewCell {

    @IBOutlet weak var myPlantNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
