//
//  HomeCoinTransferDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/29.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeCoinTransferDetailsVC: MainViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate let homeCoinDetailsCell = "HomeCoinDetailsCell"
    fileprivate lazy var viewModel : HomeCoinDetailsVM = HomeCoinDetailsVM()
    fileprivate var pageNum:Int = 1
    fileprivate var pageSize:Int = 6
    var coinNum = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.setNormalNaviBar(title: LanguageHelper.getString(key: "homePage_conversion"))
        self.getData()
    }
    
    func getData(){
        let language = Tools.getLocalLanguage()
        let userId = UserDefaults.standard.getUserInfo().id
        let token = UserDefaults.standard.getUserInfo().token
        let coinNo = coinNum
        let pageNum = "\(self.pageNum)"
        let pageSize = "\(self.pageSize)"
        var parameters = NSDictionary()
        if coinNum == Tools.getPTNcoinNo() {
            let inCoinNo = Tools.getPTNcoinNo()
            parameters = ["language":language,"userId":(userId?.stringValue)!,"token":token!,"pageNum":pageNum,"pageSize":pageSize,"coinNo":coinNo,"inCoinNo":inCoinNo] as [String : Any] as NSDictionary
        }else{
            let outCoinNo = coinNo
            parameters = ["language":language,"userId":(userId?.stringValue)!,"token":token!,"pageNum":pageNum,"pageSize":pageSize,"coinNo":coinNo,"outCoinNo":outCoinNo] as [String : Any] as NSDictionary
        }
        viewModel.loadCoinTransferDetailsSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIChangeChangeList, parameters: parameters as? [String : Any], showIndicator: false) {
            self.pageNum = self.pageNum + 1
            self.tableView.reloadData()
        }
        self.tableView.mj_footer.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  viewModel.transferModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCoinDetailsCell, for: indexPath) as! HomeCoinDetailsCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.transferModel = viewModel.transferModel[indexPath.section]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.transferModel[indexPath.section]
        let conversionDetials = HomeConversionDetialsModel()
        conversionDetials?.orderNo = model.orderNo
        conversionDetials?.address = model.address
        conversionDetials?.coinNum = model.coinNum
        conversionDetials?.dateString = model.dateString
        conversionDetials?.remark = model.remark
        conversionDetials?.ratio = model.ratio
        conversionDetials?.coinName = model.outCoinName
        conversionDetials?.coinFlag = model.changeFlag
        conversionDetials?.pnt = model.pnt
    
        let vc = HomeTransferDetailsVC()
        vc.conversionDetials = conversionDetials
        vc.style = .conversionStyle
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT -  MainViewControllerUX.naviNormalHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeCoinDetailsCell", bundle: nil),forCellReuseIdentifier: self.homeCoinDetailsCell)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.getData()
        })
        return tableView
    }()
}
