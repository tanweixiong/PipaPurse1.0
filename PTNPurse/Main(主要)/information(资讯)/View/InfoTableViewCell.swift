//
//  InfoTableViewCell.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/22.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SDWebImage

class InfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var browseLab: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    var info: InformationData? {
        didSet {
            titleLabel.text = (info?.newsTitle)! + ""
            dateLabel.text = info?.createTime == nil ? "" : (info?.createTime)! + ""
            
            if let imageurl = info?.newsImg {
                self.infoImageView.sd_setImage(with: URL.init(string: imageurl), placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            }
         
            if let seeNum = info?.seeNum {
                self.browseLab.text = (seeNum.stringValue)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}
