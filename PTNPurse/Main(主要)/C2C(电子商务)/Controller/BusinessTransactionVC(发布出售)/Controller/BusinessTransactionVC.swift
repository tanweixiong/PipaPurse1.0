//
//  BusinessSellVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import YYText
import SVProgressHUD
import ObjectMapper

class BusinessTransactionVC: MainViewController {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    fileprivate lazy var coinViewModel : BusinessVM = BusinessVM()
    fileprivate var chooseCoin = BusinessCoinModel()
    var style = BusinessTransactionStyle.buyStyle
    fileprivate var paymentMethod = String()
    fileprivate var bankCardId = String()
    fileprivate var headingArray =
        [LanguageHelper.getString(key: "C2C_publish_order_Currency")
        ,LanguageHelper.getString(key: "C2C_publish_order_Receiving")
        ,LanguageHelper.getString(key: "C2C_publish_order_Number")
        ,LanguageHelper.getString(key: "C2C_publish_order_Unit")
        ,LanguageHelper.getString(key: "C2C_publish_order_Limit")
        ,LanguageHelper.getString(key: "C2C_publish_order_Message")]
    fileprivate let headingContentArray =
        [LanguageHelper.getString(key: "C2C_publish_order_Select_the_type_of_currency_you_trade")
        ,LanguageHelper.getString(key: "C2C_publish_order_Alipay_Wechat_bankCard")
        ,LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_number_of_transactions")
        ,LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_transaction_unit_price")
        ,LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_minimum_transaction_limit_amount")
        ,LanguageHelper.getString(key: "C2C_publish_order_Enter_information_to_inform_each_other")]
    fileprivate let homeTransferCell = "HomeTransferCell"
    fileprivate let homeTransferRemarksCell = "HomeTransferRemarksCell"
    fileprivate let coinArray = NSMutableArray()
    fileprivate var coinNameTF = UITextField()
    fileprivate var methodTF = UITextField()
    fileprivate var transactionsNumTF = UITextField()
    fileprivate var transactionsPriceTF = UITextField()
    fileprivate var transactionsMinTF = UITextField()
    fileprivate var methodType = String()
    fileprivate var remarkTV = YYTextView()
    fileprivate var remarksCell = HomeTransferRemarksCell()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setReplace()
        setupUI()
        getCoin()
        BusinessVC.setPaymentData()
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessTransactionVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object:nil)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeTransferCell", bundle: nil),forCellReuseIdentifier: self.homeTransferCell)
        tableView.register(UINib(nibName: "HomeTransferRemarksCell", bundle: nil),forCellReuseIdentifier: self.homeTransferRemarksCell)
        tableView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xEDEDED)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        return tableView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.transactionsPriceTF {
           return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: R_UIThemePostPurchasePriceLimit)
        } else if  textField == self.transactionsNumTF {
             return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: R_UIThemePostPurchaseLimit)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BusinessTransactionVC {
    func setupUI(){
        let title = self.style == .buyStyle ? LanguageHelper.getString(key: "C2C_home_transaction_purchase") : LanguageHelper.getString(key: "C2C_home_transaction_sale")
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: title)
        view.addSubview(tableView)
    }
    
    func submitOnClick(){
         if Tools.noPaymentPasswordIsSetToExecute() == false{return}
        if checkInput() {
            let input = InputPaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT),isNormal:true)
            input?.delegate = self
            input?.setPaymentPasswordAlertPriceTitle("")
            input?.setPaymentPasswordAlertHandicapCostTitle("")
            input?.setPaymentPasswordAlertPrice("")
            input?.setPaymentPasswordAlertHandicapCost("")
            input?.paymentPasswordAlertVw.height = 190
            input?.show()
        }
    }
    
    func checkInput()->Bool{
        let coinName = coinNameTF.text!
        let method = methodTF.text!
        let transactionsNum = transactionsNumTF.text!
        let transactionsPrice = transactionsPriceTF.text!
        let transactionsMin = transactionsMinTF.text!
        
        if coinName == "" {
            return false
        }
        
        if method == "" {
            return false
        }
        
        if transactionsNum == "" {
            return false
        }
        
        if transactionsPrice == "" {
            return false
        }
        
        if transactionsMin == "" {
            return false
        }
        return true
    }
    
    //获取币种
    func getCoin(){
        let parameters = ["state":"3","type":"3"]
        coinViewModel.loadCoinSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetCoin, parameters: parameters, showIndicator: false) {
            for item in 0...self.coinViewModel.coinModel.count {
                if item != self.coinViewModel.coinModel.count {
                    let model = self.coinViewModel.coinModel[item]
                    self.coinArray.add(model.coinName!)
                }
            }
        }}
    
    func postData(tradePassword:String){
        let transactionsNum = transactionsNumTF.text!
        let transactionsPrice = transactionsPriceTF.text!
        let transactionsMin = transactionsMinTF.text!
        let token = UserDefaults.standard.getUserInfo().token!
        let coinNo = (self.chooseCoin?.id?.stringValue)!
        let remarks = remarksCell.textView?.text!
        let md5Psd = tradePassword.md5()
        var parameters = [
            "token":token
            ,"language":Tools.getLocalLanguage()
            ,"coinNo":coinNo
            ,"tradeType": style == .buyStyle ? "buy" : "sell"
            ,"tradePrice":transactionsPrice
            ,"tradeNum":transactionsNum
            ,"receivablesType":methodType
            ,"minPrice":transactionsMin
            ,"tradePassword":md5Psd
            ,"remark":remarks
        ]
        
        //如果是银行卡则需要多传
        if self.bankCardId != "" {
            parameters =  [
                "token":token
                ,"language":Tools.getLocalLanguage()
                ,"coinNo":coinNo
                ,"tradeType": style == .buyStyle ? "buy" : "sell"
                ,"tradePrice":transactionsPrice
                ,"tradeNum":transactionsNum
                ,"receivablesType":methodType
                ,"minPrice":transactionsMin
                ,"tradePassword":md5Psd
                ,"remark":remarks
                ,"bankcardId":self.bankCardId
            ]
        }
        
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIAddSpotEntrust, parameters: parameters as Any as? [String : Any] , showIndicator: false) { (model:HomeBaseModel) in
            let responseData = Mapper<BusinessLiberateFinishDataModel>().map(JSONObject: model.data)
            if  model.code == Tools.noPaymentPasswordSetCode(){
                let setPwdVC = ModifyTradePwdViewController()
                setPwdVC.type = ModifyPwdType.tradepwd
                setPwdVC.isNeedNavi = false
                self.navigationController?.pushViewController(setPwdVC, animated: true)
                return
            }
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_publish_order_Successful_advertisement"))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationC2CReload), object: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                let businessWantFinishVC = BusinessWantFinishVC()
                businessWantFinishVC.style = .liberateStyle
                businessWantFinishVC.liberateStyle = self.style
                businessWantFinishVC.orderNo = (responseData?.entrustId?.stringValue)!
                businessWantFinishVC.coinName = self.coinNameTF.text!
                businessWantFinishVC.liberateStyle = self.style
                self.navigationController?.pushViewController(businessWantFinishVC, animated: true)
            })
        }
    }
    
    //根据名称获取对象
    func getCoinObject(coinName:String){
        for (index,value) in coinArray.enumerated() {
            let newValue = value as! String
            if newValue.contains(coinName){
                self.chooseCoin = self.coinViewModel.coinModel[index]
                return
            }
        }
    }
    
    func setReplace(){
        let dataArray = NSMutableArray()
        dataArray.addObjects(from: headingArray)
        let text = style == .buyStyle ? LanguageHelper.getString(key: "C2C_publish_order_Your_payment_method") : LanguageHelper.getString(key: "C2C_publish_order_Your_have_payment_method")
        dataArray.replaceObject(at: 1, with: text)
        self.headingArray = dataArray as! [String]
    }
}

