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
    fileprivate let dataArray = NSMutableArray() //数据
    fileprivate let anyArray = NSMutableArray(array: [LanguageHelper.getString(key: "ic_Home_Code"),LanguageHelper.getString(key: "homePage_Export")])
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
        static let headHeight:CGFloat = 230
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPtnAddress()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.addSubview(headView)
        self.view.addSubview(tableView)
        self.view.addSubview(backGroundVw)
        self.view.addSubview(addBtn)
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
    
    override func viewDidLayoutSubviews() {
        addBtn.frame.origin = CGPoint(x: SCREEN_WIDTH - 12 - 30, y: headView.backGroundVw.frame.origin.y + headView.backGroundImg.frame.size.height - 15)
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
            SVProgressHUD.dismiss()
            self.cleanArr()
            let totalMoney = self.viewModel.totalMoney == "" ? "0" : self.viewModel.totalMoney
            let language =  language == "0" ? "CNY" : "USD"
            self.headView.totalMoneyLabel.text = totalMoney + " " + language
            //处理数据类型
            if self.viewModel.model.count != 0 {
                for index in 0...self.viewModel.model.count - 1{
                    let data = self.viewModel.model[index]
                    self.dataArray.add(data)
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
            }
            self.tableView.reloadData()
            self.getPtnAddress()
        }
        tableView.mj_header.endRefreshing()
    }
    
    func getPtnAddress(){
        let ptnaddress = UserDefaults.standard.getUserInfo().ptnaddress
        if ptnaddress == "" || ptnaddress == nil {
            self.headView.createAddressBtn.isHidden = false
            self.headView.addressLabel.text = LanguageHelper.getString(key: "homepage_Create_Address") + "   "
            self.anyArray.replaceObject(at: 1, with: LanguageHelper.getString(key: "homePage_Import"))
        }else{
            self.headView.addressLabel.text = ptnaddress! + "   "
            self.anyArray.replaceObject(at: 1, with: LanguageHelper.getString(key: "homePage_Export"))
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
                    self.getData()
            }
        }
      }
    }
    
    func homeAddCoinReloadData(status: HomeAddCoinStatus) {
        self.getData()
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
        let tableView = UITableView.init(frame: CGRect(x: 0, y: self.headView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.headView.frame.maxY))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeListCell", bundle: nil),forCellReuseIdentifier: self.homeListCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = R_UISectionLineColor
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
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
        view.createAddressBtn.addTarget(self, action: #selector(getAddress), for: .touchUpInside)
        view.anymoreBtn.addTarget(self, action: #selector(handelOnClick(_:)), for: .touchUpInside)
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
    
    lazy var addBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        Tools.setViewShadow(btn)
        btn.frame = CGRect(x: SCREEN_WIDTH - 12 - 30, y: headView.backGroundVw.frame.origin.y + headView.backGroundImg.frame.size.height - 15, width: 30,height:30)
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
        }else if sender == self.headView.anymoreBtn{
           self.pushToTheController(type: 7)
        }
     }
    
    func cleanArr(){
        self.dataArray.removeAllObjects()
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
        case 7 :
            let maxY = headView.anymoreBtn.frame.maxY + 50
            let titleArr = NSMutableArray(array: [LanguageHelper.getString(key: "ic_Home_Code")])
            let imageArr = NSMutableArray(array: ["ic_home_code"])
            //新增备份和导入功能
            if UserDefaults.standard.getUserInfo().ptnaddress != "" && UserDefaults.standard.getUserInfo().ptnaddress != nil {
                titleArr.add(LanguageHelper.getString(key: "homePage_Export"))
                imageArr.add("ic_home_backup")
                titleArr.add(LanguageHelper.getString(key: "Home_Alert_Conver"))
                imageArr.add("ic_home_conver")
            }else{
                titleArr.add(LanguageHelper.getString(key: "homePage_Import"))
                imageArr.add("ic_home_backup")
            }
            let height:CGFloat = CGFloat(titleArr.count * 43)
            let menuView = PST_MenuView.init(frame: CGRect(x: SCREEN_WIDTH - 20 - 120, y: maxY, width: 120, height: height), titleArr: titleArr as! [Any], imgArr: imageArr as! [Any], arrowOffset: 100, rowHeight: 40, layoutType: PST_MenuViewLayoutType(rawValue: 0)!, directionType: PST_MenuViewDirectionType(rawValue: 0)!, delegate: self)
            menuView?.arrowColor = UIColor.white
            menuView?.titleColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
            menuView?.lineColor = UIColor.R_UIColorFromRGB(color: 0xEDF3F8)
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

extension HomeController:PST_MenuViewDelegate{
    func didSelectRow(at index: Int, title: String!, img: String!) {
        //展示二维码
        if index == 0 {
            if UserDefaults.standard.getUserInfo().ptnaddress != nil  {
                self.codeView.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.codeView.codeBackgroundVw.alpha = 1
                    self.codeView.codeBackgroundVw.frame = CGRect(x: 30, y: 200, width: self.codeView.codeBackgroundVw.frame.size.width, height: self.codeView.codeBackgroundVw.frame.size.height)
                }, completion: { (isfinish:Bool) in
                })
            }
        }else{
            if UserDefaults.standard.getUserInfo().ptnaddress != "" && UserDefaults.standard.getUserInfo().ptnaddress != nil {
                if index == 1 {
                    let homeBackupDetailsVC = HomeBackupDetailsVC()
                    self.navigationController?.pushViewController(homeBackupDetailsVC, animated: true)
                }else if index == 2 {
                    let vc = HomeConvertVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                let fileSelectViewController = FileSelectViewController()
                self.navigationController?.pushViewController(fileSelectViewController, animated: true)
            }
        }
    }
}
