//
//  HomeTransferVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper
import AVFoundation
import YYText

class HomeTransferVC: MainViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,InputPaymentPasswordDelegate,LBXScanViewControllerDelegate {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    fileprivate lazy var coinDetailsVM : HomeListDetsilsVM = HomeListDetsilsVM()
    var details =  HomeWalletsModel()!
    var address = String()
    var coinNum = String()
    fileprivate var collectTextField = UITextField()
    fileprivate var collectNumTextField = UITextField()
    fileprivate var sliderValueLab = UILabel()
    fileprivate var yytextfield = YYTextView()
    fileprivate var collectAddress = ""
    fileprivate var slider = UISlider()
    fileprivate let homeTransferCell = "HomeTransferCell"
    fileprivate let homeTransferRemarkCell = "HomeTransferRemarkCell"
    fileprivate let HomeCointTransViewHeight = 50
    fileprivate let HomeCointTransView_y =  111
    fileprivate var walletAddress = String()
    fileprivate var pubKeyTextField = UITextField()
    fileprivate var isPTNCoin = false
    fileprivate var headingArray = [
        [LanguageHelper.getString(key: "homePage_Wallet_Address")
        ,LanguageHelper.getString(key: "homePage_Receivables_Address")
        ,LanguageHelper.getString(key: "homePage_Transfer_Public_Key")
        ,LanguageHelper.getString(key: "homePage_Number")
        ,LanguageHelper.getString(key: "homePage_Miner_Fee")]
        ,[LanguageHelper.getString(key: "homePage_Remark_Information")]]
    fileprivate var headingContentArray = [
        [LanguageHelper.getString(key: "homePage_Transfer_Key")
        ,LanguageHelper.getString(key: "homePage_Transfer_Scan_Address")
        ,LanguageHelper.getString(key: "homePage_Transfer_Enter_Public_Key")
        ,LanguageHelper.getString(key: "homePage_Transfer_textField_Number")
        ,LanguageHelper.getString(key: "homePage_Miner_Fee")]
        ,[LanguageHelper.getString(key: "homePage_Transfer_Scan_Address")]]
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNeedPubKey()
        let coinName = self.details.coinName == nil ? Tools.getAppCoinName() : self.details.coinName!
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: coinName + " " + LanguageHelper.getString(key: "homePage_transfer"))
        naviBarView.addSubview(self.cointTransView)
        self.view.addSubview(tableView)
        self.getCoinData()
        self.getMaxFeeData()
        NotificationCenter.default.addObserver(self, selector: #selector(getCoinData), name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
    }
    
    @objc func getCoinData(){
        let type = details.type == nil ? Tools.getPTNcoinNo() : (details.type?.stringValue)!
        let language = Tools.getLocalLanguage()
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["type":type,"language":language,"token":token!]
        coinDetailsVM.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetCoinDetail, parameters: parameters, showIndicator: false) {
            self.cointTransView.coinNumberLabel.text = self.coinDetailsVM.model.userWallet?.balance == nil ? "--" : Tools.getWalletAmount(amount: (self.coinDetailsVM.model.userWallet?.balance?.stringValue)!)
            let method = "¥"
            let price = self.coinDetailsVM.model.Money == nil ? "0" : Tools.getWalletAmount(amount: (self.coinDetailsVM.model.Money?.stringValue)!)
            self.cointTransView.priceLabel.text = "≈" + method + price
            if type == Tools.getPTNcoinNo() {
                self.walletAddress = UserDefaults.standard.getUserInfo().ptnaddress!
            }else{
                self.walletAddress = self.coinDetailsVM.model.userWallet?.address == nil ? "" : (self.coinDetailsVM.model.userWallet?.address)!
            }
            self.tableView.reloadData()
        }
    }
    
    func getMaxFeeData(){
        let coinNo = details.type == nil ? Tools.getPTNcoinNo() : (details.type?.stringValue)!
        let parameters = ["coinNo":coinNo]
        coinDetailsVM.loadCoinNumberSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetCoinByNo, parameters: parameters, showIndicator: false) {
            self.tableView.reloadData()
        }
    }
    
    func isNeedPubKey(){
        if details.type != nil {
            //PTN需要公钥 其他不需要公钥匙
            if Tools.getPTNcoinNo() != (details.type?.stringValue)!  {
                let firstHeading = headingArray.first!
                let firstHeadingArray = NSMutableArray()
                firstHeadingArray.addObjects(from: firstHeading)
                firstHeadingArray.removeObject(at: 2)
                headingArray = [firstHeadingArray as! Array<String>,headingArray.last!]
                let firstContent = headingContentArray.first!
                let firstContentArray = NSMutableArray()
                firstContentArray.addObjects(from: firstContent)
                firstContentArray.removeObject(at: 2)
                headingContentArray = [firstContentArray as! Array<String>,headingContentArray.last!]
                isPTNCoin = false
            }
            
            if Tools.getPTNcoinNo() == (details.type?.stringValue)!{
                isPTNCoin = true
            }
        }
    }
    
    func transferOnClick(){
        if Tools.noPaymentPasswordIsSetToExecute() == false{return}
        if checkEnter(){
            let input = InputPaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            input?.delegate = self
            input?.setPaymentPasswordAlertPriceTitle(LanguageHelper.getString(key: "homePage_Number"))
            input?.setPaymentPasswordAlertPrice(collectNumTextField.text!)
            input?.setPaymentPasswordAlertHandicapCostTitle(LanguageHelper.getString(key: "homePage_Miner_Fee"))
            input?.setPaymentPasswordAlertHandicapCost(String(format: "%.2f", slider.value))
            input?.paymentPasswordAlertVw.titleLabel.text = LanguageHelper.getString(key: "homePage_Prompt_Enter_PayPassword")
            input?.paymentPasswordAlertVw.forgetPwdBtn.setTitle(LanguageHelper.getString(key: "forget_password") + "?", for: .normal)
            input?.show()
        }
    }
    
    func inputPaymentPassword(_ pwd: String!) -> String! {
        if coinNum == "" {
            SVProgressHUD.showInfo(withStatus: "空的币种")
            return pwd
        }
        let token = UserDefaults.standard.getUserInfo().token
        let coinNo = coinNum
        let outAddress = self.walletAddress
        let inAddress = collectTextField.text!
        let type = "0"
        let tradeNum = collectNumTextField.text!
        let dealPwdMD5 = pwd.md5()
        let remark = self.yytextfield.text!
        let pubKey = self.pubKeyTextField.text!
        let fee = sliderValueLab.text!

        var parameters = NSDictionary()
        if isPTNCoin {
            parameters = ["token":token!
                ,"coinNo":coinNo
                ,"fee":fee
                ,"outAddress":outAddress
                ,"inAddress":inAddress
                ,"type":type
                ,"tradeNum":tradeNum
                ,"dealPwd":dealPwdMD5
                ,"remark":remark
                ,"pubKey":pubKey
            ]
        }else{
            parameters = ["token":token!
                ,"coinNo":coinNo
                ,"fee":fee
                ,"outAddress":outAddress
                ,"inAddress":inAddress
                ,"type":type
                ,"tradeNum":tradeNum
                ,"dealPwd":dealPwdMD5
                ,"remark":remark
            ]
        }
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIAddTradeInfo, language: false, parameters: parameters as? [String : Any], showIndicator: false, success: { (json) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                let responseData = Mapper<HomeTransferFinishModel>().map(JSONObject: json)
                if responseData?.code == 200 {
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "homePage_Details_Transfer_Finish"))
                    let homeTransferFinishVC = HomeTransferFinishVC()
                    homeTransferFinishVC.style = .transferStyle
                    homeTransferFinishVC.transactionId = (responseData?.data?.stringValue)!
                    homeTransferFinishVC.price = self.collectNumTextField.text!
                    homeTransferFinishVC.coinName = self.details.coinName!
                    homeTransferFinishVC.fee = fee
                    self.navigationController?.pushViewController(homeTransferFinishVC, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
                }else if responseData?.code == Tools.noPaymentPasswordSetCode(){
                    let setPwdVC = ModifyTradePwdViewController()
                    setPwdVC.type = ModifyPwdType.tradepwd
                    setPwdVC.isNeedNavi = false
                    self.navigationController?.pushViewController(setPwdVC, animated: true)
                }else{
                    SVProgressHUD.showInfo(withStatus: responseData?.message)
                }
            })
        }) { (error) in
        }
        return pwd
    }
    
    @objc func scanCodeOnClick(){
        if cameraPermissions() {
            let vc = LBXScanViewController();
            vc.title = LanguageHelper.getString(key: "homePage_Scan")
            vc.scanStyle = vc.setCustomLBScan()
            vc.scanResultDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            SVProgressHUD.showInfo(withStatus:LanguageHelper.getString(key: "homePage_Prompt_Scan_Open_Permissions"))
        }
    }
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        let resultStr = scanResult.strScanned!
        if resultStr.contains(R_Theme_QRCode)  {
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "homePage_Prompt_Scan_Finish"))
            let ptnStr = R_Theme_QRCode + ":"
            let str = resultStr.replacingOccurrences(of: ptnStr, with: "")
            let dict = Tools.getDictionaryFromJSONString(jsonString: str)
            collectAddress = dict.object(forKey: "address") as! String
            //获取收款地址
            collectTextField.text! = collectAddress
            if (((dict["message"] as AnyObject).isEqual(NSNull.init())) == false){
                yytextfield.text = dict.object(forKey: "message") as! String
            }
        }else{
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_Prompt_Scan_Error"))
        }
    }
    
    func checkEnter()->Bool{
        if collectTextField.text! == "" {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_Prompt_Scan_Address"))
            return false
        }
        
        if collectNumTextField.text! == "" {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "homePage_Prompt_Scan_Enter_Number"))
            return false
        }
        return true
    }
    
    func inputPaymentPasswordChangeForgetPassword() {
        let forgetvc = ModifyTradePwdViewController()
        forgetvc.type = ModifyPwdType.tradepwd
        forgetvc.status = .modify
        forgetvc.isNeedNavi = false
        self.navigationController?.pushViewController(forgetvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = headingArray[section]
        return array.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //是ptn的币
        if indexPath.section == 1 {
           return 430
        }
        return indexPath.section == 0 && indexPath.row == 0 ? YMAKE(110) : YMAKE(70)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTransferCell, for: indexPath) as! HomeTransferCell
            cell.selectionStyle = .none
            let heading = headingArray[indexPath.section]
            cell.headingLabel.text = heading[indexPath.row]
            let placeholder = headingContentArray[indexPath.section]
            cell.textfield.placeholder = placeholder[indexPath.row]
            if indexPath.row == 0{
                if ((UserDefaults.standard.getUserInfo().ptnaddress?.isEqual(NSNull.init())) == false){
                   cell.textfield.text = self.walletAddress
                }
                var  enableBalance = "0"
                if  self.coinDetailsVM.model.userWallet?.enableBalance != nil {
                    enableBalance = (self.coinDetailsVM.model.userWallet?.enableBalance)!
                }
                
                var unableBalance = "0"
                if  self.coinDetailsVM.model.userWallet?.unableBalance != nil {
                    unableBalance = (self.coinDetailsVM.model.userWallet?.unableBalance)!
                }
                   cell.centersY.constant = 10
                   cell.amountAvailableLabel.isHidden = false
                   cell.amountAvailableLabel.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：" + enableBalance
                   cell.freezeAmountLabel.isHidden = false
                   cell.freezeAmountLabel.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：" + unableBalance
            }else if indexPath.row == 1 {
                cell.scanCodeBtn.isHidden = false
                cell.scanCodeBtn.addTarget(self, action: #selector(scanCodeOnClick), for: .touchUpInside)
                if collectAddress != ""{
                    cell.textfield.text = collectAddress
                }
                collectTextField = cell.textfield
            }else{
                if  isPTNCoin == true {
                    if indexPath.row == 2{
                        pubKeyTextField = cell.textfield
                    } else if indexPath.row == 3 {
                        cell.textfield.keyboardType = .decimalPad
                        collectNumTextField = cell.textfield
                        cell.textfield.delegate = self
                    } else {
                        cell.textfield.isHidden = true
                        cell.setSlider()
                        if coinDetailsVM.maxModel.maxFee != nil {
                            //设置最大以及最小
                            cell.sliderMin = coinDetailsVM.maxModel.minFee!
                            cell.sliderMax = coinDetailsVM.maxModel.maxFee!
                            slider = cell.sliderView
                            sliderValueLab = cell.valueLabel
                            cell.setSliderValue()
                        }
                    }
                }else{
                    if indexPath.row == 2 {
                        cell.textfield.keyboardType = .decimalPad
                        collectNumTextField = cell.textfield
                        cell.textfield.delegate = self
                    } else{
                        cell.textfield.isHidden = true
                        cell.setSlider()
                        if coinDetailsVM.maxModel.maxFee != nil {
                            //设置最大以及最小
                            cell.sliderMin = coinDetailsVM.maxModel.minFee!
                            cell.sliderMax = coinDetailsVM.maxModel.maxFee!
                            slider = cell.sliderView
                            sliderValueLab = cell.valueLabel
                            cell.setSliderValue()
                        }
                    }
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTransferRemarkCell, for: indexPath) as! HomeTransferRemarksCell
            cell.selectionStyle = .none
            cell.setData()
//            cell.textView?.isUserInteractionEnabled = true
            self.yytextfield = cell.textView!
            cell.HomeTransferRemarksBlock = {
                self.transferOnClick()
            }
            return cell
        }
    }
    
    lazy var cointTransView: HomeCointTransView = {
        let view = Bundle.main.loadNibNamed("HomeCointTransView", owner: nil, options: nil)?.last as! HomeCointTransView
        view.frame = CGRect(x: 15, y: HomeCointTransView_y, width: Int(SCREEN_WIDTH - 30), height:HomeCointTransViewHeight)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.priceLabel.text = "≈¥--"
        view.coinNumberLabel.text = "--"
        view.numberLabel.text = LanguageHelper.getString(key: "homePage_Numbers")
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: self.naviBarView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeTransferCell", bundle: nil),forCellReuseIdentifier: self.homeTransferCell)
        tableView.register(UINib(nibName: "HomeTransferRemarksCell", bundle: nil),forCellReuseIdentifier: self.homeTransferRemarkCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:150))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        return tableView
    }()
    
    func cameraPermissions() -> Bool{
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            return false
        }else {
            return true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.closeKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationHomeReload), object: nil)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == collectNumTextField {
            return OCTools.existenceDecimal(textField.text, range: range, replacementString: string, num: R_UIThemeTransferLimit)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LBXScanViewController {
    func setCustomLBScan() ->LBXScanViewStyle{
        var style = LBXScanViewStyle()
        style.centerUpOffset = 60;
        style.xScanRetangleOffset = 30;
        if UIScreen.main.bounds.size.height <= 480 {
            //3.5inch 显示的扫码缩小
            style.centerUpOffset = 40;
            style.xScanRetangleOffset = 20;
        }
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2.0;
        style.photoframeAngleW = 16;
        style.photoframeAngleH = 16;
        style.isNeedShowRetangle = false;
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        style.animationImage = UIImage(named: "qrcode_scan_full_net")
        return style
    }
}

