//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Ender Güzel on 20.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeText: UILabel!
    @IBOutlet weak var memeTopText: UILabel!
    @IBOutlet weak var memeBottomText: UILabel!
    
    override var editingStyle: UITableViewCell.EditingStyle {
        return .delete
    }
    
}
