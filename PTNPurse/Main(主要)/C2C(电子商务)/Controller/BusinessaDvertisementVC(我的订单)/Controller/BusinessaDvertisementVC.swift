//
//  BusinessaDvertisementVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum BusinessaDvertisementStyle {
    case processingStyle
    case finishStyle
}
class BusinessaDvertisementVC: MainViewController {
    fileprivate let naviTitle = LanguageHelper.getString(key: "Mine_Mining_Advertising_Records") + "-"
    fileprivate let baseViewModel : BaseViewModel = BaseViewModel()
    fileprivate var indexRow = NSInteger()
    fileprivate var isRemindSeller = false
    fileprivate var remindSellerIndex = NSInteger()
    fileprivate var tradePassword = String()
    fileprivate lazy var viewModel : BusinessaDvertisementVM = BusinessaDvertisementVM()
    fileprivate lazy var businessViewModel : BusinessVM = BusinessVM()
    fileprivate var coinNum = Tools.getBtcCoinNum()
    fileprivate var style = BusinessTransactionStyle.buyStyle
    
    fileprivate let coinArray = NSMutableArray()
    fileprivate var phoneNum = String()
    fileprivate let businessaDvertisementCell = "BusinessaDvertisementCell"
    fileprivate let businessOrderFinishCell = "BusinessOrderFinishCell"
    fileprivate let finishPageSize = 0
    fileprivate let processingPageSize = 0
    fileprivate let lineSize = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCoin()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: R_NotificationC2COrderReload), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var businessView: BusinessView = {
        let view = Bundle.main.loadNibNamed("BusinessView", owner: nil, options: nil)?.last as! BusinessView
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight , width: SCREEN_WIDTH, height: 45)
        view.buyBtn.backgroundColor = R_UIThemeSkyBlueColor
        view.buyBtn.setTitle(LanguageHelper.getString(key: "Mine_Mining_Purchase_Order"), for: .normal)
        view.buyBtn.addTarget(self, action: #selector(processingAndFinish(_:)), for: .touchUpInside)
        view.buyBtn.setTitleColor(R_ZYSelectNormalColor, for: .normal)
        view.buyBtn.setTitleColor(UIColor.white, for: .selected)
        view.buyBtn.isSelected = true
        
        view.sellBtn.setTitle(LanguageHelper.getString(key: "Mine_Mining_Sell_Order"), for: .normal)
        view.sellBtn.addTarget(self, action: #selector(processingAndFinish(_:)), for: .touchUpInside)
        view.sellBtn.setTitleColor(R_ZYSelectNormalColor, for: .normal)
        view.sellBtn.setTitleColor(UIColor.white, for: .selected)
        return view
    }()
    
    lazy var selectVw: IntegralApplicationStatusVw = {
        let view = Bundle.main.loadNibNamed("IntegralApplicationStatusVw", owner: nil, options: nil)?.last as! IntegralApplicationStatusVw
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height:SCREEN_HEIGHT)
        view.delegare = self
        view.isHidden = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: businessView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - businessView.frame.maxY))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessaDvertisementCell", bundle: nil),forCellReuseIdentifier: self.businessaDvertisementCell)
        tableView.register(UINib(nibName: "BusinessOrderFinishCell", bundle: nil),forCellReuseIdentifier: self.businessOrderFinishCell)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.viewModel.processingModel.removeAll()
            self.viewModel.finishModel.removeAll()
            self.getData()
        })        
        return tableView
    }()
    
    lazy var chooseVw: MineChooseBtn = {
        let view = MineChooseBtn.createView()
        view.frame = CGRect(x: SCREEN_WIDTH/2 - 145/2, y: 32, width: 145 , height: 22)
        view.chooseBtn.tag = 4
        view.chooseBtn.addTarget(self, action: #selector(distributeOnClick(_:)), for: .touchUpInside)
        view.titleLab.text = naviTitle
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationC2COrderReload), object: nil)
    }
}

extension BusinessaDvertisementVC {
    func setupUI(){
        setNormalNaviBar(title: "")
        view.addSubview(businessView)
        view.addSubview(tableView)
        view.addSubview(chooseVw)
        UIApplication.shared.keyWindow?.addSubview(selectVw)
    }
    
