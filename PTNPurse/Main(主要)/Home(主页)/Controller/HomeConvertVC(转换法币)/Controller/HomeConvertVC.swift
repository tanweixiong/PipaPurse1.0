//
//  HomeConvertVC.swift
//  PipaPurse
//
//  Created by tam on 2018/5/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeConvertVC: MainViewController {
    fileprivate let homeCoinDetailsCell = "HomeCoinDetailsCell"
    fileprivate var pageSize = 1
    fileprivate var lineSize = 10
    fileprivate lazy var viewModel : HomeListDetsilsVM = HomeListDetsilsVM()
    fileprivate lazy var baseVM : MineViewModel = MineViewModel()
    @IBOutlet weak var availableLab: UILabel!
    @IBOutlet weak var freezeLab: UILabel!
    @IBOutlet weak var navi: UIView!{
        didSet{navi.backgroundColor = R_UIThemeColor}
    }
    @IBOutlet weak var convertBtn: UIButton!{
        didSet{
            convertBtn.layer.borderWidth = 1
            convertBtn.layer.borderColor = R_UIThemeColor.cgColor
            convertBtn.setTitle(LanguageHelper.getString(key: "convert"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getListData(isRefresh: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: navi.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - navi.frame.maxY - 50))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeCoinDetailsCell", bundle: nil),forCellReuseIdentifier: self.homeCoinDetailsCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.getListData(isRefresh: false)
        })
        tableView.mj_header = MJRefreshHeader.init(refreshingBlock: {
            self.getListData(isRefresh: true)
        })
        return tableView
    }()
    
    @IBAction func onClick(_ sender: UIButton) {
        if self.baseVM.homeConvertModel.fakebalance != nil && self.baseVM.homeConvertModel.totalbalance != nil{
            let vc = HomeSubmitConvertVC()
            vc.model = self.viewModel.model.userWallet
            vc.fakebalance = (self.baseVM.homeConvertModel.fakebalance?.stringValue)!
            vc.availableAssets = (self.baseVM.homeConvertModel.totalbalance?.stringValue)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationHomeConvertReload), object: nil)
    }
}

extension HomeConvertVC {
    func setupUI(){
        setNormalNaviBar(title:LanguageHelper.getString(key: "Home_Alert_Conver"))
        availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：0"
        freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：0"
        view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshConvert), name: NSNotification.Name(rawValue: R_NotificationHomeConvertReload), object: nil)
    }
    
    @objc func refreshConvert(){
         getListData(isRefresh: true)
    }

    func getListData(isRefresh:Bool){
        if isRefresh {
            self.pageSize = 1
            self.baseVM.homeConvertListModel.removeAll()
            self.tableView.mj_footer.resetNoMoreData()
        }
        let parameters = ["token":(UserDefaults.standard.getUserInfo().token)!,"pageSize":"\(self.pageSize)","lineSize":"\(self.lineSize)"]
        baseVM.loadSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIConvertCoinList, parameters: parameters, showIndicator: false) { (hasData:Bool) in
            self.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：" + (self.baseVM.homeConvertModel.fakebalance?.stringValue)!
            self.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：" + (self.baseVM.homeConvertModel.totalbalance?.stringValue)!
            if hasData {
               self.pageSize = self.pageSize + 1
            }else{
               self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
        }
        self.tableView.mj_footer.endRefreshing()
        self.tableView.mj_header.endRefreshing()
    }
}

extension HomeConvertVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseVM.homeConvertListModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCoinDetailsCell, for: indexPath) as! HomeCoinDetailsCell
        cell.selectionStyle = .none
        if  baseVM.homeConvertListModel.count != 0 {
             cell.convertModel = baseVM.homeConvertListModel[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

