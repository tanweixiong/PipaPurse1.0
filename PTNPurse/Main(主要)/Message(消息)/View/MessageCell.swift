//
//  MessageCell.swift
//  PTNPurse
//
//  Created by tam on 2018/3/27.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    let panRecognizer = UIPanGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(){
        addSubview(contentVw)
        contentVw.addSubview(avatarImageVw)
        contentVw.addSubview(titleLab)
        contentVw.addSubview(headingContentLab)
        
        avatarImageVw.sd_setImage(with: NSURL(string: "")! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        titleLab.text = "123"
        headingContentLab.text = "456"
    }
    
    override func willTransition(to state: UITableViewCellStateMask) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001, execute: {
            print(self.subviews)
             for subView in self.subviews {
                if NSStringFromClass(subView.classForCoder) == "_UITableViewCellSeparatorView"{
                }
            }
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    lazy var contentVw: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 15, y: 0, width: SCREEN_WIDTH - 30, height: 80)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.9)
        Tools.setViewShadow(view)
        return view
    }()
    
    lazy var avatarImageVw: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 15, y: 12, width: 55, height: 55)
        imageView.centerY = contentVw.centerY
        return imageView
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(x: avatarImageVw.frame.maxX + 10, y: 23, width: SCREEN_WIDTH, height: 20)
        lab.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var headingContentLab: UILabel = {
        let lab = UILabel()
        lab.frame = CGRect(x: avatarImageVw.frame.maxX + 10, y: titleLab.frame.maxY + 3, width: SCREEN_WIDTH, height: 17)
        lab.textColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()

}