    @objc func contactOnClick(_ sender:UIButton){
        let model = self.getModel(index: sender.tag)
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
    
    @objc func getData(){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let coinNo = coinNum
        let entrustType = style == .buyStyle ? "0" : "1" //状态：0购买，1：出售
        let lineSize = "\(self.lineSize)"
        let parameters = ["token":token,"coinNo":coinNo,"entrustType":entrustType,"entrustState":"2","pageSize":"0","lineSize":lineSize]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetDealDetailByUserNo, parameters: parameters, style:self.style, showIndicator: false) {
            self.tableView.reloadData()
        }
        self.tableView.mj_header.endRefreshing()
    }
    
    //状态实现
    @objc func setStatusOnClick(_ sender:UIButton){
        if Tools.noPaymentPasswordIsSetToExecute() == false{return}
        //状态，0：匹配中，1：已完成，2：撤销，3：等待买方付款，4：等待卖方确认，5：未付款回滚订单，6：纠纷强制打款，7：纠纷强制回滚
        self.indexRow = sender.tag
        let model = getModel(index: self.indexRow)
        //提醒卖家付款
        if (isRemindSeller == true && self.remindSellerIndex == self.indexRow) || (model.dealType == 0 && model.state == 4) {
            self.remindSms(orderNo: model.orderNo!)
        //其他类型操作
        }else{
            //提醒付款
            if model.state == 4 && model.dealType == 0 {
                self.remindSms(orderNo: model.orderNo!)
               return
            }
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
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIConfirmPay, parameters: parameters, showIndicator: false) {(model:HomeBaseModel) in
             if model.code == Tools.noPaymentPasswordSetCode(){
                let setPwdVC = ModifyTradePwdViewController()
                setPwdVC.type = ModifyPwdType.tradepwd
                setPwdVC.isNeedNavi = false
                self.navigationController?.pushViewController(setPwdVC, animated: true)
                return
            }
            let cell = self.tableView.cellForRow(at:IndexPath.init(row: index, section: 0)) as! BusinessaDvertisementCell
            cell.remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Remind_sell"), for: .normal)
            self.isRemindSeller = true
            self.remindSellerIndex = index
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Confirm_payment_successful"))
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
            let cell = self.tableView.cellForRow(at:IndexPath.init(row: index, section: 0)) as! BusinessaDvertisementCell
            cell.remindBtn.setTitle(LanguageHelper.getString(key: "C2C_transaction_Completed"), for: .normal)
            cell.remindBtn.isEnabled = false
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Confirm_payments_successful"))
            self.getData()
        }
    }
    
