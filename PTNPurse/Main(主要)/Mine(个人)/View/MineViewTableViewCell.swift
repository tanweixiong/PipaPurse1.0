//
//  MineViewTableViewCell.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/19.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

enum MineViewTableViewCellType {
    case noright
    case checkmark
    case arrow
    case label
    
}

class MineViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    var shadowView: UIView?
    
    var viewType: MineViewTableViewCellType? {
        didSet {
            if viewType! == .arrow {
                rightImageView.isHidden = false
            } else if viewType! == .label {
                rightLabel.isHidden = false
            } else if viewType! == .checkmark {
                checkmarkImageView.isHidden = false
            } else {
                rightImageView.isHidden = true
                rightLabel.isHidden = true
                checkmarkImageView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        leftLabel.textColor = R_ZYMineViewGrayColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        Tools.setViewShadow(bgview)
    }
    
    
    func addShadowView() {
        shadowView = UIView.init(frame: CGRect.init(x: 2, y: 0, width: self.bounds.width, height: self.bounds.height - 2))
        shadowView?.backgroundColor = UIColor.clear
        shadowView?.layer.shadowColor = R_ZYCellShadowColor.cgColor
        shadowView?.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        shadowView?.layer.shadowRadius = 5
        shadowView?.layer.shadowOpacity = 1
        self.insertSubview(shadowView!, aboveSubview: self.contentView)
        
    }
}
