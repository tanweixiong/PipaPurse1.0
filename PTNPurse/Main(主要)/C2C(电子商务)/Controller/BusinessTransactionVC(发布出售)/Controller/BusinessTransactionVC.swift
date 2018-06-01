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
    fileprivate lazy var mineVM : MineViewModel = MineViewModel()
    fileprivate lazy var coinViewModel : BusinessVM = BusinessVM()
    fileprivate var chooseCoin = BusinessCoinModel()
    var style = BusinessTransactionStyle.buyStyle
    fileprivate var paymentMethod = String()
    fileprivate var bankCardId = String()
    fileprivate var alipayStr = String()
    fileprivate var weChatStr = String()
    fileprivate var marketPriceString = String()
    fileprivate var headingArray =
        [LanguageHelper.getString(key: "C2C_publish_order_Currency")
        ,LanguageHelper.getString(key: "C2C_publish_order_Number")
        ,LanguageHelper.getString(key: "C2C_publish_order_Unit")
        ,LanguageHelper.getString(key: "C2C_publish_order_Limit")
        ,LanguageHelper.getString(key: "C2C_publish_order_Lowest_Price")
        ,LanguageHelper.getString(key: "C2C_Proportion")
        ,LanguageHelper.getString(key: "C2C_publish_order_Message")]
    
    fileprivate let headingContentArray =
        [LanguageHelper.getString(key: "C2C_publish_order_Select_the_type_of_currency_you_trade")
        ,LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_number_of_transactions")
        ,LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_transaction_unit_price")
        ,LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_minimum_transaction_limit_amount")
        ,LanguageHelper.getString(key: "C2C_publish_enter_order_Lowest_Price")
        ,"0.0000"
        ,LanguageHelper.getString(key: "C2C_publish_order_Enter_information_to_inform_each_other")]
    fileprivate let businessRelaseCell = "BusinessRelaseCell"
    fileprivate let homeTransferRemarksCell = "HomeTransferRemarksCell"
    fileprivate let businessReleaseMethodCell = "BusinessReleaseMethodCell"
    fileprivate let businessPremiumCell = "BusinessPremiumCell"
    fileprivate let coinArray = NSMutableArray()
    fileprivate var coinNameTF = UITextField()
    fileprivate var methodTF = UITextField()
    fileprivate var transactionsNumTF = UITextField()
    fileprivate var transactionsPriceTF = UITextField()
    fileprivate var transactionsMinTF = UITextField()
    fileprivate var percentLab = UILabel()
    fileprivate var methodType = String()
    fileprivate var remarkTV = YYTextView()
    fileprivate var remarksCell = HomeTransferRemarksCell()
    fileprivate var selectFirstIndex = IndexPath()
    fileprivate var selectSecondIndex = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCoin()
        BusinessVC.setPaymentData()
        NotificationCenter.default.addObserver(self, selector: #selector(BusinessTransactionVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object:nil)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight - 50))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessRelaseCell", bundle: nil),forCellReuseIdentifier: self.businessRelaseCell)
        tableView.register(UINib(nibName: "BusinessReleaseMethodCell", bundle: nil),forCellReuseIdentifier: self.businessReleaseMethodCell)
        tableView.register(UINib(nibName: "HomeTransferRemarksCell", bundle: nil),forCellReuseIdentifier: self.homeTransferRemarksCell)
        tableView.register(UINib(nibName: "BusinessPremiumCell", bundle: nil),forCellReuseIdentifier: self.businessPremiumCell)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var determineBtn: UIButton = {
        let btn  = UIButton(type: .system)
        btn.setTitle(LanguageHelper.getString(key: "C2C_Determine"), for: .normal)
        btn.frame = CGRect(x: 0, y: tableView.frame.maxY, width: SCREEN_WIDTH, height: 50)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCAE9FD)
        btn.addTarget(self, action: #selector(BusinessTransactionVC.submitOnClick), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    lazy var selectVw: IntegralApplicationStatusVw = {
        let view = Bundle.main.loadNibNamed("IntegralApplicationStatusVw", owner: nil, options: nil)?.last as! IntegralApplicationStatusVw
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height:SCREEN_HEIGHT)
        view.delegare = self
        view.selectedDefault = false
        view.isHidden = true
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.transactionsPriceTF {
           //如果继续输入则溢价为空
           self.percentLab.text = "--"
           return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: R_UIThemePostPurchasePriceLimit)
        } else if  textField == self.transactionsNumTF {
             return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: R_UIThemePostPurchaseLimit)
        } else if textField == self.transactionsMinTF{
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
        setNormalNaviBar(title: title)
        view.addSubview(tableView)
        view.addSubview(determineBtn)
        UIApplication.shared.keyWindow?.addSubview(selectVw)
    }
    
   @objc func submitOnClick(){
         if Tools.noPaymentPasswordIsSetToExecute() == false{return}
         self.getFee()
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
        let parameters = ["state":"1","type":"3"]
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
        let token = (UserDefaults.standard.getUserInfo().token)!
        let coinNo = (self.chooseCoin?.id?.stringValue)!
        let remarks = (remarksCell.textView?.text)!
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
            ,"bankcardId":"0"
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
    
        if transactionsPrice == "0" {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "C2C_mine_My_advertisement_Unit_No_Data"))
            return
        }
        
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIAddSpotEntrust, parameters: parameters , showIndicator: false) { (model:HomeBaseModel) in
//            let responseData = Mapper<BusinessLiberateFinishDataModel>().map(JSONObject: model.data)
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
                let id = model.data == nil ? "" : (model.data)!
                let orderNo = "\(id as Any)"
                let businessWantFinishVC = BusinessWantFinishVC()
                businessWantFinishVC.style = .liberateStyle
                businessWantFinishVC.liberateStyle = self.style
                businessWantFinishVC.orderNo = orderNo
                businessWantFinishVC.coinName = self.coinNameTF.text!
                businessWantFinishVC.liberateStyle = self.style
                self.navigationController?.pushViewController(businessWantFinishVC, animated: true)
            })
        }
    }
    
    //获取手续费
    func getFee(){
        let transactionsNum = transactionsNumTF.text!
        let coinNo = (self.chooseCoin?.id?.stringValue)!
        let parameters = ["coinNo":coinNo,"tradeNumber":transactionsNum]
        mineVM.loadSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetSpotEntrustPoundage, parameters: parameters, showIndicator: false) { (json) in
            let coinCore = (self.mineVM.homeConvertFreeModel.coinCore)!
            let poundage = "≈" + Tools.setNSDecimalNumber(self.mineVM.homeConvertFreeModel.poundage!) + coinCore
            let tradeNumber =  Tools.setNSDecimalNumber(self.mineVM.homeConvertFreeModel.tradeNumber!) + coinCore
            let input = PaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT),isNormal:true)
            input?.delegate = self
            input?.setUpFeesMinersFeesPoundage(poundage, tradeNumber: tradeNumber)
            input?.show()
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
    
    @objc func onClick(_ sender:UIButton){
        view.endEditing(true)
        //选择币种
        if sender.tag == 1 {
            if self.coinArray.count == 0 {return}
            self.selectVw.selectFirstIndex = self.selectFirstIndex
            self.selectVw.selectList = 0
            self.selectVw.dataArray = self.coinArray
        //选择支付方式
        }else if sender.tag == 2 {
            let listArray = NSMutableArray()
            weChatStr = UserDefaults.standard.getUserInfo().weChat!
            if  weChatStr != "" {
                listArray.add(LanguageHelper.getString(key: "C2C_payment_WeChat") + weChatStr)
            }else{
                listArray.add(LanguageHelper.getString(key: "binding_Wechat_account"))
            }
            
            alipayStr = UserDefaults.standard.getUserInfo().apay!
            if  alipayStr != "" {
                listArray.add(LanguageHelper.getString(key: "C2C_payment_Alipay") + alipayStr)
            }else{
                listArray.add(LanguageHelper.getString(key: "binding_Alipay_account"))
            }
            listArray.add(LanguageHelper.getString(key: "C2C_payment_Bankcard"))
            
            self.selectVw.selectSecondIndex = self.selectSecondIndex
            self.selectVw.selectList = 1
            self.selectVw.dataArray = listArray
        }
        self.selectVw.isHidden = false
    }
}

