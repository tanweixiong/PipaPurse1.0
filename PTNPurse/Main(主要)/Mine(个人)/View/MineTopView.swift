//
//  MineTopView.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/19.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class MineTopView: ILXibView, UITextFieldDelegate {

    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var sellBtn: UIButton!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameTextFeild: UITextField!
    @IBOutlet weak var nameEditBtn: UIButton!
    @IBOutlet weak var headEditBtn: UIButton!
    
    @IBOutlet weak var headImageHeightConstraint: NSLayoutConstraint!
    
    var buyBtnCallBack: BtnClickCallBack?
    var sellBtnCallBack: BtnClickCallBack?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViewStyle()
    }
    
    func setBuyBtnBlock(block:@escaping  BtnClickCallBack) {
        self.buyBtnCallBack = block
    }
    
    func setSellBtnBlock(block:@escaping  BtnClickCallBack) {
        self.sellBtnCallBack = block
    }
    
    func setViewStyle() {
        
        buyBtn.setTitleColor(R_ZYMineViewGrayColor, for: .normal)
        buyBtn.titleLabel?.font = UIFont.init(name: R_ThemeFontName, size: 15)
        sellBtn.setTitleColor(R_ZYMineViewGrayColor, for: .normal)
        sellBtn.titleLabel?.font = UIFont.init(name: R_ThemeFontName, size: 15)
        
        headImageView.layer.borderWidth = 1
        headImageView.layer.borderColor = UIColor.white.cgColor
        headImageView.setViewBoarderCorner(radius: headImageHeightConstraint.constant / 2)
        
        nameTextFeild.delegate = self
        
    }
    

    
    @IBAction func buyBtnTouched(_ sender: UIButton) {
        
        if buyBtnCallBack != nil {
            buyBtnCallBack!(sender)
        }
        
    }
    
    @IBAction func sellBtnTouched(_ sender: UIButton) {
        
        if sellBtnCallBack != nil {
            sellBtnCallBack!(sender)
        }
    }
    
    @IBAction func nameEditBtnTouched(_ sender: UIButton) {
        nameTextFeild.becomeFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        modifyUserName()
        return true
        
    }
    
    // MARK: - NetWork Method
    func modifyUserName() {
        
        let token = SingleTon.shared.userInfo?.token!
        let userno = SingleTon.shared.userInfo?.id!
        let params = ["token" : token!, "nickName":nameTextFeild.text!,"userNo": userno!] as [String : Any]
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIUpdataUserName, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            let result = Mapper<NodataResponse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    SingleTon.shared.userInfo?.username = result?.data
                    self.nameTextFeild.text = result?.data!
                    return
                } else if code == -1 {
                    SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_tokenout"))
                    Tools.switchToLoginViewController()
                } else {
                    SVProgressHUD.showError(withStatus: result?.message!)
                }
                self.nameTextFeild.text = SingleTon.shared.userInfo?.username
            }
        }) { (error) in
            self.nameTextFeild.text = SingleTon.shared.userInfo?.username
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
        
    }
    
    
    
}
