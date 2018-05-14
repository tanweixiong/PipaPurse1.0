 //
//  BusinessBuyHistoryVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/13.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum BusinessBuyHistoryStatus{
     case processingStyle //进行中
     case dropOffStyle //已下架
}
enum BusinessTransactionStyle {
     case buyStyle //购买
     case sellStyle //出售
}

class BusinessBuyHistoryVC: MainViewController {
    fileprivate let businessBuyHistoryCell = "BusinessBuyHistoryCell"
    fileprivate lazy var viewModel : BusinessBuyHistoryVM = BusinessBuyHistoryVM()
    fileprivate lazy var coinViewModel : BusinessVM = BusinessVM()
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    fileprivate var style = BusinessBuyHistoryStatus.processingStyle
    fileprivate var coinNum = Tools.getBtcCoinNum()
    var transactionStyle = BusinessTransactionStyle.buyStyle
    fileprivate let coinArray = NSMutableArray()
    fileprivate var pageSize = 0
    fileprivate var lineSize = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
        getCoin()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: R_NotificationAdvertisingeReload), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var businessView: BusinessView = {
        let view = Bundle.main.loadNibNamed("BusinessView", owner: nil, options: nil)?.last as! BusinessView
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight , width: SCREEN_WIDTH, height: 45)
        view.sellBtn.setTitle(LanguageHelper.getString(key: "C2C_mine_advertisement_finish"), for: .normal)
        view.sellBtn.addTarget(self, action: #selector(sellAndBuyOnClick(_:)), for:.touchUpInside)
        view.sellBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        view.sellBtn.setTitleColor(UIColor.white, for: .selected)
        
        view.buyBtn.backgroundColor = R_UIThemeSkyBlueColor
        view.buyBtn.addTarget(self, action: #selector(sellAndBuyOnClick(_:)), for:.touchUpInside)
        view.buyBtn.setTitle(LanguageHelper.getString(key: "C2C_mine_advertisement_processing"), for: .normal)
        view.buyBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        view.buyBtn.setTitleColor(UIColor.white, for: .selected)
        view.buyBtn.isSelected = true
//        view.coinViewWidth.constant = 90
//        view.coinNameLab.text = "BTC"
//        view.chooseCoinBtn.addTarget(self, action: #selector(distributeOnClick(_:)), for: .touchUpInside)
//        view.chooseCoinBtn.tag = 3
        return view
    }()
    
    lazy var liberateBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_home_Issue"), for: .normal)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 50, y: 70, width: 50, height:30)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.addTarget(self, action: #selector(liberateOnClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.tag = 1
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: businessView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - businessView.frame.maxY))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessBuyHistoryCell", bundle: nil),forCellReuseIdentifier: self.businessBuyHistoryCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.viewModel.model.removeAll()
            self.getData()
        })
        return tableView
    }()
    
    lazy var liberateView: BusinessLiberateView = {
        let view = Bundle.main.loadNibNamed("BusinessLiberateView", owner: nil, options: nil)?.last as! BusinessLiberateView
        view.frame = CGRect(x: 0, y:0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.isHidden = true
        view.liberateBuyBtn.tag = 2
        view.liberateBuyBtn.addTarget(self, action: #selector(distributeOnClick(_:)), for: .touchUpInside)
        view.liberateSellBtn.tag = 1
        view.liberateSellBtn.addTarget(self, action: #selector(distributeOnClick(_:)), for: .touchUpInside)
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationAdvertisingeReload), object: nil)
    }
}

extension BusinessBuyHistoryVC {
    func setupUI(){
        let title = transactionStyle == .buyStyle ? LanguageHelper.getString(key: "C2C_mine_My_purchase_advertisement") : LanguageHelper.getString(key: "C2C_mine_My_sale_advertisement")
        setNormalNaviBar(title: title)
        view.addSubview(businessView)
        view.addSubview(tableView)
        view.addSubview(liberateBtn)
        UIApplication.shared.keyWindow?.addSubview(liberateView)
    }
    
