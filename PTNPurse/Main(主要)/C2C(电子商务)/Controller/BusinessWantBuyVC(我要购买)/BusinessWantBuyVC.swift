//
//  BusinessWantBuyVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

struct BusinessWantBuyData {
    var avatarUrl: String?
    var entrustPrice: NSNumber?
    var entrustMaxPrice:NSNumber?
    var entrustMinPrice:NSNumber?
    var remark: String?
    var name:String?
    var coinCore:String?}

class BusinessWantBuyVC: MainViewController {
    var style = BusinessTransactionStyle.buyStyle
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    fileprivate lazy var detailsViewModel : BusinessVM = BusinessVM()
    fileprivate var paymentMethod = String()
    fileprivate var bankCardNumber = String()
    fileprivate var bankCardId = String()
    fileprivate var bank = String()
    fileprivate var retentionNumber:Int = 4 //保留币种4位小数
    fileprivate var retentionCny:Int = 2 //保留CNY2位小数
    var businessWantBuyData = BusinessWantBuyData()
    var detailsModel = BusinessModel()
    var isDetails = false
    var entrustNo = String()
    var receivablesType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getDetailsData()
        BusinessVC.setPaymentData()
    }
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        let height =  isDetails ? 0 : 50
        scrollView.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height:SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight - CGFloat(height))
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var businessView: BusinessTransactionView = {
        let view = Bundle.main.loadNibNamed("BusinessTransactionView", owner: nil, options: nil)?.last as! BusinessTransactionView
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: 191)
        view.model = self.detailsModel
        return view
    }()
    
    lazy var businessTransactionDeView: BusinessTransactionDeView = {
        let view = Bundle.main.loadNibNamed("BusinessTransactionDeView", owner: nil, options: nil)?.last as! BusinessTransactionDeView
        view.frame = CGRect(x: 0, y: businessView.frame.maxY , width: SCREEN_WIDTH, height: 165)
        view.model = self.detailsModel
        return view
    }()
    
    lazy var businessConvertView: BusinessConvertView = {
        let view = Bundle.main.loadNibNamed("BusinessConvertView", owner: nil, options: nil)?.last as! BusinessConvertView
        view.frame = CGRect(x: 0, y: businessTransactionDeView.frame.maxY , width: SCREEN_WIDTH, height: 220)
        view.coinNameLab.text = businessWantBuyData.coinCore
        view.disNameLab.text = "CNY"
        view.disPriceTF.isEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(HomeCertificationVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: view.coinNumTF)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeCertificationVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: view.disPriceTF)
        view.disPriceTF.isUserInteractionEnabled = self.isDetails ? false : true
        view.coinNumTF.isUserInteractionEnabled = self.isDetails ? false : true
        view.isHidden = self.isDetails ? true : false
        view.coinNumTF.placeholder = self.style == .buyStyle ? LanguageHelper.getString(key: "C2C_home_Please_enter_the_purchase") : LanguageHelper.getString(key: "C2C_home_Please_enter_the_number_of_sales")
        view.disPriceTF.placeholder = LanguageHelper.getString(key: "C2C_home_Converted_amount")
        view.disPriceTF.delegate = self
        view.disPriceTF.tag = 1
        view.coinNumTF.textColor = UIColor.R_UIColorFromRGB(color: 0x4D4F51)
        view.coinNumTF.delegate = self
        view.coinNumTF.tag = 2
        view.disPriceTF.textColor = UIColor.R_UIColorFromRGB(color: 0x4D4F51)
        view.coinNameLab.textColor = UIColor.R_UIColorFromRGB(color: 0x4D4F51)
        view.disNameLab.textColor = UIColor.R_UIColorFromRGB(color: 0x4D4F51)
        return view
    }()
    
    lazy var submitBtn : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 50, width:SCREEN_WIDTH, height: 50))
        let style = self.style == .buyStyle ? LanguageHelper.getString(key: "C2C_mine_My_advertisement_Buy") : LanguageHelper.getString(key: "C2C_mine_My_advertisement_Sell")
        button.setTitle(style, for: .normal)
        button.addTarget(self, action: #selector(BusinessWantBuyVC.submitOnClick), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCAE9FD)
        button.isHidden = isDetails ? true : false
        return button
    }()
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
           return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: retentionNumber)
        }else if textField.tag == 1 {
           return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: retentionCny)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BusinessWantBuyVC {
    func setupUI(){
         let style = self.style == .buyStyle ? LanguageHelper.getString(key: "C2C_home_I_want_to_buy") : LanguageHelper.getString(key: "C2C_home_I_want_to_sell")
         let titles = isDetails ? LanguageHelper.getString(key: "C2C_mine_My_advertisement_details") : style
         setNormalNaviBar(title: titles)
         view.addSubview(scrollView)
         view.addSubview(submitBtn)
         scrollView.addSubview(businessView)
         scrollView.addSubview(businessTransactionDeView)
         scrollView.addSubview(businessConvertView)
        let contentSize_height = isDetails ? 20 : 180
         scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: businessConvertView.frame.maxY + CGFloat(contentSize_height))
    }
    
    func postData(tradePassword:String){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let entrustNo = self.entrustNo
        let tradeNum = businessConvertView.coinNumTF.text!
        let md5Psd = tradePassword.md5()
        let remark = businessTransactionDeView.remarkLab.text!
        let language = Tools.getLocalLanguage()
        var parameters = ["token":token
            ,"entrustNo":entrustNo
            ,"tradeNum":tradeNum
            ,"tradePassword":md5Psd
            ,"remark":remark
            ,"language":language
            ] as [String : Any]
        
        //如果是银行卡则需要多传
        if receivablesType == "1" {
            parameters = ["token":token
                ,"entrustNo":entrustNo
                ,"tradeNum":tradeNum
                ,"tradePassword":md5Psd
                ,"remark":remark
                ,"language":language
                ,"bankId":self.bankCardId
                ] as [String : Any]
        }
    
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPISpotTrade, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
             if model.code == Tools.noPaymentPasswordSetCode(){
                let setPwdVC = ModifyTradePwdViewController()
                setPwdVC.type = ModifyPwdType.tradepwd
                setPwdVC.isNeedNavi = false
                self.navigationController?.pushViewController(setPwdVC, animated: true)
                return
            }
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Successful_purchase"))
            let responseData = Mapper<BusinessBuyFinishDataModel>().map(JSONObject: model.data)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                let finishVC = BusinessWantFinishVC()
                finishVC.phoneNum = self.businessWantBuyData.name!
                finishVC.orderNo = (responseData?.orderId?.stringValue)!
                finishVC.style = .buyFinishStyle
                self.navigationController?.pushViewController(finishVC, animated: true)
            })
        }
    }
    
    func setSubmitBtnStyle(){
        if submitBtn.isSelected {
            submitBtn.backgroundColor = R_UIThemeColor
        }else{
            submitBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCAE9FD)
        }
    }
    
    @objc func submitOnClick(){
        let listArray = NSMutableArray()
        if receivablesType == "1" {
            self.paymentMethod = self.bank + self.bankCardNumber
            if self.paymentMethod == "" {
                listArray.add(LanguageHelper.getString(key: "C2C_payment_Bankcard"))
            }else{
                listArray.add(self.paymentMethod)
            }
        }else if receivablesType == "4"{
            listArray.add(LanguageHelper.getString(key: "C2C_payment_Other"))
        }else if receivablesType == "2"{
            var account = UserDefaults.standard.getUserInfo().apay
            account = account != nil && account != "" ? UserDefaults.standard.getUserInfo().apay : ""
            let type = Tools.getPaymentDetailsMethod(receivablesType) + account!
            listArray.add(type)
            self.paymentMethod = account!
        }else if receivablesType == "3"{
            var account = UserDefaults.standard.getUserInfo().weChat
            account = account != nil && account != "" ? UserDefaults.standard.getUserInfo().weChat : ""
            let type = Tools.getPaymentDetailsMethod(receivablesType) + account!
            listArray.add(type)
            self.paymentMethod = account!
        }  
    
        BRStringPickerView.showStringPicker(withTitle: LanguageHelper.getString(key: "binding_Please_choose_a_payment_method"), dataSource: listArray as! [Any]
            , defaultSelValue: nil, isAutoSelect: false, resultBlock: { (method:Any) in
                //设置银行卡
                if self.paymentMethod == "" && self.receivablesType == "1" {
                    let mineBankCardBindingVC = MineBankCardBindingVC()
                    mineBankCardBindingVC.delegate = self
                    mineBankCardBindingVC.style = .selectStyle
                    self.navigationController?.pushViewController(mineBankCardBindingVC, animated: true)
                    return
                }
                
                //设置支付宝
                if self.paymentMethod == "" &&  self.receivablesType == "2"{
                    let mineSetAccountVC = MineSetAccountVC()
                    mineSetAccountVC.style = .alipayStyle
                    self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                    return
                }
                
                //设置微信
                if self.paymentMethod == "" &&  self.receivablesType == "3" {
                    let mineSetAccountVC = MineSetAccountVC()
                    mineSetAccountVC.style = .weChatStyle
                    self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                    return
                }
                self.setupPaymentPassword()
        })
    }
    
    @objc func textFieldTextDidChangeOneCI(notification:NSNotification){
        let coinNum = businessConvertView.coinNumTF.text!
        self.submitBtn.isSelected = coinNum != "" ?  true : false
        self.submitBtn.isEnabled = coinNum != "" ? true : false
        setSubmitBtnStyle()
        //判断是哪个输入框
        let textField = notification.object as! UITextField
        let str = textField.text!
        if str.count != 0 {
            let specialStr = str.subString(start: 0, length: 1)
            if specialStr == "."{
                businessConvertView.coinNumTF.text = ""
                businessConvertView.disPriceTF.text = ""
                return
            }
        }
        if textField == businessConvertView.coinNumTF {
              let num = businessConvertView.coinNumTF.text!
              if num == "" || textField.text! == "" {
                businessConvertView.coinNumTF.text = ""
                businessConvertView.disPriceTF.text = ""
                return
            }
              let price = self.businessWantBuyData.entrustPrice
              let cny = (price?.floatValue)! * Float(num)!
              businessConvertView.disPriceTF.text = String(format: "%.2f", cny)
        }else{
            let cny = businessConvertView.disPriceTF.text!
            if cny == "" || textField.text! == ""
            {
                businessConvertView.coinNumTF.text = ""
                businessConvertView.disPriceTF.text = ""
                return
            }
            let price = self.businessWantBuyData.entrustPrice
            let newprice =  Float(cny)! / (price?.floatValue)!
            businessConvertView.coinNumTF.text = String(format: "%.4f", newprice)
        }
    }
    
    func checkInput()->Bool{
        if businessConvertView.coinNumTF.text == "" && businessConvertView.disPriceTF.text == "" {
            if businessConvertView.coinNumTF.text == "" {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_transaction_Please_enter_the_purchase_quantity"))
                return false
            }
            
            if businessConvertView.disPriceTF.text == "" {
                SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_transaction_Please_enter_the_converted_amount"))
                return false
            }
        }
        
        let max = businessWantBuyData.entrustMaxPrice?.floatValue
        let min = businessWantBuyData.entrustMinPrice?.floatValue
        let inpunt = Float(businessConvertView.coinNumTF.text!)!
        if CGFloat(inpunt) > CGFloat(max!){
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_transaction_Input_cannot_be_greater_than_the_maximum_limit"))
            return false
        }
        if CGFloat(inpunt) < CGFloat(min!) {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_transaction_Input_cannot_be_greater_than_the_minimum_limit"))
            return false
        }
        return true
    }
    
    func setupPaymentPassword(){
         if Tools.noPaymentPasswordIsSetToExecute() == false{return}
        if self.checkInput() {
            let input = InputPaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT),isNormal:true)
            input?.delegate = self
            input?.setPaymentPasswordAlertPriceTitle("")
            input?.setPaymentPasswordAlertHandicapCostTitle("")
            input?.setPaymentPasswordAlertPrice("")
            input?.setPaymentPasswordAlertHandicapCost("")
            input?.paymentPasswordAlertVw.height = 190
            input?.paymentPasswordAlertVw.titleLabel.text = LanguageHelper.getString(key: "homePage_Prompt_Enter_PayPassword")
            input?.paymentPasswordAlertVw.forgetPwdBtn.setTitle(LanguageHelper.getString(key: "forget_password"), for: .normal)
            input?.show()
        }
    }
    
    //查看订单详情
    func getDetailsData(){
        let parameters = ["id":self.entrustNo,"language":Tools.getLocalLanguage()]
        detailsViewModel.loadLiberateSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetSpotEntrustById, parameters: parameters, showIndicator: false, finishedCallback: {
            if self.detailsViewModel.liberateModel.username != nil {
                self.businessView.model = self.detailsViewModel.liberateModel
                self.businessTransactionDeView.model = self.detailsViewModel.liberateModel
            }
        })
    }
}

extension BusinessWantBuyVC:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        closeKeyboard()
    }
}

extension BusinessWantBuyVC :InputPaymentPasswordDelegate{
    
    func inputPaymentPassword(_ pwd: String!) -> String! {
        self.postData(tradePassword: pwd)
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

extension BusinessWantBuyVC:MineBankCardBindingDelegate{
    func mineBankCardBindingSelectFinish(id: String, bankCardName: String, bankCardNum: String) {
         self.bank = bankCardName
         self.bankCardNumber = bankCardNum
         self.bankCardId = id
    }
}
