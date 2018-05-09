//
//  SettingPaypsdVC.swift
//  DHSWallet
//
//  Created by tam on 2017/9/6.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit
import UXPasscodeField
import SVProgressHUD
import ObjectMapper

protocol SettingPaypsdDelegate {
    func settingPaypsdFinish(password:String)
}
class SettingPaypsdVC: MainViewController {
     fileprivate let baseViewModel = BaseViewModel()
    var delegate:SettingPaypsdDelegate?
    let passcodeField =  UXPasscodeField()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置支付密码"
        self.view.backgroundColor = UIColor.R_UIRGBColor(red: 240, green: 242, blue: 245, alpha: 1)
        setNormalNaviBar(title: "设置支付密码")
        
        let sizes:CGSize = titlesLabel.getStringSize(text: titleLabel.text!, size: CGSize(width: SCREEN_WIDTH - 40, height: CGFloat(MAXFLOAT)), font: 17)
        titleLabel.frame = CGRect(x: 20, y: MainViewControllerUX.naviNormalHeight, width: sizes.width, height: sizes.height)
        self.view.addSubview(titleLabel)

        passcodeField.frame = CGRect(x: 30, y:titleLabel.frame.maxY + 10 , width: SCREEN_WIDTH - 60, height: 45)
        passcodeField.isSecureTextEntry = true
        passcodeField.addTarget(self, action: #selector(SettingPaypsdVC.passcodeFieldDidChangeValue), for: .valueChanged)
        self.view.addSubview(passcodeField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func passcodeFieldDidChangeValue() {
        if passcodeField.passcode.characters.count == 6 {
//            self.setPayPassword(password: passcodeField.passcode)
        }
    }
    
//    func setPayPassword(password:String) {
//        let parameters = ["username":]
//        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPISetTradePwd, parameters: <#T##[String : Any]?#>, showIndicator: <#T##Bool#>, finishedCallback: <#T##(HomeBaseModel) -> ()#>)
//
//    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.settingPaypsdFinish(password: passcodeField.passcode)
    }
    
    lazy var titlesLabel:UILabel = {
        let label = UILabel()
//        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "请设置支付密码，建议勿与银行卡取款密码相同"
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        return label
    }()

}
