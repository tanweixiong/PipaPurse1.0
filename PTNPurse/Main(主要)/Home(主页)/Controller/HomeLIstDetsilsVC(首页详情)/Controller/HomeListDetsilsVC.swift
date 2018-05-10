//
//  HomeLIstDetsilsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/22.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeListDetsilsVC: MainViewController,UIWebViewDelegate {
    fileprivate let homeCoinDetailsCell = "HomeCoinDetailsCell"
    fileprivate lazy var viewModel : HomeListDetsilsVM = HomeListDetsilsVM()
    fileprivate var coinStyle = HomeCoinDetailsStatus.allStyle
    fileprivate lazy var listViewModel : HomeCoinDetailsVM = HomeCoinDetailsVM()
    var details =  HomeWalletsModel()!
    fileprivate var dataString = String()
    fileprivate var currentTimeString = String()
    fileprivate var dataArray = NSMutableArray()
    fileprivate var isFirst = true
    fileprivate var pageSize:Int = 0 //默认显示全部
    fileprivate var lineSize:Int = 0
    struct HomeListDetsilsUX {
        static let footHeight:CGFloat = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.getData()
        dataString = Tools.getCurrentFormatTime("yyy-MM")
        self.getTransferDetails(style: .allStyle, data: dataString)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getListData), name: NSNotification.Name(rawValue: R_NotificationHomeReload), object: nil)
    }

    lazy var fooView: HomeListDetsilsFootView = {
        let view = Bundle.main.loadNibNamed("HomeListDetsilsFootView", owner: nil, options: nil)?.last as! HomeListDetsilsFootView
        view.frame = CGRect(x: 0, y: SCREEN_HEIGHT - HomeListDetsilsUX.footHeight , width: SCREEN_WIDTH, height: HomeListDetsilsUX.footHeight)
        let type = (self.details.type?.stringValue)!
        view.footBtn1.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.footBtn2.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.footBtn1.tag = 1
        view.footBtn2.tag = 2
        view.footBtn1.setTitle(LanguageHelper.getString(key: "homePage_receive"), for: .normal)
        view.footBtn2.setTitle(LanguageHelper.getString(key: "homePage_transfer"), for: .normal)
        return view
    }()
    
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
    
    lazy var selectDetailsView: HomeSelectDetailsView = {
        let view = Bundle.main.loadNibNamed("HomeSelectDetailsView", owner: nil, options: nil)?.last as! HomeSelectDetailsView
        view.frame = CGRect(x: 0, y: naviBarView.frame.maxY, width: SCREEN_WIDTH, height: 60)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        view.transferBtn.tag = 2
        view.transferBtn.addTarget(self, action: #selector(selectDetailsOnClick(_:)), for: .touchUpInside)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y:selectDetailsView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - selectDetailsView.frame.maxY - HomeListDetsilsUX.footHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeCoinDetailsCell", bundle: nil),forCellReuseIdentifier: self.homeCoinDetailsCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        tableView.separatorStyle = .none
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.getTransferDetails(style: self.coinStyle, data: self.dataString)
        })
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.clean()
            self.getTransferDetails(style: self.coinStyle, data: self.dataString)
        })
        return tableView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationHomeReload), object: nil)
    }
}

