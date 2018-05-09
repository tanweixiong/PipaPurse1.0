//
//  HomeCoinDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum HomeCoinDetailsStatus {
    case allStyle //转账
    case inStyle //转入
    case outStyle //转出
}
class HomeCoinDetailsVC: MainViewController,UITableViewDelegate,UITableViewDataSource,PST_MenuViewDelegate {
    fileprivate let homeCoinDetailsCell = "HomeCoinDetailsCell"
    fileprivate lazy var viewModel : HomeCoinDetailsVM = HomeCoinDetailsVM()
    fileprivate lazy var coinDetailsVM : HomeListDetsilsVM = HomeListDetsilsVM()
    fileprivate var coinStyle = HomeCoinDetailsStatus.allStyle
    fileprivate var dataString = String()
    fileprivate var dataArray = NSMutableArray()
    fileprivate let HomeCointTransViewHeight = 50
    fileprivate var currentTimeString = String()
    fileprivate var pageSize:Int = 0 //默认显示全部
    fileprivate var lineSize:Int = 0
    fileprivate var isFirst = true
    var details =  HomeWalletsModel()!
    var coinNum = String()
    struct HomeCoinDetailsUX {
        static let chooseView_y:CGFloat = 70
        static let chooseViewWidth:CGFloat = 155
        static let chooseViewHeight:CGFloat = 30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coinName = details.coinName == nil ? "PNT" : details.coinName
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: coinName! + " " + LanguageHelper.getString(key: "homePage_details"))
        naviBarView.addSubview(self.cointTransView)
        view.addSubview(chooseView)
        view.addSubview(selectDetailsView)
        view.addSubview(tableView)
        dataString = Tools.getCurrentFormatTime("yyy-MM")
        self.getTransferDetails(style: .allStyle, data: dataString)
        self.getCoinData()
    }
    
    //获取所有的转账明细
    func getTransferDetails(style:HomeCoinDetailsStatus,data:String){
//      0 转入 1 传出  3全部
        var style = ""
        if self.coinStyle == .allStyle {
            style = "3"
        }else if self.coinStyle == .inStyle {
            style = "0"
        }else if self.coinStyle == .outStyle {
            style = "1"
        }
        let coinNo = self.details.type == nil ? Tools.getPTNcoinNo() : (self.details.type?.stringValue)!
        let token = UserDefaults.standard.getUserInfo().token
        let type = style
        let date = data
        let pageSize = "\(self.pageSize)"
        let lineSize = self.lineSize
        let parameters = ["token":token!,"coinNo":coinNo,"type":type,"date":date,"pageSize":pageSize,"lineSize":lineSize] as [String : Any]
        print(parameters)
        viewModel.loadCoinDetailsSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetTradeInfo, parameters: parameters, showIndicator: false) {
            if self.viewModel.model.count == 0 {
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            self.pageSize = self.pageSize + 1
            let array = NSMutableArray()
            array.addObjects(from: self.dataArray as! [Any])
            array.addObjects(from: self.viewModel.model)
            self.dataArray = array
            self.tableView.reloadData()
        }
        if isFirst {
          tableView.mj_footer.endRefreshingWithNoMoreData()
          isFirst = false
        }else{
          tableView.mj_footer.endRefreshing()
        }
    }
    
    func getCoinData(){
        let type = self.details.type == nil ? Tools.getPTNcoinNo() : (self.details.type?.stringValue)!
        let language = Tools.getLocalLanguage()
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["type":type,"language":language,"token":token!]
        coinDetailsVM.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetCoinDetail, parameters: parameters, showIndicator: false) {
            self.cointTransView.coinNumberLabel.text = self.coinDetailsVM.model.userWallet?.balance == nil ? "--" : (self.coinDetailsVM.model.userWallet?.balance?.stringValue)!
            let price = self.coinDetailsVM.model.Money == nil ? "0" : (self.coinDetailsVM.model.Money?.stringValue)!
            self.cointTransView.priceLabel.text = "≈"  + "¥" + price + "CNY"
        }
    }
    
    func didSelectRow(at index: Int, title: String!, img: String!) {
        //全部
        if index == 0 {
            coinStyle = .allStyle
        //转入
        }else if index == 1 {
            coinStyle = .inStyle
        //转出
        }else if index == 2 {
            coinStyle = .outStyle
        }
        selectDetailsView.allLabel.text = title
        clean()
        self.getTransferDetails(style: coinStyle, data: dataString)
    }

    @objc func setData(){
        let datePickerView = QFDatePickerView.init()
        datePickerView.delegate = self
        datePickerView.setDataPackerWithResponse()
    }
    
    @objc func onClick(_ sender:UIButton){
        if sender.tag == 1 {
            let homeReceiveVC = HomeReceiveVC()
            homeReceiveVC.coinName = coinDetailsVM.model.userWallet?.coinName == nil ? "PNT" : (coinDetailsVM.model.userWallet?.coinName)!
            let address = coinDetailsVM.model.userWallet?.address == nil ? "" : (coinDetailsVM.model.userWallet?.address)!
            homeReceiveVC.walletaddress = address
            homeReceiveVC.detailsModel = coinDetailsVM.model.userWallet
            self.navigationController?.pushViewController(homeReceiveVC, animated: true)
        }else if sender.tag == 2{
            let homeTransferVC = HomeTransferVC()
            homeTransferVC.details = self.details
            self.navigationController?.pushViewController(homeTransferVC, animated: true)
        //全部
        }else if sender.tag == 3 {
            let menuView = PST_MenuView.init(frame: CGRect(x: 15, y: selectDetailsView.frame.maxY, width: 120, height: 135), titleArr: [LanguageHelper.getString(key: "homePage_Details_All"),LanguageHelper.getString(key: "homePage_Details_Turn_Into"),LanguageHelper.getString(key: "homePage_Details_Turn_Out")], imgArr: nil, arrowOffset: 30, rowHeight: 40, layoutType: PST_MenuViewLayoutType(rawValue: 1)!, directionType: PST_MenuViewDirectionType(rawValue: 0)!, delegate: self)
             menuView?.arrowColor = UIColor.white
             menuView?.titleColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        //转账记录别表
        }else if sender.tag == 4 {
            let model = self.details
            let coinNo = (model.type?.stringValue)!
            let homeCoinTransferDetailsVC = HomeCoinTransferDetailsVC()
            homeCoinTransferDetailsVC.coinNum = coinNo
            self.navigationController?.pushViewController(homeCoinTransferDetailsVC, animated: true)
        }
    }
    
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
        cell.model = self.dataArray[indexPath.section] as? HomeCoinDetailsModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let model = self.dataArray[indexPath.section] as! HomeCoinDetailsModel
         let homeTransferDetailsVC = HomeTransferDetailsVC()
         homeTransferDetailsVC.style = model.type == 0 ? .receiveStyle : .transferStyle
         homeTransferDetailsVC.transactionId = (model.id?.stringValue)!
         self.navigationController?.pushViewController(homeTransferDetailsVC, animated: true)
    }
    
    lazy var cointTransView: HomeCointTransView = {
        let view = Bundle.main.loadNibNamed("HomeCointTransView", owner: nil, options: nil)?.last as! HomeCointTransView
        view.frame = CGRect(x: 15, y: Int(MainViewControllerUX.naviHeight_y), width: Int(SCREEN_WIDTH - 30), height:HomeCointTransViewHeight)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.priceLabel.text = "≈¥--"
        view.coinNumberLabel.text = "--"
        view.numberLabel.text = LanguageHelper.getString(key: "homePage_Numbers")
        return view
    }()
    
    lazy var selectDetailsView: HomeSelectDetailsView = {
        let view = Bundle.main.loadNibNamed("HomeSelectDetailsView", owner: nil, options: nil)?.last as! HomeSelectDetailsView
        view.frame = CGRect(x: 0, y: naviBarView.frame.maxY, width: SCREEN_WIDTH, height: 60)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        view.dataBtn.addTarget(self, action: #selector(setData), for: .touchUpInside)
        view.transferBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.allBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.dataLabel.text = Tools.getCurrentFormatTime("yyy-MM")
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviHeight + 60, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviHeight - 60))
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
        return tableView
    }()
    
    func clean(){
        self.pageSize = 1
        self.lineSize = 10
        self.viewModel.model.removeAll()
        self.dataArray.removeAllObjects()
    }
    
    lazy var chooseView: UIView = {
        let view = UIView(frame: CGRect(x: SCREEN_WIDTH - 20 - HomeCoinDetailsUX.chooseViewWidth , y: HomeCoinDetailsUX.chooseView_y, width: HomeCoinDetailsUX.chooseViewWidth, height: HomeCoinDetailsUX.chooseViewHeight))
        view.backgroundColor = UIColor.clear
        view.addSubview(ptnBtn)
        view.addSubview(normalBtn)
        return view
    }()
    
    lazy var ptnBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "homePage_receive"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 75, height: HomeCoinDetailsUX.chooseViewHeight)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 1
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var normalBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "homePage_transfer"), for: .normal)
        btn.frame = CGRect(x:  80, y: 0, width: 75, height: HomeCoinDetailsUX.chooseViewHeight)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 2
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        return btn
    }()
}

extension HomeCoinDetailsVC:DatePickerDetegate{
    func datePacker(withResponse data: String!) {
        self.selectDetailsView.dataLabel.text = data
        self.currentTimeString = (data)!
        self.dataString = self.currentTimeString
        self.clean()
        self.getTransferDetails(style: self.coinStyle, data: self.dataString)
    }
}
