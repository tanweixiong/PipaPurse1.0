//
//  BusinessInviteFriendsVw.swift
//  PTNPurse
//
//  Created by tam on 2018/4/8.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessInviteFriendsVw: UIView {
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var avatarImageVw: UIImageView!
    @IBOutlet weak var backGroundVw: UIView!
    @IBOutlet weak var tableBackGroundVw: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var priceTitleLab: UILabel!
    @IBOutlet weak var personTitleLab: UILabel!
    
    @IBOutlet weak var nicknameLab: UILabel!
    @IBOutlet weak var invitationCodeLab: UILabel!
    @IBOutlet weak var sumPriceLab: UILabel!
    @IBOutlet weak var sumNumberLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Tools.setViewShadow(backGroundVw)
        Tools.setViewShadow(tableBackGroundVw)
        
        priceTitleLab.text = Tools.getAppCoinName()
        personTitleLab.text = LanguageHelper.getString(key: "person_People")
        shareBtn.setTitle(LanguageHelper.getString(key: "person_Inviting_friends"), for: .normal)
    }
    
    
    var model = InviteFriendsModel(){
        didSet{
            let url = model?.userphoto == nil ? "" : model?.userphoto
            avatarImageVw.sd_setImage(with: NSURL(string: url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            nicknameLab.text = model?.username!
            invitationCodeLab.text = model?.invitationCode == nil ? "" : (model?.invitationCode)!
            sumPriceLab.text = model?.sumPrice == nil ? "" : (model?.sumPrice)!
            sumNumberLab.text = model?.sumNumber == nil ? "" : (model?.sumNumber)!
        }
    }
}
