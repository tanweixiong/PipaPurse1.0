//
//  MessageInformationVw.swift
//  PTNPurse
//
//  Created by tam on 2018/3/27.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MessageInformationVw: UIView {
    @IBOutlet weak var headingLab: UILabel!
    @IBOutlet weak var headingContentLab: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headingLab.text = "最新资讯"
        headingContentLab.text = "本网站所有图片及影视，音乐素材均....."
        avatarImageView.sd_setImage(with:NSURL(string: "" )! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
    }

}