extension HomeListDetsilsVC {
    func setupUI(){
        //添加头部
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: "")
        naviBarView.addSubview(conversionStatusView)
        naviBarView.addSubview(detsilsAssetsView)
        view.addSubview(selectDetailsView)
        view.addSubview(tableView)
        view.addSubview(fooView)
    }
    
    @objc func onClick(_ sender:UIButton){
        if sender.tag == 1 {
            if viewModel.model.userWallet?.address! != nil && viewModel.model.userWallet?.coinName! != nil {
                let address = viewModel.model.userWallet?.address!
                let receiveVC  = HomeReceiveVC()
                receiveVC.coinName = (viewModel.model.userWallet?.coinName!)!
                receiveVC.walletaddress = address!
                receiveVC.detailsModel = self.details
                self.navigationController?.pushViewController(receiveVC, animated: true)
            }
        }else if sender.tag == 2 {
            let homeTransferVC = HomeTransferVC()
            homeTransferVC.coinNum = (self.details.type?.stringValue)!
            homeTransferVC.details = self.details
            self.navigationController?.pushViewController(homeTransferVC, animated: true)
        }else if sender.tag == 3{
            let homeCoinDetailsVC = HomeCoinDetailsVC()
            homeCoinDetailsVC.coinNum = (self.details.type?.stringValue)!
            homeCoinDetailsVC.details = self.details
            self.navigationController?.pushViewController(homeCoinDetailsVC, animated: true)
        }
    }
    
    @objc func selectDetailsOnClick(_ sender:UIButton){
       if sender.tag == 2{
            let model = self.details
            let coinNo = (model.type?.stringValue)!
            let homeCoinTransferDetailsVC = HomeCoinTransferDetailsVC()
            homeCoinTransferDetailsVC.coinNum = coinNo
            self.navigationController?.pushViewController(homeCoinTransferDetailsVC, animated: true)
        }
    }
    
    //网络请求
    @objc func getData(){
        let type = (self.details.type?.stringValue)!
        let language = Tools.getLocalLanguage()
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["type":type,"language":language,"token":token!]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"))
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetCoinDetail, parameters: parameters, showIndicator: false) {
            SVProgressHUD.dismiss()
            let model = self.viewModel.model.userWallet
            
            let name = model?.coinName == nil ? "--" : model?.coinName
            self.conversionStatusView.coinNameLabel.text = name
            
            let url = model?.coinImg == nil ? "" : model?.coinImg
            self.conversionStatusView.iconImageView.sd_setImage(with:NSURL(string: url!)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
            
            let balance = model?.balance == nil ? "0" : (model?.balance?.stringValue)!
            self.conversionStatusView.USDPriceLabel.text = Tools.getWalletAmount(amount: balance)
            
            let money = self.viewModel.model.Money == nil ? "0" : (self.viewModel.model.Money?.stringValue)!
            self.conversionStatusView.CNYPriceLabel.text = Tools.getWalletAmount(amount: money)
            
            self.conversionStatusView.rankLabel1.text = LanguageHelper.getString(key: "homePage_Numbers")
            

            let enableBalance = model?.enableBalance == nil ? "0" : model?.enableBalance
            self.detsilsAssetsView.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available")  + "：" + enableBalance!
            
            let unableBalance = model?.unableBalance == nil ? "0" : model?.unableBalance
            self.detsilsAssetsView.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") +  "：" + unableBalance!
        }
    }
    
    @objc func getListData(){
        self.getTransferDetails(style: coinStyle, data: dataString)
    }
    
    //获取所有的转账明细
    func getTransferDetails(style:HomeCoinDetailsStatus,data:String){
        let style = "3"
        let coinNo = self.details.type == nil ? Tools.getPTNcoinNo() : (self.details.type?.stringValue)!
        let token = UserDefaults.standard.getUserInfo().token
        let type = style
        let date = data
        let pageSize = "\(self.pageSize)"
        let lineSize = self.lineSize
        let parameters = ["token":token!,"coinNo":coinNo,"type":type,"date":date,"pageSize":pageSize,"lineSize":lineSize] as [String : Any]
        print(parameters)
        listViewModel.loadCoinDetailsSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetTradeInfo, parameters: parameters, showIndicator: false) {
            if self.listViewModel.model.count == 0 {
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            self.pageSize = self.pageSize + 1
            let array = NSMutableArray()
            array.addObjects(from: self.dataArray as! [Any])
            array.addObjects(from: self.listViewModel.model)
            self.dataArray = array
            self.tableView.reloadData()
        }
        if isFirst {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            isFirst = false
        }else{
            tableView.mj_footer.endRefreshing()
        }
        tableView.mj_header.endRefreshing()
    }
    
    func clean(){
        self.pageSize = 0
        self.lineSize = 0
        self.listViewModel.model.removeAll()
        self.dataArray.removeAllObjects()
    }
    
}

extension HomeListDetsilsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCoinDetailsCell, for: indexPath) as! HomeCoinDetailsCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if dataArray.count != 0 {
           cell.model = self.dataArray[indexPath.section] as? HomeCoinDetailsModel
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArray[indexPath.section] as! HomeCoinDetailsModel
        let homeTransferDetailsVC = HomeTransferDetailsVC()
        homeTransferDetailsVC.style = model.type == 0 ? .receiveStyle : .transferStyle
        homeTransferDetailsVC.transactionId = (model.id?.stringValue)!
        self.navigationController?.pushViewController(homeTransferDetailsVC, animated: true)
    }
}