    @objc func liberateOnClick(_ sender:UIButton){
        if liberateView.isHidden{
            liberateView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.liberateView.liberateViewY.constant = 0
            }, completion: { (finish) in
            })
        }
    }
    
    @objc func getData(){
        let token = UserDefaults.standard.getUserInfo().token!
        let coinNo = coinNum
        let entrustType = transactionStyle == .buyStyle ? "0" : "1"  //0：买，1：卖
        let entrustState = style == .processingStyle ? "0" : "1" //0：进行中，1：已全部
        let pageSize = self.pageSize
        let lineSize = self.lineSize
        let parameters = ["token":token,"coinNo":coinNo,"entrustType":entrustType,"entrustState":entrustState,"pageSize":pageSize,"lineSize":lineSize] as [String : Any]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetSpotEntrustByUserNo, parameters: parameters, showIndicator: false) {
            self.tableView.reloadData()
        }
        self.tableView.mj_header.endRefreshing()
    }
    
    //撤销广告
    func getRevokeAds(entrustNo:String,index:NSInteger){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let entrustNo = entrustNo
        let language = Tools.getLocalLanguage()
        let parameters = ["token":token,"entrustNo":entrustNo,"language":language]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIDelSpotEntrust, parameters: parameters, showIndicator: false) { (json) in
            self.viewModel.model.remove(at: index)
            self.tableView.reloadData()
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_mine_my_advertisement_Drop_finish"))
        }
    }
    
    //获取币种
    func getCoin(){
        let parameters = ["state":"3","type":"3"]
        coinViewModel.loadCoinSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetCoin, parameters: parameters, showIndicator: false) {
            for item in 0...self.coinViewModel.coinModel.count {
                if item != self.coinViewModel.coinModel.count {
                    let model = self.coinViewModel.coinModel[item]
                    self.coinArray.add(model.coinName!)
                }
            }
        }}
    
    //下架广告
    @objc func advertisingOnClick(_ sender:UIButton){
        let model = viewModel.model[sender.tag]
        getRevokeAds(entrustNo:model.entrustNo!,index:sender.tag)
    }

    //切换已上架和进行中
    @objc func sellAndBuyOnClick(_ sender:UIButton){
        //出售
        if sender == businessView.sellBtn  {
            style = .dropOffStyle
            businessView.sellBtn.isSelected = true
            businessView.sellBtn.backgroundColor = R_UIThemeSkyBlueColor
            businessView.buyBtn.isSelected = false
            businessView.buyBtn.backgroundColor = UIColor.white
        //购买
        }else{
            style = .processingStyle
            businessView.sellBtn.isSelected = false
            businessView.sellBtn.backgroundColor = UIColor.white
            businessView.buyBtn.isSelected = true
            businessView.buyBtn.backgroundColor = R_UIThemeSkyBlueColor
        }
        getData()
    }
    
    @objc func distributeOnClick(_ sender:UIButton){
        if sender.tag == 1 {
            let businessSellVC = BusinessTransactionVC()
            businessSellVC.style = .sellStyle
            self.navigationController?.pushViewController(businessSellVC, animated: true)
            self.liberateView.isHidden = true
        }else if sender.tag == 2 {
            let businessBuyVC = BusinessTransactionVC()
            businessBuyVC.style = .buyStyle
            self.navigationController?.pushViewController(businessBuyVC, animated: true)
            self.liberateView.isHidden = true
        }else if sender.tag == 3 {
            let coinArray = self.coinArray
            let list_height = coinArray.count * 40 + 15
            let menuView = PST_MenuView.init(frame: CGRect(x: Int(SCREEN_WIDTH - 120 - 15), y: Int(businessView.frame.maxY), width: 120, height: list_height), titleArr:coinArray as! [Any], imgArr: nil, arrowOffset: 100, rowHeight: 40, layoutType: PST_MenuViewLayoutType(rawValue: 1)!, directionType: PST_MenuViewDirectionType(rawValue: 0)!, delegate: self)
            menuView?.arrowColor = UIColor.white
            menuView?.titleColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        }
    }
}

extension BusinessBuyHistoryVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.model[indexPath.row]
        let state = model.state
        if state == 0 {
            return 245
        }
        return 205
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessBuyHistoryCell, for: indexPath) as! BusinessBuyHistoryCell
        cell.selectionStyle = .none
//        cell.model = viewModel.model[indexPath.row]
        cell.operatingBtn.tag = indexPath.row
        cell.operatingBtn.addTarget(self, action: #selector(advertisingOnClick(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = viewModel.model[indexPath.row]
//        let businessBuyHistoryDetailsVC = BusinessBuyHistoryDetailsVC()
//        businessBuyHistoryDetailsVC.entrustNo = (model.id?.stringValue)!
//        businessBuyHistoryDetailsVC.style = self.style
//        self.navigationController?.pushViewController(businessBuyHistoryDetailsVC, animated: true)
    }
}
 
 extension BusinessBuyHistoryVC:PST_MenuViewDelegate{
    func didSelectRow(at index: Int, title: String!, img: String!) {
        let model = self.coinViewModel.coinModel[index]
        coinNum = (model.id?.stringValue)!
//        businessView.coinNameLab.text = model.coinName!
        getData()
    }
 }
 