    //取消订单
    @objc func cancelDealDetail(_ sender:UIButton){
        let model = viewModel.processingModel[sender.tag]
        let token = (UserDefaults.standard.getUserInfo().token)!
        let orderNo = model.orderNo!
        let userType = (model.dealType?.stringValue)!
        let language = Tools.getLocalLanguage()
        let userNo = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let parameters = ["token":token,"orderNo":orderNo,"userType":userType,"language":language,"userNo":userNo]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPICancelDealDetail, parameters: parameters, showIndicator: false) { (json) in
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_transaction_Cancel_order_successfully"))
            self.viewModel.processingModel.remove(at: sender.tag)
            self.tableView.reloadData()
        }
    }
    
    //发起纠纷
    @objc func initiateDisputeOnClick(_ sender:UIButton){
        let mode = viewModel.processingModel[sender.tag]
        let businessSubmissionVC = BusinessSubmissionVC()
        businessSubmissionVC.orderNo = mode.orderNo!
        self.navigationController?.pushViewController(businessSubmissionVC, animated: true)
    }
    
    //获取币种
    func getCoin(){
        let parameters = ["state":"1","type":"3"]
        businessViewModel.loadCoinSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetCoin, parameters: parameters, showIndicator: false) {
            for item in 0...self.businessViewModel.coinModel.count {
                if item != self.businessViewModel.coinModel.count {
                    let model = self.businessViewModel.coinModel[item]
                    self.coinArray.add(model.coinName!)
                }
            }
            if self.coinArray.count != 0 {
                //设置标题栏
                let model = self.businessViewModel.coinModel.first
                self.chooseVw.titleLab.text = self.naviTitle + (model?.coinName!)!
                self.coinNum = (model?.id?.stringValue)!
                //弹出框
                self.selectVw.selectList = 0
                self.selectVw.selectFirstIndex = IndexPath(row: 0, section: 0)
                self.selectVw.dataArray = self.coinArray
            }
            self.getData()
        }}
    
    @objc func processingAndFinish(_ sender:UIButton){
        //进行中
        if sender == businessView.buyBtn  {
            style = .buyStyle
            businessView.sellBtn.isSelected = false
            businessView.sellBtn.backgroundColor = UIColor.white
            businessView.buyBtn.isSelected = true
            businessView.buyBtn.backgroundColor = R_UIThemeSkyBlueColor
            
        //已完成
        }else if sender == businessView.sellBtn {
            style = .sellStyle
            businessView.sellBtn.isSelected = true
            businessView.sellBtn.backgroundColor = R_UIThemeSkyBlueColor
            businessView.buyBtn.isSelected = false
            businessView.buyBtn.backgroundColor = UIColor.white
        }
        self.getData()
    }
    
    @objc func distributeOnClick(_ sender:UIButton){
        if sender.tag == 4 {
            if self.coinArray.count == 0 {
                self.getCoin()
            }else{
                self.selectVw.isHidden = false
            }
        }
    }
    
    func cleanData(){
        self.viewModel.finishModel.removeAll()
        self.viewModel.processingModel.removeAll()
    }
    
    func getModel(index:NSInteger)->BusinessaDvertisementModel{
        var model = BusinessaDvertisementModel()
        if style == .buyStyle {
            model = viewModel.processingModel[index]
        }else if style == .sellStyle{
            model = viewModel.finishModel[index]
        }
        return model!
    }
}

extension BusinessaDvertisementVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if style == .buyStyle {
            return viewModel.processingModel.count
        }
        return viewModel.finishModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 308
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessaDvertisementCell, for: indexPath) as! BusinessaDvertisementCell
        if viewModel.processingModel.count != 0 || viewModel.finishModel.count != 0 {
            cell.model = style == .buyStyle ? viewModel.processingModel[indexPath.row] : viewModel.finishModel[indexPath.row]
        }
        cell.selectionStyle = .none
        cell.contactBtn.tag = indexPath.row
        cell.contactBtn.addTarget(self, action: #selector(contactOnClick(_:)), for: .touchUpInside)
        cell.cancelOrderBtn.tag = indexPath.row
        cell.cancelOrderBtn.addTarget(self, action: #selector(cancelDealDetail(_:)), for: .touchUpInside)
        cell.remindBtn.tag = indexPath.row
        cell.remindBtn.addTarget(self, action: #selector(setStatusOnClick(_:)), for: .touchUpInside)
        cell.initiateDisputeBtn.tag = indexPath.row
        cell.initiateDisputeBtn.addTarget(self, action: #selector(initiateDisputeOnClick(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = getModel(index: indexPath.row)
        let businessOrderDetailsVC = BusinessOrderDetailsVC()
        businessOrderDetailsVC.orderNo = (model.id!.stringValue)
        businessOrderDetailsVC.businessaStyle = .processingStyle
        self.navigationController?.pushViewController(businessOrderDetailsVC, animated: true)
    }
}

extension BusinessaDvertisementVC: InputPaymentPasswordDelegate{
    func inputPaymentPassword(_ pwd: String!) -> String! {
        self.tradePassword = pwd
        let model = getModel(index: self.indexRow)
        //0为购买 1为出售
        if model.dealType == 0 {
            setBuyConfirmPay(orderNo:  model.orderNo!, index: self.indexRow)
        } else if model.dealType == 1 {
            setSellConfirmPay(orderNo: model.orderNo!, index: self.indexRow)
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

extension BusinessaDvertisementVC :IntegralApplicationStatusDelegate {
    func integralApplicationStatusSelectRow(index: NSInteger, name: String, selectList: NSInteger) {
        let model = businessViewModel.coinModel[index]
        chooseVw.titleLab.text = naviTitle + model.coinName!
        coinNum = (model.id?.stringValue)!
        getData()
    }
}