extension BusinessTransactionVC: PaymentPasswordDelegate{
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
        changeSubmitStyle()
    }
    
    func changeSubmitStyle(){
        if checkInput() {
            determineBtn.backgroundColor = R_UIThemeColor
            determineBtn.isEnabled = true
        }else{
            determineBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCAE9FD)
            determineBtn.isEnabled = false
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
        if indexPath.row == 0 {
            return 80
        }else if indexPath.row == 5 {
           return 180
        }else if indexPath.row == 6 {
            return 184 + 15
        }else{
            return 94
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let marketPrice = self.chooseCoin?.marketPrice == nil ? 0 : (self.chooseCoin?.marketPrice)!
        if indexPath.row != 6 {
            if indexPath.row == 0{
               let cell = tableView.dequeueReusableCell(withIdentifier: businessReleaseMethodCell, for: indexPath) as! BusinessReleaseMethodCell
               cell.selectionStyle = .none
               cell.selectCoinBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
               cell.selectMethodBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
               coinNameTF = cell.cointf
               methodTF = cell.paymentMethodtf
               return cell
            }else{
                if indexPath.row == 5 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: businessPremiumCell, for: indexPath) as! BusinessPremiumCell
                    cell.selectionStyle = .none
                    cell.premiumSliderBlock = { (value:String) in
                        self.transactionsPriceTF.text = Tools.getConversionPrice(amount: value, count: 2)
                        self.marketPriceString = self.transactionsPriceTF.text!
                    }
                    self.percentLab = cell.percentLab
                    cell.setupUI(currencyPrices:marketPrice)
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: businessRelaseCell, for: indexPath) as! BusinessRelaseCell
                    cell.selectionStyle = .none
                    cell.headContentLab.text = headingArray[indexPath.row]
                    cell.textfield.placeholder = headingContentArray[indexPath.row]
                    cell.textfield.textColor = UIColor.R_UIColorFromRGB(color: 0xBDBDBD)
                    cell.textfield.font = UIFont.systemFont(ofSize: 12)
                    cell.textfield.setValue(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), forKeyPath: "_placeholderLabel.textColor")
                    if indexPath.row == 1 {
                        cell.textfield.keyboardType = .decimalPad
                        cell.textfield.delegate = self
                        cell.thinLinesVw.isHidden = false
                        cell.unitLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Num")
                        self.transactionsNumTF = cell.textfield
                    }else if indexPath.row == 2 {
                        cell.textfield.keyboardType = .decimalPad
                        cell.textfield.delegate = self
                        cell.thickLinesVw.isHidden = false
                        cell.unitLab.text = "CNY"
                        self.transactionsPriceTF = cell.textfield
                        self.transactionsPriceTF.text = marketPriceString
                        cell.textfield.textColor = UIColor.R_UIColorFromRGB(color: 0xFF7052)
                    }else if indexPath.row == 3 {
                        cell.textfield.keyboardType = .decimalPad
                        cell.textfield.delegate = self
                        cell.thinLinesVw.isHidden = false
                        cell.unitLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Num")
                        self.transactionsMinTF = cell.textfield
                    }else if indexPath.row == 4 {
                        cell.unitLab.text = "CNY"
                        cell.textfield.isEnabled = false
                        let tradeMinPrice = self.chooseCoin?.tradeMinPrice == nil ? 0 : (self.chooseCoin?.tradeMinPrice)!
                        cell.textfield.text = Tools.setNSDecimalNumber(tradeMinPrice)
                        cell.textfield.textColor = R_UIThemeColor
                    }
                    return cell
                }
            }
        }else{
            remarksCell = tableView.dequeueReusableCell(withIdentifier: homeTransferRemarksCell, for: indexPath) as! HomeTransferRemarksCell
            remarksCell.selectionStyle = .none
            remarksCell.remarkLabel.text = LanguageHelper.getString(key: "C2C_publish_order_Message")
            remarksCell.remarkLabel.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
            remarksCell.remarkLabel.font = UIFont.systemFont(ofSize: 14)
            remarksCell.textView?.placeholderText = LanguageHelper.getString(key: "C2C_Transaction_Remarks")
            remarksCell.textView?.placeholderFont = UIFont.systemFont(ofSize: 12)
            remarksCell.textView?.textColor = UIColor.R_UIColorFromRGB(color: 0xBDBDBD)
            remarksCell.textView?.placeholderTextColor = UIColor.R_UIColorFromRGB(color: 0xBDBDBD)
            self.remarkTV = remarksCell.textView!
            remarksCell.setReleaseMethodLayer()
            remarksCell.footView.isHidden = true
            return remarksCell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        tableView.contentSize = CGSize(width: 0, height: headingArray.count * 94 + 200)
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

extension BusinessTransactionVC:IntegralApplicationStatusDelegate{
    func integralApplicationStatusSelectRow(index: NSInteger, name: String, selectList: NSInteger) {
        if selectList == 0 {
            selectFirstIndex = IndexPath(row: index, section: 0)
            coinNameTF.text = name
            getCoinObject(coinName: name)
            marketPriceString = self.chooseCoin?.marketPrice == nil ? "0" : (self.chooseCoin?.marketPrice?.stringValue)!
            tableView.reloadData()
        }else if selectList == 1 {
            selectSecondIndex = IndexPath(row: index, section: 0)
            self.paymentMethod = name //用于支付方式
            let method = name
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
                alipayStr = (UserDefaults.standard.getUserInfo().apay)!
                if alipayStr == "" {
                    let mineSetAccountVC = MineSetAccountVC()
                    mineSetAccountVC.style = .alipayStyle
                    mineSetAccountVC.type = 0
                    self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                    return
                }
                
            }else if method.contains(LanguageHelper.getString(key: "C2C_payment_WeChat")){
                account = method
                //前往设置微信
                weChatStr = (UserDefaults.standard.getUserInfo().weChat)!
                if weChatStr == "" {
                    let mineSetAccountVC = MineSetAccountVC()
                    mineSetAccountVC.style = .weChatStyle
                    mineSetAccountVC.type = 1
                    self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
                    return
                }
            }
            self.methodTF.text = account
            self.methodType = Tools.getPaymentMethod(method)
        }
        self.changeSubmitStyle()
    }
}

