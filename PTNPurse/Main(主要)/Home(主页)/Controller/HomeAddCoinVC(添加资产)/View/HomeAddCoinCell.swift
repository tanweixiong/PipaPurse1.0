//
//  HomeAddCoinCell.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeAddCoinCell: UITableViewCell {
    @IBOutlet weak var switchFunc: UISwitch!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    var homeAddCoinBlock:((UISwitch)->())?;
    var model: HomeAddCoinListModel = HomeAddCoinListModel()!{
        didSet{
            nameLabel.text = model.coinName == nil ? "--" : model.coinName
            let url = model.coinImg == nil ? "" : model.coinImg
            iconImage.sd_setImage(with: NSURL(string: url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        switchFunc.onTintColor = R_UIThemeColor
        
        switchFunc.tintColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)//边缘
        switchFunc.backgroundColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
        switchFunc.layer.cornerRadius = switchFunc.bounds.height/2.0
        switchFunc.layer.masksToBounds = true
        
        Tools.setViewShadow(backgroundVw)
    }

    @IBAction func switchClick(_ sender: UISwitch) {
        if self.homeAddCoinBlock != nil {
            self.homeAddCoinBlock!(sender);
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
