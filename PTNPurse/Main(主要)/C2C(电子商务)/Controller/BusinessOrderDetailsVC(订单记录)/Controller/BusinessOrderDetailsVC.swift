//
//  BusinessOrderDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum BusinessOrderDetailsStatus{
    case dvertisementStyle
    case historyStyle
}
class BusinessOrderDetailsVC: MainViewController {
    fileprivate var headingArray = [
        LanguageHelper.getString(key: "C2C_transaction_finish_Avatar")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_OrderNum")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Type")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Amount")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Quantity")
        
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Payment")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Buy")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Sell")
        
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Miner")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Fees")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Time")
        ,LanguageHelper.getString(key: "C2C_transaction_finish_Remark")]
    fileprivate lazy var viewModel : BusinessOrderDetailsVM = BusinessOrderDetailsVM()
    fileprivate lazy var baseViewModel: BaseViewModel =  BaseViewModel()
    fileprivate var listCell = BusinessOrderDetailsLiCell()
    fileprivate var tradePassword = String()
    fileprivate var headingContentArray = NSArray()
    fileprivate let businessOrderDetailsAVCell = "BusinessOrderDetailsAVCell"
    fileprivate let businessOrderDetailsLiCell = "BusinessOrderDetailsLiCell"
    fileprivate var avatarStr = String()
    fileprivate var nameStr = String()
    fileprivate var statusStr = String()
    fileprivate var isRemindSeller = false
    fileprivate var remindSellerIndex = NSInteger()
    fileprivate var indexRow = NSInteger()
    fileprivate var phoneNum = String()
    var businessaDvertisementModel = BusinessaDvertisementModel()
    var historyModel = BusinessBuyHistoryModel()
    var style = BusinessOrderDetailsStatus.dvertisementStyle
    var businessaStyle = BusinessaDvertisementStyle.processingStyle
    var orderNo = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: bagroundVw.frame.size.height))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessOrderDetailsAVCell", bundle: nil),forCellReuseIdentifier: self.businessOrderDetailsAVCell)
        tableView.register(UINib(nibName: "BusinessOrderDetailsLiCell", bundle: nil),forCellReuseIdentifier: self.businessOrderDetailsLiCell)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    lazy var bagroundVw: UIView = {
        let statusHeight = self.businessaStyle == .processingStyle ? 74 : 0
        let height = (headingArray.count - 1) * 44 + 60 + statusHeight
        let view = UIView.init(frame: CGRect(x: 15, y:  21, width: SCREEN_WIDTH - 30, height: CGFloat(height)))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 250, alpha: 1)
        return view
    }()
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight)
        scrollView.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        return scrollView
    }()
}