extension BusinessTransactionVC: InputPaymentPasswordDelegate{
    func inputPaymentPassword(_ pwd: String!) -> String! {
        postData(tradePassword: pwd)
        return pwd
    }
    
    func inputPaymentPasswordChangeForgetPassword() {
        let forgetvc = ModifyTradePwdViewController()
        forgetvc.type = ModifyPwdType.tradepwd
        forgetvc.status = .modify
        forgetvc.isNeedNavi = false
        self.navigationController?.pushViewController(forgetvc, animated: true)
    }
    
    @objc func textFieldTextDidChangeOneCI(notification:NSNotification){
        if checkInput() {
            remarksCell.submitBtn.isSelected = true
            remarksCell.submitBtn.isEnabled = true
        }else{
            remarksCell.submitBtn.isSelected = false
            remarksCell.submitBtn.isEnabled = false
        }
        setSubmitBtnStyle()
    }
    
    func changeSubmitStyle(){
        if checkInput() {
            remarksCell.submitBtn.isSelected = true
            remarksCell.submitBtn.isEnabled = true
        }else{
            remarksCell.submitBtn.isSelected = false
            remarksCell.submitBtn.isEnabled = false
        }
        setSubmitBtnStyle()
    }
    
    func setSubmitBtnStyle(){
        if remarksCell.submitBtn.isSelected {
            remarksCell.submitBtn.backgroundColor = R_UIThemeColor
            remarksCell.submitBtn.layer.borderWidth = 0
        }else{
            remarksCell.submitBtn.backgroundColor = UIColor.clear
            remarksCell.submitBtn.layer.borderWidth = 1
            remarksCell.submitBtn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
        }
    }
}

