//
//  MineMiningRankingVC.swift
//  PTNPurse
//
//  Created by tam on 2018/5/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineMiningRankingVC: UITableViewCell {
    @IBOutlet weak var iconImageVw: UIImageView!
    @IBOutlet weak var priceLab: UILabel!
    @IBOutlet weak var usernameLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model = HomeMiningListModel(){
        didSet{
            if let photo = model?.photo {
                iconImageVw.sd_setImage(with: NSURL(string: photo as String)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            }
            
            if let username = model?.username {
                usernameLab.text = username as String
            }
            
            if let price = model?.bonus {
                priceLab.text = Tools.setNSDecimalNumber(price)
            }

        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