extension BusinessOrderDetailsVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "C2C_mine_My_advertisement"))
        scrollView.addSubview(bagroundVw)
        Tools.setViewShadow(bagroundVw)
        bagroundVw.addSubview(tableView)
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 0, height: bagroundVw.frame.maxY + 20)
    }
    
    func getData(){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let id = self.orderNo
        let parameters = ["token":token,"id":id]
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetDealDetailById, parameters: parameters, showIndicator: false) {
            self.setTableViewHeight()
            let model = self.viewModel.model
            self.businessaStyle = model.state == 1 ? .finishStyle : .processingStyle
            self.nameStr = model.username!
            self.avatarStr = model.photo!
            self.statusStr = Tools.getBusinessaTransactionStyle(Style: (model.state!.stringValue))
            let orderNo = model.orderNo!
            let dealType = model.dealType == 0 ? LanguageHelper.getString(key: "C2C_mine_My_advertisement_Buy") : LanguageHelper.getString(key: "C2C_mine_My_advertisement_Sell")
            let dealPrice = Tools.getConversionPrice(amount: (model.dealPrice?.stringValue)!, count: 2) + " CNY"
            let dealNum = Tools.setNSDecimalNumber(model.dealNum!)
            let minerFee = (model.minerFee?.stringValue)!
            let poundageCore = model.poundageCore == nil ? "" : (model.poundageCore)!
            let poundage = (model.poundage?.stringValue)! + poundageCore
            let data = (model.date)!
            let remark = model.remark!
            let receivablesType = Tools.getPaymentDetailsMethod((model.receivablesType?.stringValue)!)
            let buyAccount = "\(model.buyAccount!)" // 买方账号
            let sellAccount = "\(model.sellAccount!)" // 卖方账号
            self.headingContentArray = [
                ""
                ,orderNo
                ,dealType
                ,dealPrice
                ,dealNum
                ,receivablesType
                ,buyAccount
                ,sellAccount
                ,minerFee
                ,poundage
                ,data
                ,remark]
            self.tableView.reloadData()
        }
    }
    
    //状态实现
    @objc func setStatusOnClick(_ sender:UIButton){
        if Tools.noPaymentPasswordIsSetToExecute() == false{return}
        //状态，0：匹配中，1：已完成，2：撤销，3：等待买方付款，4：等待卖方确认，5：未付款回滚订单，6：纠纷强制打款，7：纠纷强制回滚
        self.indexRow = sender.tag
        let model = viewModel.model
        //提醒卖家付款
        if (isRemindSeller == true && self.remindSellerIndex == self.indexRow) || (model.dealType == 0 && model.state == 4) {
            self.remindSms(orderNo: model.orderNo!)
            //其他类型操作
        }else{
            let model = viewModel.model
            //提醒付款
            if model.state == 4 && model.dealType == 0 {
                self.remindSms(orderNo: model.orderNo!)
                return
            }
            let input = PaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT),isNormal:true)
            input?.delegate = self
            input?.show()
        }
    }
    
    //提醒买,卖人双方已付款
    func remindSms(orderNo:String){
        let token = UserDefaults.standard.getUserInfo().token
        let orderNo = orderNo
        let language = Tools.getLocalLanguage()
        let parameters = ["token":token,"orderNo":orderNo,"language":language]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIRemindSms, parameters: parameters as Any as? [String : Any], showIndicator: false) { (json) in
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Remind_success"))
        }
    }
    
    //买方确认付款
    func setBuyConfirmPay(orderNo:String,index:NSInteger){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let orderNo = orderNo
        let tradePasswordMD5 = self.tradePassword.md5()
        let language = Tools.getLocalLanguage()
        let parameters = ["token":token,"orderNo":orderNo,"tradePassword":tradePasswordMD5,"language":language]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIConfirmPay, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
            if model.code == Tools.noPaymentPasswordSetCode(){
                let setPwdVC = ModifyTradePwdViewController()
                setPwdVC.type = ModifyPwdType.tradepwd
                setPwdVC.isNeedNavi = false
                self.navigationController?.pushViewController(setPwdVC, animated: true)
                return
            }
            self.listCell.remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Remind_sell"), for: .normal)
            self.isRemindSeller = true
            self.remindSellerIndex = index
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Confirm_payment_successful"))
            self.addNotification()
            self.getData()
        }
    }
    
    //卖方确认付款
    func setSellConfirmPay(orderNo:String,index:NSInteger){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let orderNo = orderNo
        let tradePasswordMD5 = self.tradePassword.md5()
        let language = Tools.getLocalLanguage()
        let parameters = ["token":token,"orderNo":orderNo,"tradePassword":tradePasswordMD5,"language":language]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIConfirmReceive, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
            if model.code == Tools.noPaymentPasswordSetCode(){
                let setPwdVC = ModifyTradePwdViewController()
                setPwdVC.type = ModifyPwdType.tradepwd
                setPwdVC.isNeedNavi = false
                self.navigationController?.pushViewController(setPwdVC, animated: true)
                return
            }
            self.listCell.remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Completed"), for: .normal)
            self.listCell.remindBtn.isEnabled = false
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Confirm_payments_successful"))
            self.addNotification()
            self.getData()
        }
    }
    
    //发起纠纷
    @objc func initiateDisputeOnClick(_ sender:UIButton){
        let orderNo = viewModel.model.orderNo!
        let businessSubmissionVC = BusinessSubmissionVC()
        businessSubmissionVC.orderNo = orderNo
        self.navigationController?.pushViewController(businessSubmissionVC, animated: true)
    }
    
    //取消订单
    @objc func cancelDealDetail(_ sender:UIButton){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let orderNo = viewModel.model.orderNo!
        let language = Tools.getLocalLanguage()
        let userNo = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let parameters = ["token":token,"orderNo":orderNo,"language":language,"userNo":userNo]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPICancelDealDetail, parameters: parameters, showIndicator: false) { (json) in
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Cancel_order_successfully"))
            self.addNotification()
            self.getData()
        }
    }
    
    //联系对方
    @objc func contactOnClick(_ sender:UIButton){
        let model = self.viewModel.model
        self.phoneNum = model.username == nil ? "" : (model.username!)
        let optionMenu = UIAlertController(title: nil, message: LanguageHelper.getString(key: "C2C_mine_My_advertisement_Contact"), preferredStyle: .actionSheet)
        let phoneAction = UIAlertAction(title: phoneNum, style: .default, handler:{ (alert: UIAlertAction!) -> Void in
            let callWebView = UIWebView()
            callWebView.loadRequest(URLRequest(url:URL(string: "tel:\(self.phoneNum)")!))
            self.view.addSubview(callWebView)
        })
        let cancelAction = UIAlertAction(title: LanguageHelper.getString(key: "cancel"), style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(phoneAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func setTableViewHeight(){
        let statusHeight = self.businessaStyle == .processingStyle ? 74 : 0
        let height = (headingArray.count - 1) * 44 + 60 + statusHeight
        self.bagroundVw.height = CGFloat(height)
        self.tableView.height = CGFloat(height)
    }
    
    //发送通知
    func addNotification(){
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationC2COrderReload), object: nil)
    }
    
    func changePaymentMethod(paymentMethod:String){
        let dataArray = NSMutableArray()
        dataArray.addObjects(from: self.headingArray)
        dataArray.replaceObject(at: 8, with: paymentMethod)
        self.headingArray = dataArray as! [String]
    }
}

