//
//  BusinessVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessVC: MainViewController{
    fileprivate let businessCell = "BusinessCell"
    fileprivate lazy var viewModel : BusinessVM = BusinessVM()
    fileprivate var style = BusinessTransactionStyle.buyStyle
    fileprivate var coinNo = Tools.getBtcCoinNum()
    fileprivate let coinArray = NSMutableArray()
    fileprivate var buyPageSize = 0
    fileprivate var sellPageSize = 0
    fileprivate var lineSize = 0
    struct BusinessUX {
        static let chooseViewHeight:CGFloat = 45
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
        getCoin()
        BusinessVC.setPaymentData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: R_NotificationC2CReload), object: nil)
    }
    
    lazy var liberateBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_home_Issue"), for: .normal)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 32, y: 32, width: 50, height:22)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.clipsToBounds = true
        btn.tag = 1
        btn.titleLabel?.textAlignment = .right
        return btn
    }()
    
    lazy var selectCoinBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("LCT",for: .normal)
        btn.setImage(UIImage.init(named: "ic_meun"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        btn.frame = CGRect(x: 15, y: 32, width: 70, height:22)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.clipsToBounds = true
        btn.tag = 1
        return btn
    }()
    
    lazy var businessMeunVw: BusinessMeunVw = {
        let view = Bundle.main.loadNibNamed("BusinessMeunVw", owner: nil, options: nil)?.last as! BusinessMeunVw
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT )
        view.isHidden = true
        return view
    }()
    
    lazy var businessView: BusinessView = {
        let view = Bundle.main.loadNibNamed("BusinessView", owner: nil, options: nil)?.last as! BusinessView
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight , width: SCREEN_WIDTH, height: BusinessUX.chooseViewHeight)
        view.buyBtn.isSelected = true
        view.sellBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
        view.sellBtn.setTitleColor(UIColor.white, for: .selected)
        view.buyBtn.backgroundColor = R_UIThemeSkyBlueColor
        view.buyBtn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
        view.buyBtn.setTitleColor(UIColor.white, for: .selected)
        view.sellBtn.addTarget(self, action: #selector(sellAndBuyOnClick(_:)), for:.touchUpInside)
        view.buyBtn.addTarget(self, action: #selector(sellAndBuyOnClick(_:)), for:.touchUpInside)
        view.buyBtn.layer.cornerRadius = 5
        view.buyBtn.layer.masksToBounds = true
        view.sellBtn.layer.cornerRadius = 5
        view.sellBtn.layer.masksToBounds = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y:businessView.frame.maxY , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - businessView.frame.maxY - 50))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessCell", bundle: nil),forCellReuseIdentifier: self.businessCell)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.cleanData()
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationC2CReload), object: nil)
    }
    
   class func setPaymentData(){
        let userInfo = UserDefaults.standard.getUserInfo()
        userInfo.apay = userInfo.apay == nil && userInfo.apay == "" ? "" : userInfo.apay
        userInfo.weChat = userInfo.weChat == nil && userInfo.weChat == "" ? "" : userInfo.weChat
        UserDefaults.standard.saveCustomObject(customObject: userInfo, key: R_UserInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BusinessVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if style == .buyStyle {
            return viewModel.buyModel.count
        }
        return viewModel.sellModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessCell, for: indexPath) as! BusinessCell
        cell.selectionStyle = .none
        if style == .buyStyle {
            if viewModel.buyModel.count != 0 {
                cell.model = viewModel.buyModel[indexPath.row]
            }
        }else{
            if viewModel.sellModel.count != 0 {
                cell.model = viewModel.sellModel[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = BusinessModel()
        if style == .buyStyle {
            if viewModel.buyModel.count == 0 {return}
            model = viewModel.buyModel[indexPath.row]
        }else{
            if viewModel.sellModel.count == 0 {return}
            model = viewModel.sellModel[indexPath.row]
        }
        let businessWantBuyVC = BusinessWantBuyVC()
        businessWantBuyVC.style = self.style
        businessWantBuyVC.entrustNo = (model?.entrustNo)!
        businessWantBuyVC.receivablesType = (model?.receivablesType?.stringValue)!
        businessWantBuyVC.businessWantBuyData = BusinessWantBuyData(avatarUrl: model?.photo, entrustPrice: model?.entrustPrice, entrustMaxPrice: model?.entrustMaxPrice, entrustMinPrice: model?.entrustMinPrice, remark: model?.remark, name: model?.username, coinCore: model?.coinCore)
        businessWantBuyVC.detailsModel = model
        self.navigationController?.pushViewController(businessWantBuyVC, animated: true)
    }
}

extension BusinessVC {
    func setupUI(){
        setNormalNaviBar(title: "C2C")
        setHideBackBtn()
        view.addSubview(businessView)
        view.addSubview(tableView)
        view.addSubview(liberateBtn)
        view.addSubview(selectCoinBtn)
        UIApplication.shared.keyWindow?.addSubview(liberateView)
//        UIApplication.shared.keyWindow?.addSubview(businessMeunVw)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func onClick(_ sender:UIButton){
        if sender == liberateBtn {
            if liberateView.isHidden{
                liberateView.isHidden = false
                UIView.animate(withDuration: 1, animations: {
                    self.liberateView.liberateViewY.constant = 0
                }, completion: { (finish) in
                })
            }
        }else if sender == selectCoinBtn {
            if businessMeunVw.isHidden{
                businessMeunVw.isHidden = false
                UIView.animate(withDuration: 1, animations: {
//                    self.liberateView.liberateViewY.constant = 0
                }, completion: { (finish) in
                })
            }
        }
    }
    
    //发布购买和发布出售
    @objc func distributeOnClick(_ sender:UIButton){
        if sender.tag == 1 {
            let businessSellVC = BusinessTransactionVC()
            businessSellVC.style = .sellStyle
            self.navigationController?.pushViewController(businessSellVC, animated: true)
            self.liberateView.isHidden = true
        }else if sender.tag == 2{
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
    
    //切换已上架和进行中
    @objc func sellAndBuyOnClick(_ sender:UIButton){
        //出售
        if sender == businessView.sellBtn  {
            style = .sellStyle
            businessView.sellBtn.isSelected = true
            businessView.sellBtn.backgroundColor = R_UIThemeSkyBlueColor
            businessView.buyBtn.isSelected = false
            businessView.buyBtn.backgroundColor = UIColor.white
        //购买
        }else{
            style = .buyStyle
            businessView.sellBtn.isSelected = false
            businessView.sellBtn.backgroundColor = UIColor.white
            businessView.buyBtn.isSelected = true
            businessView.buyBtn.backgroundColor = R_UIThemeSkyBlueColor
        }
        getData()
        self.tableView.reloadData()
    }
    
    //网络请求买方
    @objc func getData(){
        let coinNo = self.coinNo
        let entrustType = style == .buyStyle ? "1" : "0" //1：买的广告，0：卖的广告
        let pageSize = style == .buyStyle ? self.buyPageSize : self.sellPageSize
        let lineSize  = self.lineSize
        let parameters = ["coinNo":coinNo,"entrustType":entrustType,"pageSize":"\(pageSize)","lineSize":lineSize] as [String : Any]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetSpotEntrust, parameters: parameters,style:style, showIndicator: false) {
            self.tableView.reloadData()
        }
        tableView.mj_header.endRefreshing()
    }
    
    //获取币种
    func getCoin(){
        let parameters = ["state":"3","type":"3"]
        viewModel.loadCoinSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetCoin, parameters: parameters, showIndicator: false) {
            for item in 0...self.viewModel.coinModel.count {
                if item != self.viewModel.coinModel.count {
                    let model = self.viewModel.coinModel[item]
                    self.coinArray.add(model.coinName!)
                }
            }
        }}
    
    @objc func reloadData(){
        cleanData()
        getData()
    }
    
    func cleanData(){
        self.buyPageSize = 0
        self.sellPageSize = 0
        self.viewModel.sellModel.removeAll()
        self.viewModel.buyModel.removeAll()
    }
}

extension BusinessVC:PST_MenuViewDelegate{
    func didSelectRow(at index: Int, title: String!, img: String!) {
        let model = self.viewModel.coinModel[index]
        self.coinNo = (model.id?.stringValue)!
        self.selectCoinBtn.setTitle(model.coinName, for: .normal)
        cleanData()
        getData()
    }
}
