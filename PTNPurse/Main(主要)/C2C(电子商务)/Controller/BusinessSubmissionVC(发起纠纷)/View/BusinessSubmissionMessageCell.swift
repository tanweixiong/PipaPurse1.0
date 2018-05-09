//
//  BusinessSubmissionMessageCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessSubmissionMessageCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var dataLab: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    var model = BusinessSubmissionMsgModel(){
        didSet{
            titleLab.text = model?.remark
            dataLab.text = model?.dateStr!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backgroundVw)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