extension BusinessTransactionVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headingArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 5 {
            return YMAKE(70)
        }else{
            return 400
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < 2 {
            if indexPath.row == 0 {
                let coin = self.coinArray
                BRStringPickerView.showStringPicker(withTitle: LanguageHelper.getString(key: "C2C_publish_order_Please_select_your_trading_currency"), dataSource: coin as! [Any], defaultSelValue: "BTC", isAutoSelect: false, resultBlock: { (coinName:Any) in
                    let coinName = coinName as! String
                    self.coinNameTF.text = coinName
                    self.getCoinObject(coinName: coinName)
                    self.changeSubmitStyle()
                })
            }else if indexPath.row == 1 {
                view.endEditing(true)
                let listArray = NSMutableArray()
                let weChat = UserDefaults.standard.getUserInfo().weChat
                
                if  weChat != "" && weChat != nil {
                    listArray.add(LanguageHelper.getString(key: "C2C_payment_WeChat") + weChat!)
                }else{
                    listArray.add(LanguageHelper.getString(key: "C2C_payment_WeChat"))
                }
                
                let alipay = UserDefaults.standard.getUserInfo().apay
                if  alipay != "" && alipay != nil {
                    listArray.add(LanguageHelper.getString(key: "C2C_payment_Alipay") + alipay!)
                }else{
                    listArray.add(LanguageHelper.getString(key: "C2C_payment_Alipay"))
                }
                listArray.add(LanguageHelper.getString(key: "C2C_payment_Bankcard"))
                
                BRStringPickerView.showStringPicker(withTitle: LanguageHelper.getString(key: "C2C_publish_order_Please_select_your_receiving_method"), dataSource: listArray as! [Any]
                  , defaultSelValue: nil, isAutoSelect: false, resultBlock: { (method:Any) in
                    self.paymentMethod = method as! String //用于支付方式
                    let method = method as! String
                    var account = String()
                    if method.contains(LanguageHelper.getString(key: "C2C_payment_Bankcard")) {
                        let mineBankCardBindingVC = MineBankCardBindingVC()
                        mineBankCardBindingVC.delegate = self
                        mineBankCardBindingVC.style = .selectStyle
                        self.navigationController?.pushViewController(mineBankCardBindingVC, animated: true)
                        return
                    }else if method.contains(LanguageHelper.getString(key: "C2C_payment_Alipay")) {
                        account = method 
                        //前往设置支付宝
                        if alipay == nil {
                            let mineSetAccountVC = MineSetAccountVC()
                            mineSetAccountVC.style = .alipayStyle
                            self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                            return
                        }
                        
                        if alipay == "" {
                            let mineSetAccountVC = MineSetAccountVC()
                            mineSetAccountVC.style = .alipayStyle
                            self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                            return
                        }
                        
                    }else if method.contains(LanguageHelper.getString(key: "C2C_payment_WeChat")){
                        account = method
                        //前往设置微信
                        if weChat == nil {
                            let mineSetAccountVC = MineSetAccountVC()
                            mineSetAccountVC.style = .weChatStyle
                            self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                            return
                        }
                        
                        if weChat == "" {
                            let mineSetAccountVC = MineSetAccountVC()
                            mineSetAccountVC.style = .weChatStyle
                            self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                            return
                        }
                        
                    }
                    self.methodTF.text = account
                    self.methodType = Tools.getPaymentMethod(method)
                    self.changeSubmitStyle()
                })
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         closeKeyboard()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTransferCell, for: indexPath) as! HomeTransferCell
            cell.selectionStyle = .none
            cell.headingLabel.text = headingArray[indexPath.row]
            cell.textfield.placeholder = headingContentArray[indexPath.row]
            cell.textfield.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
            if indexPath.row < 2{
                cell.triangularBtn.isHidden = false
                cell.textfield.isUserInteractionEnabled = false
            }else{
                cell.unitLab.isHidden = false
                cell.unitLab.text = indexPath.row == 3 ? "CNY" : LanguageHelper.getString(key: "C2C_mine_My_advertisement_Num")
            }
            if indexPath.row == 0 {
                self.coinNameTF = cell.textfield
            }else if indexPath.row == 1 {
                self.methodTF = cell.textfield
            }else if indexPath.row == 2 {
                cell.textfield.keyboardType = .decimalPad
                cell.textfield.delegate = self
                self.transactionsNumTF = cell.textfield
            }else if indexPath.row == 3 {
                cell.textfield.keyboardType = .decimalPad
                cell.textfield.delegate = self
                self.transactionsPriceTF = cell.textfield
            }else if indexPath.row == 4 {
                cell.textfield.keyboardType = .decimalPad
                self.transactionsMinTF = cell.textfield
            }
            return cell
        }else{
            remarksCell = tableView.dequeueReusableCell(withIdentifier: homeTransferRemarksCell, for: indexPath) as! HomeTransferRemarksCell
            remarksCell.selectionStyle = .none
            remarksCell.submitBtn.setTitle(LanguageHelper.getString(key: "C2C_publish_order_Submit_release"), for: .normal)
            remarksCell.submitBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xCED7E6), for: .normal)
            remarksCell.submitBtn.setTitleColor(UIColor.white, for: .selected)
            setSubmitBtnStyle()
            remarksCell.remarkLabel.text = LanguageHelper.getString(key: "C2C_publish_order_Message")
            remarksCell.textView?.placeholderText = LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_remarks")
            remarksCell.textView?.placeholderFont = UIFont.systemFont(ofSize: 14)
            remarksCell.textView?.textColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
            remarksCell.HomeTransferRemarksBlock = {self.submitOnClick()}
            self.remarkTV = remarksCell.textView!
            remarksCell.setData()
            return remarksCell
        }
    }
}

extension BusinessTransactionVC:MineBankCardBindingDelegate{
    func mineBankCardBindingSelectFinish(id: String, bankCardName: String, bankCardNum: String) {
        self.methodTF.text = bankCardName + bankCardNum
        self.methodType = Tools.getPaymentMethod(LanguageHelper.getString(key: "C2C_payment_Bankcard"))
        self.bankCardId = id
        self.changeSubmitStyle()
    }
}