extension BusinessOrderDetailsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businessaStyle == .processingStyle ? headingContentArray.count + 1 : headingContentArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }else {
            if self.businessaStyle == .processingStyle && indexPath.row == headingContentArray.count {
                return 74
            }
            return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: businessOrderDetailsAVCell, for: indexPath) as! BusinessOrderDetailsAVCell
            cell.selectionStyle = .none
            cell.avatarImageView.sd_setImage(with: NSURL(string: self.avatarStr)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            cell.nameLab.text = nameStr
            cell.statusLab.text = statusStr
            return cell
        }else{
            listCell = tableView.dequeueReusableCell(withIdentifier: businessOrderDetailsLiCell, for: indexPath) as! BusinessOrderDetailsLiCell
            listCell.selectionStyle = .none
            listCell.businessaStyle = self.businessaStyle
            if self.businessaStyle == .processingStyle && indexPath.row == headingContentArray.count {
                listCell.setIncreaseState(model: self.viewModel.model)
                listCell.contactBtn.addTarget(self, action: #selector(contactOnClick(_:)), for: .touchUpInside)
                listCell.cancelOrderBtn.addTarget(self, action: #selector(cancelDealDetail(_:)), for: .touchUpInside)
                listCell.remindBtn.addTarget(self, action: #selector(setStatusOnClick(_:)), for: .touchUpInside)
                listCell.initiateDisputeBtn.addTarget(self, action: #selector(initiateDisputeOnClick(_:)), for: .touchUpInside)
            }else{
                if headingContentArray.count != 0 {
                    listCell.headingLab.text = headingArray[indexPath.row] + "："
                    listCell.headingContentLab.text = headingContentArray[indexPath.row] as? String
                }
            }
            return listCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension BusinessOrderDetailsVC: PaymentPasswordDelegate{
    func inputPaymentPassword(_ pwd: String!) -> String! {
        self.tradePassword = pwd
        let model =  viewModel.model
        //0为购买 1为出售
        if model.dealType == 0 {
            self.setBuyConfirmPay(orderNo:  model.orderNo!, index: self.indexRow)
        } else if model.dealType == 1 {
            self.setSellConfirmPay(orderNo: model.orderNo!, index: self.indexRow)
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

