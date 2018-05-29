//
//  HomeSubmitConvertVC.swift
//  PipaPurse
//
//  Created by tam on 2018/5/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeSubmitConvertVC: MainViewController {
    fileprivate lazy var  viewModel : BaseViewModel = BaseViewModel()
    var fakebalance = String() //现有资产
    var availableAssets = String()
    
    @IBOutlet weak var availableLab: UILabel!
    @IBOutlet weak var freezeLab: UILabel!
    @IBOutlet weak var convertBtn: UIButton!{
        didSet{
            convertBtn.layer.borderWidth = 1
            convertBtn.layer.borderColor = R_UIThemeColor.cgColor
            convertBtn.setTitle(LanguageHelper.getString(key: "convert"), for: .normal)
        }
    }
    @IBOutlet weak var navi: UIView!{
        didSet{
            navi.backgroundColor = R_UIThemeColor
        }
    }
    @IBOutlet weak var convertNumLab: UILabel!{
        didSet{
            convertNumLab.text = LanguageHelper.getString(key: "C2C_publish_order_Number")
        }
    }
    @IBOutlet weak var convertNumTF: UITextField!{
        didSet{
            convertNumTF.placeholder = LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_number_of_transactions")
            convertNumTF.keyboardType = .numberPad
            convertNumTF.delegate = self
            
        }
    }
    var model = HomeWalletsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func convertOnClick(_ sender: UIButton) {
        let convertNum = self.convertNumTF.text!
        if convertNum.count != 0 {
            let newConvertStr = convertNum.subString(start: 0, length: 1)
            if newConvertStr == "0" {
                SVProgressHUD.showInfo(withStatus:LanguageHelper.getString(key: "Home_Conver_Transactions_Number"))
                return
            }
            let input = PaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            input?.delegate = self
            input?.show()
        }else{
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_Enter_Conversion_Prompt"))
        }
    }
    
    @IBAction func onClick(_ sender: Any) {
         self.view.endEditing(true)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeSubmitConvertVC {
    func setupUI(){
         setNormalNaviBar(title:LanguageHelper.getString(key: "Home_Alert_Conver"))
         availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：" + self.fakebalance
         freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：" + self.availableAssets
    }
}

extension HomeSubmitConvertVC:PaymentPasswordDelegate{
    func inputPaymentPassword(_ pwd: String!) -> String! {
        let parameters = ["token":(UserDefaults.standard.getUserInfo().token)!,"number":self.convertNumTF.text!,"password":pwd.md5()]
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIChangeCoin, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "homePage_Details_Conversion_Finish"))
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationHomeConvertReload), object: nil)
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                  self.navigationController?.popViewController(animated: true)
            })
        }
        return pwd
    }
    
    func inputPaymentPasswordChangeForgetPassword() {
        let forgetvc = ModifyTradePwdViewController()
        forgetvc.type = ModifyPwdType.tradepwd
        forgetvc.status = .modify
        forgetvc.isNeedNavi = false
        self.navigationController?.pushViewController(forgetvc, animated: true)
    }
}


