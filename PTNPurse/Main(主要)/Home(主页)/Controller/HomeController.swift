//
//  HomeController.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rid.
//

import UIKit
import SVProgressHUD

class HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource,HomeAddCoinDelegate {
    fileprivate let homeListCell = "HomeListCell"
    fileprivate lazy var viewModel : HomeViewModel = HomeViewModel()
    fileprivate lazy var receiveViewModel : HomeReceiveVM = HomeReceiveVM()
    fileprivate let selectedBtnBackground = R_UIThemeSkyBlueColor
    fileprivate let normalBtnBackground = UIColor.white
    fileprivate var isCreateWallet = true
    fileprivate var status = HomeAddCoinStatus.ptnState
    fileprivate let PTNArray = NSMutableArray() //光子专区的数组
    fileprivate let conventionalArray = NSMutableArray() //常规专区的数组
    fileprivate let otherArray = NSMutableArray()
    fileprivate let dataArray = NSMutableArray() //数据
    fileprivate var pageNum = 1
    fileprivate let pageSize = R_ListPageSize
    fileprivate var isFirst = true
    fileprivate var coinImg = String()
    struct HomeUX {
        static let stampHeight:CGFloat = 80
        static let stamp_y:CGFloat = 230 - stampHeight/2
        static let chooseWidth:CGFloat = 220
        static let chooseHeight:CGFloat = 30
        static let choose_y:CGFloat = stamp_y + stampHeight + 20
        static let headHeight:CGFloat = 340
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPtnAddress()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.addSubview(tableView)
        self.view.addSubview(backGroundVw)
        UIApplication.shared.keyWindow?.addSubview(codeView)
        NotificationCenter.default.addObserver(self, selector: #selector(setRefreshHeader), name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.automatic
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func getData(){
        let token = UserDefaults.standard.getUserInfo().token
        let language = Tools.getLocalLanguage()
        let params = ["token" :token!, "pageNum":"\(pageNum)","pageSize": "\(self.pageSize)","language":language] as [String : Any]
        if isFirst {
            isFirst = false
            SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"))
        }
        viewModel.loadHomeSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetBalance, parameters: params, showIndicator: false) {
            self.cleanArr()
            let totalMoney = self.viewModel.totalMoney == "" ? "0" : self.viewModel.totalMoney
            self.headView.totalMoneyLabel.text = Tools.getWalletAmount(amount: totalMoney)
            //处理数据类型
            if self.viewModel.model.count != 0 {
                for index in 0...self.viewModel.model.count - 1{
                    let data = self.viewModel.model[index]
                    //常规专区
                    if data.coinType == 1 {
                        self.PTNArray.add(data)
                    //光子专区
                    }else if data.coinType == 0 {
                        self.conventionalArray.add(data)
                    //其他专区
                    }else {
                        self.otherArray.add(data)
                    }
                    if (data.type?.stringValue) == Tools.getPTNcoinNo(){
                        self.coinImg = data.coinImg == nil ? "" : data.coinImg!
                        if data.address != "" && data.address != nil  {
                            let userInfo = UserDefaults.standard.getUserInfo()
                            userInfo.ptnaddress = data.address == nil ? "" : data.address
                            UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                            
                            self.headView.addressLabel.text = data.address == nil ? "" : data.address! + "   "
                        }
                    }else if (data.type?.stringValue) == "40"{
                        self.coinImg = data.coinImg == nil ? "" : data.coinImg!
                        if data.address != "" && data.address != nil  {
                            let userInfo = UserDefaults.standard.getUserInfo()
                            userInfo.ptnaddress = data.address == nil ? "" : data.address
                            UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                            
                            self.headView.addressLabel.text = data.address == nil ? "" : data.address! + "   "
                        }
                    }
                }
                if self.status == .ptnState {
                    self.dataArray.addObjects(from: self.PTNArray as! [Any])
                }else if self.status == .conventionalState {
                   self.dataArray.addObjects(from: self.conventionalArray as! [Any])
                }else{
                    self.dataArray.addObjects(from: self.otherArray as! [Any])
                }
            }
            self.tableView.reloadData()
            self.getPtnAddress()
        }
        tableView.mj_header.endRefreshing()
        //超过三秒则隐藏 
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
            SVProgressHUD.dismiss()
        })
    }
    
    func getPtnAddress(){
        let ptnaddress = UserDefaults.standard.getUserInfo().ptnaddress
        if ptnaddress == "" || ptnaddress == nil {
            self.headView.createAddressBtn.isHidden = false
            self.headView.addressLabel.text = LanguageHelper.getString(key: "homepage_Create_Address") + "   "
            self.headView.backPurseBtn.setTitle(LanguageHelper.getString(key: "homePage_Import"), for: .normal)
        }else{
            self.headView.addressLabel.text = ptnaddress! + "   "
            self.headView.backPurseBtn.setTitle(LanguageHelper.getString(key: "homePage_Export"), for: .normal)
        }
    }
    
   @objc func getAddress(){
        let ptnaddress = UserDefaults.standard.getUserInfo().ptnaddress
        if ptnaddress == "" || ptnaddress == nil {
            if isCreateWallet {
                isCreateWallet = false
                let coinNo = Tools.getPTNcoinNo()
                let token = UserDefaults.standard.getUserInfo().token
                let userId = (UserDefaults.standard.getUserInfo().id?.stringValue)!
                let parameters = ["coinNo":coinNo,"userId":"\(userId)","token":token!]
                receiveViewModel.loadReceiveSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIAddWallet, parameters: parameters, showIndicator: false) {
                    self.isCreateWallet = true
                    SVProgressHUD.dismiss()
                    self.headView.addressLabel.text = self.receiveViewModel.model.address == nil ? "" : (self.receiveViewModel.model.address)! + "   "
                    let userInfo = UserDefaults.standard.getUserInfo()
                    userInfo.ptnaddress = self.headView.addressLabel.text
                    UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
                    //生成二维码
                    let addesssDict = ["address":self.headView.addressLabel.text]
                    let addesssJson = R_Theme_QRCode + ":" + Tools.getJSONStringFromDictionary(dictionary: addesssDict as NSDictionary)
                    self.codeView.codeImageView.image = Tools.createQRForString(qrString: addesssJson, qrImageName: "")
                    SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "homepage_Create_Finish"))
                    
                    //获取钱包地址
                    self.getPtnAddress()
            }
        }
      }
    }
    
    func homeAddCoinReloadData(status: HomeAddCoinStatus) {
        self.getData()
    }
    
     @objc func onClick(_ sender:UIButton){
        if sender.tag == 1 {
            status = .ptnState
        }else if sender.tag == 2 {
            status = .conventionalState
        }else{
            status = .otherState
        }
        setReloadData()
        setBtnStyle()
    }
    
    func setReloadData(){
        //ptn专区
        self.dataArray.removeAllObjects()
        if status == .ptnState {
            self.dataArray.addObjects(from: PTNArray as! [Any])
        }else if status == .conventionalState {
            self.dataArray.addObjects(from: conventionalArray as! [Any])
        }else{
            self.dataArray.addObjects(from: otherArray as! [Any])
        }
        tableView.reloadData()
    }
    
    func setBtnStyle(){
        if status == .ptnState {
            ptnBtn.backgroundColor = selectedBtnBackground
            ptnBtn.isSelected = true
            normalBtn.backgroundColor = normalBtnBackground
            normalBtn.isSelected = false
            otherBtn.backgroundColor = normalBtnBackground
            otherBtn.isSelected = false
        }else if status == .conventionalState {
            ptnBtn.backgroundColor = normalBtnBackground
            normalBtn.backgroundColor = selectedBtnBackground
            otherBtn.backgroundColor = normalBtnBackground
            ptnBtn.isSelected = false
            normalBtn.isSelected = true
            otherBtn.isSelected = false
        }else{
            ptnBtn.backgroundColor = normalBtnBackground
            normalBtn.backgroundColor = normalBtnBackground
            otherBtn.backgroundColor = selectedBtnBackground
            ptnBtn.isSelected = false
            normalBtn.isSelected = false
            otherBtn.isSelected = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeListCell, for: indexPath) as! HomeListCell
        cell.selectionStyle = .none
        if dataArray.count != 0  {
           cell.model = dataArray[indexPath.row] as? HomeWalletsModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row] as? HomeWalletsModel
        let detsilsVC = HomeListDetsilsVC()
        detsilsVC.details = model!
        self.navigationController?.pushViewController(detsilsVC, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = self.headView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeListCell", bundle: nil),forCellReuseIdentifier: self.homeListCell)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.setRefreshHeader()
        })
        return tableView
    }()
    
    @objc func setRefreshHeader(){
        self.pageNum = 1
        self.getData()
    }
    
    lazy var headView: HomeHeadView = {
        let view = Bundle.main.loadNibNamed("HomeHeadView", owner: nil, options: nil)?.last as! HomeHeadView
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: HomeUX.headHeight)
        view.assetsTitleLabel.text = LanguageHelper.getString(key: "homePage_Total_Assets")
        view.backPurseBtn.setTitle(LanguageHelper.getString(key: "homePage_Export"), for: .normal)
        view.backPurseBtn.addTarget(self, action: #selector(handelOnClick(_:)), for: .touchUpInside)
        view.codeBtn.addTarget(self, action: #selector(handelOnClick(_:)), for: .touchUpInside)
        view.createAddressBtn.addTarget(self, action: #selector(getAddress), for: .touchUpInside)
        view.backPurseBtn.tag = 2
        view.codeBtn.tag = 1
        view.addSubview(stampView)
        view.addSubview(chooseView)
        view.addSubview(addBtn)
        return view
    }()
    
    lazy var stampView: HomeStampView = {
        let view = Bundle.main.loadNibNamed("HomeStampView", owner: nil, options: nil)?.last as! HomeStampView
        view.frame = CGRect(x: 0, y: HomeUX.stamp_y, width: SCREEN_WIDTH, height: HomeUX.stampHeight)
        view.homeStampViewBlock = {(sender:UIButton) in
            self.pushToTheController(type: sender.tag)
        }
        return view
    }()
    
    lazy var codeView: HomeCodeView = {
        let view = Bundle.main.loadNibNamed("HomeCodeView", owner: nil, options: nil)?.last as! HomeCodeView
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.isHidden = true
        if ((UserDefaults.standard.getUserInfo().ptnaddress?.isEqual(NSNull.init())) == false){
            let ptn = UserDefaults.standard.getUserInfo().ptnaddress
            let addesssDict = ["address":ptn]
            let addesssJson = R_Theme_QRCode + ":" + Tools.getJSONStringFromDictionary(dictionary: addesssDict as NSDictionary)
            view.codeImageView.image = Tools.createQRForString(qrString: addesssJson, qrImageName: "")
        }
        return view
    }()
    
    lazy var chooseView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y: HomeUX.choose_y, width: HomeUX.chooseWidth, height: HomeUX.chooseHeight))
        view.backgroundColor = UIColor.white
        view.addSubview(ptnBtn)
        view.addSubview(normalBtn)
        view.addSubview(otherBtn)
        return view
    }()

    lazy var ptnBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        Tools.setViewShadow(btn)
        btn.setTitle(LanguageHelper.getString(key: "homePage_PTN_Area"), for: .normal)
        btn.isSelected = true
        btn.frame = CGRect(x: 0, y: 0, width: HomeUX.chooseWidth/3 - 3, height: HomeUX.chooseHeight)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = R_UIThemeSkyBlueColor
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tag = 1
        return btn
    }()
    
    lazy var normalBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        Tools.setViewShadow(btn)
        btn.setTitle(LanguageHelper.getString(key: "homePage_Conv_Area"), for: .normal)
        btn.frame = CGRect(x: HomeUX.chooseWidth/3 +  5, y: 0, width: HomeUX.chooseWidth/3 - 3, height: HomeUX.chooseHeight)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tag = 2
        return btn
    }()
    
    lazy var otherBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        Tools.setViewShadow(btn)
        btn.setTitle(LanguageHelper.getString(key: "homePage_Other_Area"), for: .normal)
        btn.frame = CGRect(x: (HomeUX.chooseWidth/3) * 2 + 10, y: 0, width: HomeUX.chooseWidth/3 - 3, height: HomeUX.chooseHeight)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tag = 3
        return btn
    }()
    
    lazy var addBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        Tools.setViewShadow(btn)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 30, y: HomeUX.choose_y, width: 30,height:30)
        btn.setImage(UIImage.init(named: "ic_home_add"), for: .normal)
        btn.addTarget(self, action: #selector(handelOnClick(_:)), for: .touchUpInside)
        btn.tag = 1
        return btn
    }()
    
    lazy var backGroundVw: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 24))
        view.backgroundColor = R_UIThemeColor
        if UIDevice.current.isX() == false{
            view.isHidden = true
        }
        return view
    }()
    
    @objc func handelOnClick(_ sender:UIButton){
        if sender == addBtn {
           self.pushToTheController(type: 4)
        }else if sender == self.headView.backPurseBtn {
           self.pushToTheController(type: 5)
        }else if sender == self.headView.codeBtn {
           self.pushToTheController(type: 6)
        }
     }
    
    func cleanArr(){
        self.dataArray.removeAllObjects()
        self.PTNArray.removeAllObjects()
        self.conventionalArray.removeAllObjects()
        self.otherArray.removeAllObjects()
    }
    
    func pushToTheController(type:NSInteger){
        switch type {
        case 0:
            let homeReceiveVC = HomeReceiveVC()
            homeReceiveVC.style = .ptnStyle
            homeReceiveVC.coinName = Tools.getAppCoinName()
            
            let datailsModel = HomeWalletsModel()
            datailsModel?.coinImg = coinImg
            homeReceiveVC.detailsModel = datailsModel
            self.navigationController?.pushViewController(homeReceiveVC, animated: true)
            return
        case 1:
            let detail = HomeWalletsModel()
            detail?.coinName = Tools.getAppCoinName()
            detail?.type = Tools.getPTNcoinNum()
            
            let homeTransferVC = HomeTransferVC()
            homeTransferVC.coinNum = Tools.getPTNcoinNo()
            homeTransferVC.details = detail!
            self.navigationController?.pushViewController(homeTransferVC, animated: true)
            return
        case 2:
            let homeConversionListVC = HomeConversionListVC()
            self.navigationController?.pushViewController(homeConversionListVC, animated: true)
            return
        case 3:
            let model = HomeWalletsModel()
            let type = NumberFormatter().number(from: Tools.getPTNcoinNo())?.intValue
            model?.type = NSNumber(value: type!)
            let homeCoinDetailsVC = HomeCoinDetailsVC()
            homeCoinDetailsVC.details = model!
            self.navigationController?.pushViewController(homeCoinDetailsVC, animated: true)
            return
        case 4 :
            let homeAddCoinVC = HomeAddCoinVC()
            homeAddCoinVC.delegate = self
            self.navigationController?.pushViewController(homeAddCoinVC, animated: true)
            return
        case 5 :
            let ptnaddress = UserDefaults.standard.getUserInfo().ptnaddress
            if ptnaddress == "" || ptnaddress == nil {
                let fileSelectViewController = FileSelectViewController()
                self.navigationController?.pushViewController(fileSelectViewController, animated: true)
            }else{
                let homeBackupDetailsVC = HomeBackupDetailsVC()
                self.navigationController?.pushViewController(homeBackupDetailsVC, animated: true)
            }
            return
        case 6 :
            if UserDefaults.standard.getUserInfo().ptnaddress != nil  {
                self.codeView.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.codeView.codeBackgroundVw.alpha = 1
                    self.codeView.codeBackgroundVw.frame = CGRect(x: 30, y: 200, width: self.codeView.codeBackgroundVw.frame.size.width, height: self.codeView.codeBackgroundVw.frame.size.height)
                }, completion: { (isfinish:Bool) in
                })
            }
            return
        default:
            return
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationHomeReload), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
