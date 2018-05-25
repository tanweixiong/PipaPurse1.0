//
//  QuotesVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import YYText

enum QuotesStyle {
    case normalStyle
    case otherStyle
}

class QuotesVC: MainViewController {
    fileprivate lazy var viewModel : QuotesVM = QuotesVM()
    fileprivate let homeListCell = "HomeListCell"
    fileprivate let titleTex = LanguageHelper.getString(key: "quotes_tab")
    fileprivate var style = QuotesStyle.normalStyle
    fileprivate let normalArray = NSMutableArray()
    fileprivate let otherArray = NSMutableArray()
    fileprivate let dataArray = NSMutableArray()
    fileprivate let searchArray = NSMutableArray()
    fileprivate let dataScore = NSMutableArray()
    fileprivate let selectedBtnBackground = R_UIThemeSkyBlueColor
    fileprivate let normalBtnBackground = UIColor.white
    struct QuotesUX {
        static let stampHeight:CGFloat = 80
        static let stamp_y:CGFloat = 230 - stampHeight/2
        static let chooseWidth:CGFloat = 220
        static let chooseHeight:CGFloat = 30
        static let choose_y:CGFloat = stamp_y + stampHeight + 20
        static let headHeight:CGFloat = 340
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }
    
    lazy var chooseView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y:MainViewControllerUX.naviNormalHeight, width: QuotesUX.chooseWidth, height: 60))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight - 44))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeListCell", bundle: nil),forCellReuseIdentifier: self.homeListCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.viewModel.model.removeAll()
            self.dataArray.removeAllObjects()
            self.getData()
        })
        return tableView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension QuotesVC {
    func setupUI(){
        setNormalNaviBar(title: titleTex)
        self.naviBarView.height = 115.00
        setHideBackBtn()
        view.addSubview(chooseView)
        view.addSubview(tableView)
    }
    
    func getData(){
        let userId = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["language":Tools.getLocalLanguage(),"userId":userId,"token":token!]
        viewModel.loadQuotesSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIOpenCoinList, parameters: parameters, showIndicator: false) {
            //处理数据类型 0 常规1 光子
            if self.viewModel.model.count != 0 {
                for index in 0...self.viewModel.model.count - 1{
                    let data = self.viewModel.model[index]
                    self.dataArray.add(data)
                }
            }
            self.tableView.reloadData()
        }
        self.tableView.mj_header.endRefreshing()
    }
}

extension QuotesVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.y
        if x > 30  && scrollView.isEqual(tableView){
            closeKeyboard()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeListCell, for: indexPath) as! HomeListCell
        cell.selectionStyle = .none
        let data = dataArray[indexPath.row] as! QuotesModel
        cell.quotesModel = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row] as! QuotesModel
        if model.coinNo == 40 || model.coinNo == 50 || model.coinNo == 90 || model.coinNo == 30 {
             return
        }
        let quotesDetailsVC = QuotesDetailsVC()
        quotesDetailsVC.model = model
        self.navigationController?.pushViewController(quotesDetailsVC, animated: true)
    }
}


