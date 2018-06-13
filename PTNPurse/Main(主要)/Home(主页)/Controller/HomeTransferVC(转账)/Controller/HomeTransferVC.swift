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

class HomeTransferVC: MainViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,PaymentPasswordDelegate,LBXScanViewControllerDelegate {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    fileprivate lazy var coinDetailsVM : HomeListDetsilsVM = HomeListDetsilsVM()
    var details =  HomeWalletsModel()!
    var address = String()
    var coinNum = String()
    fileprivate var collectTextField = UITextField()
    fileprivate var collectNumTextField = UITextField()
    fileprivate var outAddressTextField = UITextField()
    fileprivate var sliderValueLab = UILabel()
    fileprivate var yytextfield = YYTextView()
    fileprivate var collectAddress = ""
    fileprivate var slider = UISlider()
    fileprivate let homeTransferCell = "HomeTransferCell"
    fileprivate let homeTransferRemarkCell = "HomeTransferRemarkCell"
    fileprivate let HomeCointTransViewHeight = 50
    fileprivate let HomeCointTransView_y =  111
    fileprivate var walletAddress = String()
    fileprivate var isPTNCoin = false
    fileprivate var headingArray = [
        [LanguageHelper.getString(key: "homePage_Wallet_Address")
        ,LanguageHelper.getString(key: "homePage_Receivables_Address")
        ,LanguageHelper.getString(key: "homePage_Number")
        ,LanguageHelper.getString(key: "homePage_Miner_Fee")]
        ,[LanguageHelper.getString(key: "homePage_Remark_Information")]]
    fileprivate var headingContentArray = [
        [LanguageHelper.getString(key: "homePage_Transfer_Key")
        ,LanguageHelper.getString(key: "homePage_Transfer_Scan_Address")
        ,LanguageHelper.getString(key: "homePage_Transfer_textField_Number")
        ,LanguageHelper.getString(key: "homePage_Miner_Fee")]
        ,[LanguageHelper.getString(key: "homePage_Transfer_Scan_Address")]]
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title:"")
        naviBarView.addSubview(conversionStatusView)
        naviBarView.addSubview(detsilsAssetsView)
        view.addSubview(tableView)
        view.addSubview(determineBtn)
        self.getCoinData()
        self.getMaxFeeData()
        NotificationCenter.default.addObserver(self, selector: #selector(getCoinData), name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTransferVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    @objc func getCoinData(){
        let type = details.type == nil ? Tools.getPTNcoinNo() : (details.type?.stringValue)!
        let language = Tools.getLocalLanguage()
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["type":type,"language":language,"token":token!]
        coinDetailsVM.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetCoinDetail, parameters: parameters, showIndicator: false) {
            
            let model = self.coinDetailsVM.model.userWallet
            let name = model?.coinName == nil ? "--" : model?.coinName
            self.conversionStatusView.coinNameLabel.text = name
            let url = model?.coinImg == nil ? "" : model?.coinImg
            self.conversionStatusView.iconImageView.sd_setImage(with:NSURL(string: url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            let balance = model?.balance == nil ? "0" : (model?.balance?.stringValue)!
            self.conversionStatusView.USDPriceLabel.text = Tools.getWalletAmount(amount: balance)
            
            let money = self.coinDetailsVM.model.Money == nil ? "0" : (self.coinDetailsVM.model.Money?.stringValue)!
            self.conversionStatusView.CNYPriceLabel.text = Tools.getWalletAmount(amount: money)
            self.conversionStatusView.rankLabel1.text = LanguageHelper.getString(key: "homePage_Numbers")
            let enableBalance = model?.enableBalance == nil ? "0" : model?.enableBalance
            self.detsilsAssetsView.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available")  + "：" + enableBalance!
            let unableBalance = model?.unableBalance == nil ? "0" : model?.unableBalance
            self.detsilsAssetsView.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") +  "：" + unableBalance!
            
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
    
    @objc func textFieldTextDidChangeOneCI(noti:NSNotification){
        setDetermineStyle()
    }
    
    @objc func transferOnClick(){
        if Tools.noPaymentPasswordIsSetToExecute() == false{return}
        if checkEnter(){
            let coinName = details.coinName == nil ? "" : (details.coinName)!
            let feeName = details.type == 40 ? "ETH" : coinName
            let fee = sliderValueLab.text! + feeName
            let collectNum = collectNumTextField.text!  + coinName
            let input = PaymentPasswordVw(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            input?.delegate = self
            input?.isMiners = true
            input?.setUpFeesMinersFeesPoundage(fee, tradeNumber: collectNum)
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
        let fee = sliderValueLab.text!

        var parameters = NSDictionary()
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
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"))
        ZYNetWorkTool.requestData(.post, URLString: ZYConstAPI.kAPIAddTradeInfo, language: false, parameters: parameters as? [String : Any], showIndicator: false, success: { (json) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
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
            setDetermineStyle()
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
    
    func checkInpunt()->Bool{
        let inAddress = collectTextField.text!
        let tradeNum = collectNumTextField.text!
        let outAddress = outAddressTextField.text!
        if inAddress.count == 0 {
            return false
        }
        
        if outAddress.count == 0 {
            return false
        }
        
        if tradeNum.count == 0 {
            return false
        }
        return true
    }
    
    func setDetermineStyle(){
        if checkInpunt() {
            determineBtn.backgroundColor = R_UIThemeColor
            determineBtn.isUserInteractionEnabled = true
             determineBtn.isSelected = true
        }else{
            determineBtn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCAE9FD)
            determineBtn.isUserInteractionEnabled = false
            determineBtn.isSelected = false
        }
    }
    
    private func PaymentPasswordChangeForgetPassword(){
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
           return 300
        }
        return YMAKE(70)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTransferCell, for: indexPath) as! HomeTransferCell
            cell.selectionStyle = .none
            let heading = headingArray[indexPath.section]
            cell.headingLabel.text = heading[indexPath.row]
            let placeholder = headingContentArray[indexPath.section]
            cell.textfield.placeholder = placeholder[indexPath.row]
            cell.textfield.delegate = self
            if indexPath.row == 0{
                if ((UserDefaults.standard.getUserInfo().ptnaddress?.isEqual(NSNull.init())) == false){
                   cell.textfield.text = self.walletAddress
                   cell.firstBluebBackgroundVw.isHidden = false
                   cell.tfBackGroundDistance.constant = 24
                }
                outAddressTextField = cell.textfield
            }else if indexPath.row == 1 {
                cell.scanCodeBtn.isHidden = false
                cell.scanCodeBtn.addTarget(self, action: #selector(scanCodeOnClick), for: .touchUpInside)
                cell.firstBluebBackgroundVw.isHidden = false
                if collectAddress != ""{
                    cell.textfield.text = collectAddress
                }
                collectTextField = cell.textfield
                cell.textfield.delegate = self
            }else{
                if indexPath.row == 2 {
                    cell.textfield.keyboardType = .decimalPad
                    cell.lineVw.isHidden = false
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
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: homeTransferRemarkCell, for: indexPath) as! HomeTransferRemarksCell
            cell.selectionStyle = .none
            cell.setData()
            cell.submitBtn.isHidden = true
            cell.lineView.isHidden = true
            cell.textView?.layer.borderWidth = 1
            cell.textView?.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xF1F1F1).cgColor
            cell.textView?.layer.cornerRadius = 5
            cell.textView?.layer.masksToBounds = true
            cell.textView?.backgroundColor = UIColor.white
            cell.textView?.placeholderText = LanguageHelper.getString(key: "Transfer_Remark")
            self.yytextfield = cell.textView!
            return cell
        }
    }
    
    lazy var detsilsAssetsView: HomeDetsilsAssetsView = {
        let view = Bundle.main.loadNibNamed("HomeDetsilsAssetsView", owner: nil, options: nil)?.last as! HomeDetsilsAssetsView
        view.frame = CGRect(x: 0, y: Int(MainViewControllerUX.naviHeight) - 35 - 16 , width: Int(SCREEN_WIDTH), height: 35)
        view.backgroundColor = R_UIThemeSkyBlueColor
        view.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：0"
        view.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：0"
        return view
    }()
    
    lazy var conversionStatusView: HomeConversionStatusView = {
        let view = Bundle.main.loadNibNamed("HomeConversionStatusView", owner: nil, options: nil)?.last as! HomeConversionStatusView
        view.frame = CGRect(x: 0, y: Int(MainViewControllerUX.naviHeight) - 16 - 35 - 64 , width: Int(SCREEN_WIDTH), height: 64)
        view.rankLabel1.text = LanguageHelper.getString(key: "homePage_Numbers")
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: self.naviBarView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.naviBarView.frame.maxY - 50 ))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeTransferCell", bundle: nil),forCellReuseIdentifier: self.homeTransferCell)
        tableView.register(UINib(nibName: "HomeTransferRemarksCell", bundle: nil),forCellReuseIdentifier: self.homeTransferRemarkCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height:0))
        footView.backgroundColor = UIColor.white
        tableView.tableFooterView = footView
        return tableView
    }()
    
    lazy var determineBtn: UIButton = {
        let btn  = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "ic_home_trans_white"), for: .normal)
        btn.setTitle(LanguageHelper.getString(key: "homePage_Confirm_Transfer"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -15)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 50, width: SCREEN_WIDTH, height: 50)
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCAE9FD)
        btn.addTarget(self, action: #selector(HomeTransferVC.transferOnClick), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        return btn
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         setDetermineStyle()
        if textField == collectNumTextField {
            if range.location == 0 && string == "."{
                return false
            }
            return OCTools.isRight(inPutOf: textField.text, withInputString: string, range: range, num: R_UIThemeTransferLimit)
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

