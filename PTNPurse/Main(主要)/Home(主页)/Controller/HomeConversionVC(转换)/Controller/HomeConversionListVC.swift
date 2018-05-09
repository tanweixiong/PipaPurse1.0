//
//  HomeConversionListVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeConversionListVC: MainViewController,UITableViewDataSource,UITableViewDelegate {
    fileprivate let homeListCell = "HomeListCell"
    fileprivate let selectedBGColor = R_UIThemeSkyBlueColor
    fileprivate let normalBGColor = UIColor.white
    fileprivate lazy var viewModel : HomeConversionVM = HomeConversionVM()
    fileprivate var style = QuotesStyle.normalStyle
    fileprivate let normalArray = NSMutableArray()
    fileprivate let otherArray = NSMutableArray()
    fileprivate let dataArray = NSMutableArray()
    fileprivate let PTNArray = NSMutableArray()
    fileprivate let conventionalArray = NSMutableArray()
    fileprivate let cellHeight:Int = 90
    fileprivate let selectedBtnBackground = R_UIThemeSkyBlueColor
    fileprivate let normalBtnBackground = UIColor.white
    struct HomeConversionListUX {
        static let stampHeight:CGFloat = 80
        static let stamp_y:CGFloat = 230 - stampHeight/2
        static let chooseWidth:CGFloat = 220
        static let chooseHeight:CGFloat = 30
        static let choose_y:CGFloat = stamp_y + stampHeight + 20
        static let headHeight:CGFloat = 340
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNormalNaviBar(title: LanguageHelper.getString(key: "homePage_conversion"))
        view.addSubview(chooseView)
        view.addSubview(tableView)
        self.getConventionalData()
    }
    
    //常规专区
    func getConventionalData(){
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"))
       let language = Tools.getLocalLanguage()
       let userId = (UserDefaults.standard.getUserInfo().id?.stringValue)!
       let token = UserDefaults.standard.getUserInfo().token!
       let parameters = ["language":language,"userId":userId,"token":token]
        viewModel.loadConventionalConversionSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIQueryRoutineList, parameters: parameters, showIndicator: false) {
            SVProgressHUD.dismiss()
            if self.viewModel.Conventionalmodel.count != 0 {
                for index in 0...self.viewModel.Conventionalmodel.count - 1{
                    let data = self.viewModel.Conventionalmodel[index]
                    //常规专区
                    if data.coinBlock == 0 {
                        self.normalArray.add(data)
                        //光子专区
                    }else {
                        self.otherArray.add(data)
                    }
                }
                if self.style == .normalStyle {
                    self.dataArray.addObjects(from: self.normalArray as! [Any])
                }else if self.style == .otherStyle{
                    self.dataArray.addObjects(from: self.otherArray as! [Any])
                }
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func onClick(_ sender:UIButton){
        if sender.tag == 1 {
            style = .normalStyle
        }else if sender.tag == 2 {
            style = .otherStyle
        }
        setReload()
        setBtnStyle()
    }
    
    func setBtnStyle(){
        if style == .normalStyle {
            normalBtn.backgroundColor = selectedBtnBackground
            normalBtn.isSelected = true
            otherBtn.backgroundColor = normalBtnBackground
            otherBtn.isSelected = false
        }else if style == .otherStyle {
            otherBtn.backgroundColor = selectedBtnBackground
            otherBtn.isSelected = true
            normalBtn.backgroundColor = normalBtnBackground
            normalBtn.isSelected = false
        }
    }
    
    func setReload(){
        //ptn专区
        self.dataArray.removeAllObjects()
        if style == .normalStyle {
            self.dataArray.addObjects(from: normalArray as! [Any])
        }else if style == .otherStyle {
            self.dataArray.addObjects(from: otherArray as! [Any])
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeListCell, for: indexPath) as! HomeListCell
        cell.selectionStyle = .none
        let model = dataArray[indexPath.row] as! HomeConversionListModel
        let coinImg = model.coinImg == nil ? "" : model.coinImg
        cell.coinNameLabel.text = model.coinName
        
        if Tools.getIsChinese() {
            cell.balanceLabel.text = Tools.getWalletAmount(amount: (model.coinPriceBySys?.stringValue)!) + " CNY"
            cell.moneyRateLabel.text = Tools.getWalletAmount(amount: (model.coinPrice?.stringValue)!) + " USD"
        }else{
            cell.balanceLabel.text = Tools.getWalletAmount(amount: (model.coinPriceBySys?.stringValue)!) + " USD"
            cell.moneyRateLabel.text = Tools.getWalletAmount(amount: (model.coinPrice?.stringValue)!) + " CNY"
        }
        cell.coinImage.sd_setImage(with: URL.init(string: (coinImg)!), placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row] as! HomeConversionListModel
        let homeConversionVC = HomeConversionVC()
        homeConversionVC.details = model
        self.navigationController?.pushViewController(homeConversionVC, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y:chooseView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - chooseView.frame.maxY))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeListCell", bundle: nil),forCellReuseIdentifier: self.homeListCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        return tableView
    }()
    
    lazy var noDataView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: XMAKE(100), height: YMAKE(150)))
        image.center = view.center
        view.addSubview(image)
        return view
    }()
    
    lazy var chooseView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y:MainViewControllerUX.naviNormalHeight, width: HomeConversionListUX.chooseWidth, height: 60))
        view.backgroundColor = UIColor.white
        view.addSubview(normalBtn)
        view.addSubview(otherBtn)
        return view
    }()
    
    lazy var normalBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        Tools.setViewShadow(btn)
        btn.setTitle(LanguageHelper.getString(key: "quotes_normal"), for: .normal)
        btn.isSelected = true
        btn.frame = CGRect(x: 0, y: 15, width: HomeConversionListUX.chooseWidth/3 - 3, height: HomeConversionListUX.chooseHeight)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = R_UIThemeSkyBlueColor
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tag = 1
        return btn
    }()
    
    lazy var otherBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        Tools.setViewShadow(btn)
        btn.setTitle(LanguageHelper.getString(key: "quotes_other"), for: .normal)
        btn.frame = CGRect(x: HomeConversionListUX.chooseWidth/3 +  5, y: 15, width: HomeConversionListUX.chooseWidth/3 - 3, height: HomeConversionListUX.chooseHeight)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tag = 2
        return btn
    }()
    
}
