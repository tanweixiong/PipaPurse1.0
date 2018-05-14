//
//  BusinessRelaseCell.swift
//  PTNPurse
//
//  Created by tam on 2018/5/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessRelaseCell: UITableViewCell {
    @IBOutlet weak var thinLinesVw: UIView!
    @IBOutlet weak var thickLinesVw: UIView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var unitLab: UILabel!
    @IBOutlet weak var headContentLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
