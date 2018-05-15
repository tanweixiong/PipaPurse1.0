//
//  MineMiningCell.swift
//  PTNPurse
//
//  Created by tam on 2018/5/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineMiningCell: UITableViewCell {
    @IBOutlet weak var icomLab: UILabel!
    @IBOutlet weak var dataLab: UILabel!
    
    
    var model = HomeMiningListModel(){
        didSet{
            
            if let bonus = model?.bonus {
                icomLab.text = Tools.setNSDecimalNumber(bonus)
            }
            
            if let data = model?.date {
                dataLab.text = data as String
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
