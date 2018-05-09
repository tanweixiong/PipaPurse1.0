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
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
    var info: Information? {
        didSet {
            titleLabel.text = info?.newsTitle
            contentLabel.text = info?.newsSummary
            let dateDouble = Double((info?.createTime)! / 1000)
            dateLabel.text = Tools.timeStampToString(timeStamp: dateDouble)
            
            if let imageurl = info?.newsImg {
                self.infoImageView.sd_setImage(with: URL.init(string: imageurl), placeholderImage: UIImage.init(named: "ic_defaultPicture"))

            }
             
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = R_ZYMineViewGrayColor
        contentLabel.textColor = R_GrayColor
        dateLabel.textColor = R_ZYPlaceholderColor
        infoImageView.setViewBoarderCorner(radius: 3)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        self.selectionStyle = .none
        
       Tools.setViewShadow(self.bgView)
    }
    
}
