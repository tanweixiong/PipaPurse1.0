//
//  HomeConversionVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class HomeConversionVC: MainViewController,UITableViewDelegate,UITableViewDataSource,InputPaymentPasswordDelegate {
    fileprivate let homeConversionSubmitCell = "HomeConversionSubmitCell"
    fileprivate let homeConversionListCell = "HomeConversionListCell"
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    lazy var details : HomeConversionListModel = HomeConversionListModel()!
    fileprivate var conversionTextField = UITextField()
    var outCoinNo = String()
    fileprivate let headingArray = [LanguageHelper.getString(key: "homePage_Number_Transactions")]
    fileprivate let textfieldArray = [LanguageHelper.getString(key: "homePage_Enter_Transactions")]
    fileprivate let HomeCointTransView_y:CGFloat =  111
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: LanguageHelper.getString(key: "homePage_conversion"))
        naviBarView.addSubview(self.conversionStatusView)
        self.view.addSubview(tableView)
    }
    
    @objc func submitOnClick(){
         self.setChangeNumber()
    }
    
    //数值
    func setChangeNumber(){
        if Tools.noPaymentPasswordIsSetToExecute() == false{return}
        if checkInput() {
            let language = Tools.getLocalLanguage()
            let outCoinNo = (self.details.coinNo?.stringValue)!
//            let token = UserDefaults.standard.getUserInfo().token
//            let coinNo = Tools.getPTNcoinNo()
            let num = self.conversionTextField.text!
            SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"))
            let parameters = ["language":language,"outCoinNo":outCoinNo,"num":num]
            viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIChangeChangeNum, parameters: parameters, showIndicator: false) {(model:HomeBaseModel) in
                SVProgressHUD.dismiss()
                let dic = model.data as! NSDictionary
                var price = NSNumber()
                var handicapCos = NSNumber()
                if (((dic["ratio"] as AnyObject).isEqual(NSNull.init())) == false && ((dic["changeNum"] as AnyObject).isEqual(NSNull.init())) == false){
                    price = dic.object(forKey: "changeNum") as! NSNumber
                    handicapCos = dic.object(forKey: "ratio") as! NSNumber
                }
                let input = InputPaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
                input?.delegate = self
                //转换数量
                let number = self.conversionTextField.text! + " " + self.details.coinName!
                input?.setNumberOfTransactions(number)
                //转换获得
                let newPrice = "≈" + price.stringValue + " " + Tools.getAppCoinName()
                input?.setPaymentPasswordAlertPrice(newPrice)
                //手续费
                let handicapCostice = "≈" + handicapCos.stringValue + " " + self.details.coinName!
                input?.setPaymentPasswordAlertHandicapCost(handicapCostice)
                input?.setPaymentPasswordAlertPriceTitle(LanguageHelper.getString(key: "homePage_Details_Conversion_Obtained"))
                input?.setPaymentPasswordAlertHandicapCostTitle(LanguageHelper.getString(key: "homePage_Miner_Fee"))
                input?.setNumberOfTransactionsTitle(LanguageHelper.getString(key: "homePage_Number"))
                input?.paymentPasswordAlertVw.forgetPwdBtn.setTitle(LanguageHelper.getString(key: "forget_password") + "?", for: .normal)
                input?.show()
            }
        }
    }
    
    //转换货币
    func setChangeCoin(tradePassword:String){
        let language = Tools.getLocalLanguage()
        let token = UserDefaults.standard.getUserInfo().token
        let outCoinNo = (self.details.coinNo?.stringValue)! //使用币种
        let inCoinNo = Tools.getPTNcoinNo()
        let userId = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let num = self.conversionTextField.text!
        let remark = ""
        let tradePassword = tradePassword.md5() // 支付密码
        let parameters = ["language":language,"token":token,"outCoinNo":outCoinNo,"inCoinNo":inCoinNo,"userId":userId,"remark":remark,"num":num,"tradePassword":tradePassword]
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIChangeChangeCoin, parameters: parameters as Any as? [String : Any], showIndicator: false) {(model:HomeBaseModel) in
            if model.code == 400{
                SVProgressHUD.showInfo(withStatus: model.message)
                return
            }
            if model.code == Tools.noPaymentPasswordSetCode(){
                let setPwdVC = ModifyTradePwdViewController()
                setPwdVC.type = ModifyPwdType.tradepwd
                setPwdVC.isNeedNavi = false
                self.navigationController?.pushViewController(setPwdVC, animated: true)
                return
            }
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "homePage_Details_Conversion_Finish"))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                let responseData = Mapper<HomeConversionDetialsModel>().map(JSONObject: model.data)
                let homeTransferFinishVC = HomeTransferFinishVC()
                homeTransferFinishVC.style = .conversionStyle
                homeTransferFinishVC.conversionDetials = responseData
                homeTransferFinishVC.price = (responseData?.pnt?.stringValue)!
                self.navigationController?.pushViewController(homeTransferFinishVC, animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
            })
        }
    }
    
    func checkInput()->Bool{
        if self.conversionTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_Enter_Conversion_Prompt"))
            return false
        }
        return true
    }
    
    func inputPaymentPassword(_ pwd: String!) -> String! {
        self.setChangeCoin(tradePassword:pwd)
        return pwd
    }
    
    func inputPaymentPasswordChangeForgetPassword() {
        let forgetvc = ModifyTradePwdViewController()
        forgetvc.type = ModifyPwdType.tradepwd
        forgetvc.status = .modify
        forgetvc.isNeedNavi = false
        self.navigationController?.pushViewController(forgetvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 1 {
            return 70
        }else{
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        view.backgroundColor = R_UISectionLineColor
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeConversionListCell, for: indexPath) as! HomeConversionListCell
            cell.selectionStyle = .none
            cell.headingLabel.text = headingArray[indexPath.row]
            let coinName = details.coinName == nil ? "" : details.coinName
            cell.headingContentLabel.text = coinName
            cell.textfidld.placeholder = textfieldArray[indexPath.row]
            cell.textfidld.keyboardType = .decimalPad
            cell.textfidld.delegate = self
            if indexPath.row == 0 {
                self.conversionTextField = cell.textfidld
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: homeConversionSubmitCell, for: indexPath) as! HomeConversionSubmitCell
            cell.selectionStyle = .none
            cell.submitBtn.addTarget(self, action: #selector(submitOnClick), for: .touchUpInside)
            cell.submitBtn.setTitle(LanguageHelper.getString(key: "homePage_Finish_Confirm_Conversion"), for: .normal)
            return cell
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeConversionSubmitCell", bundle: nil),forCellReuseIdentifier: self.homeConversionSubmitCell)
        tableView.register(UINib(nibName: "HomeConversionListCell", bundle: nil),forCellReuseIdentifier: self.homeConversionListCell)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.separatorColor = R_UISectionLineColor
        return tableView
    }()

    lazy var conversionStatusView: HomeConversionStatusView = {
        let view = Bundle.main.loadNibNamed("HomeConversionStatusView", owner: nil, options: nil)?.last as! HomeConversionStatusView
        view.frame = CGRect(x: 0, y: Int(MainViewControllerUX.naviHeight_y) , width: Int(SCREEN_WIDTH), height: 75)
  
        let url = details.coinImg == nil ? "" :  details.coinImg
        view.iconImageView.sd_setImage(
            with:NSURL(string: url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        
        let name = details.coinName == nil ? "" : details.coinName
        view.coinNameLabel.text = name
        
        let coinPrice = details.coinPrice == nil ? "0" : (details.coinPrice?.stringValue)!
        let coinPriceBySys = details.coinPriceBySys == nil ? "0" : Tools.getWalletAmount(amount: (details.coinPriceBySys?.stringValue)!)
        
        view.USDPriceLabel.text = coinPriceBySys
        view.CNYPriceLabel.text = Tools.getWalletAmount(amount: (details.coinPrice?.stringValue)!)
        
        if Tools.getIsChinese() {
            view.rankLabel1.text = "CNY"
            view.rankLabel2.text = "USD"
        }else{
            view.rankLabel1.text = "USD"
            view.rankLabel2.text = "CNY"
        }
        return view
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.closeKeyboard()
    }
}

extension MainViewController:UITextFieldDelegate{
    //限制输入4位小数
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return OCTools.existenceDecimal(textField.text, range: range, replacementString: string)
    }
    
}
