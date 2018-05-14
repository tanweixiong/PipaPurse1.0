//
//  IntegralApplicationStatusCell.swift
//  BCPPurse
//
//  Created by tam on 2018/4/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class IntegralApplicationStatusCell: UITableViewCell {
    @IBOutlet weak var iconImgeVw: UIImageView!
    @IBOutlet weak var headingLab: UILabel!
    @IBOutlet weak var statusBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
