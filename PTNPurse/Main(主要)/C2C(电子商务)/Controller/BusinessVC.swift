//
//  BusinessVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class BusinessVC: MainViewController,Calculatable{
    fileprivate let businessCell = "BusinessCell"
    fileprivate lazy var viewModel : BusinessVM = BusinessVM()
    fileprivate var style = BusinessTransactionStyle.buyStyle
    fileprivate var coinNo = Tools.getBtcCoinNum()
    fileprivate var currentTag = NSInteger()
    fileprivate let coinArray = NSMutableArray()
    fileprivate var buyPageSize = 0
    fileprivate var sellPageSize = 0
    fileprivate var lineSize = 0
    fileprivate let satrtPageSize = 0
    fileprivate let normalColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
    struct BusinessUX {
        static let chooseViewHeight:CGFloat = 45
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCoin()
        BusinessVC.setPaymentData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: R_NotificationC2CReload), object: nil)
    }
    
    lazy var liberateBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_home_Issue"), for: .normal)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 50 , y: 32, width: 50, height:22)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.clipsToBounds = true
        btn.tag = 1
        btn.titleLabel?.textAlignment = .right
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: scrollView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - scrollView.frame.maxY))
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
    
    lazy var buyBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_home_I_want_buy"), for: .normal)
        btn.isSelected = true
        btn.frame = CGRect(x: XMAKE(100) , y: 32, width: 70, height: 22)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD) , for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(distributeOnClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.tag = 3
        return btn
    }()
    
    lazy var sellBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_home_I_want_sell"), for: .normal)
        btn.frame = CGRect(x: (SCREEN_WIDTH - 70) - XMAKE(100), y: buyBtn.frame.origin.y, width: 70, height:22)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD) , for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(distributeOnClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.tag = 4
        return btn
    }()
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width:SCREEN_WIDTH, height: 20 + 35)
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.clipsToBounds = false;
        scrollView.bounces = false;
        return scrollView
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
        cell.style = self.style
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
        businessWantBuyVC.entrustNo = (model?.id?.stringValue)!
        businessWantBuyVC.orderNumber = (model?.entrustNo)!
        businessWantBuyVC.receivablesType = (model?.receivablesType?.stringValue)!
        businessWantBuyVC.businessWantBuyData = BusinessWantBuyData(avatarUrl: model?.photo, entrustPrice: model?.entrustPrice, entrustMaxPrice: model?.entrustMaxPrice, entrustMinPrice: model?.entrustMinPrice, remark: model?.remark, name: model?.username, coinCore: model?.coinCore)
        businessWantBuyVC.detailsModel = model
        self.navigationController?.pushViewController(businessWantBuyVC, animated: true)
    }
}

extension BusinessVC {
    func setupUI(){
        setNormalNaviBar(title: "")
        setHideBackBtn()
        view.addSubview(buyBtn)
        view.addSubview(sellBtn)
        view.addSubview(scrollView)
        view.addSubview(tableView)
        view.addSubview(liberateBtn)
        UIApplication.shared.keyWindow?.addSubview(liberateView)
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
        }
    }
    
    @objc func chooseCoinOnClick(_ sender:UIButton){
        let currentBtn = scrollView.viewWithTag(sender.tag) as! UIButton
        currentBtn.backgroundColor = R_UIThemeColor
        currentBtn.isSelected = true
        
        let lastBtn = scrollView.viewWithTag(currentTag == 0 ? 1 : currentTag) as! UIButton
        lastBtn.backgroundColor = UIColor.clear
        lastBtn.isSelected = false
        
        let model = viewModel.coinModel[sender.tag - 1]
        coinNo = (model.id?.stringValue)!
        currentTag = sender.tag
        buyPageSize = self.satrtPageSize
        sellPageSize = self.satrtPageSize
        getData()
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
            buyBtn.isSelected = true
            sellBtn.isSelected = false
            style = .buyStyle
            getData()
        }else if sender.tag == 4 {
            buyBtn.isSelected = false
            sellBtn.isSelected = true
            style = .sellStyle
            getData()
        }
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
        let parameters = ["state":"1","type":"3"]
        SVProgressHUD.show(withStatus: LanguageHelper.getString(key: "please_wait"))
        viewModel.loadCoinSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetCoin, parameters: parameters, showIndicator: false) {
            SVProgressHUD.dismiss()
            for item in 0...self.viewModel.coinModel.count {
                if item != self.viewModel.coinModel.count {
                    let model = self.viewModel.coinModel[item]
                    self.coinArray.add(model.coinName!)
                }
            }
            //创建上部分的按钮
            self.createScrollView()
            //设置参数
            if self.viewModel.coinModel.count != 0 {
                let model = self.viewModel.coinModel.first
                self.coinNo = (model?.id?.stringValue)!
                self.getData()
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
    
    //创建上部分的导航
    func createScrollView(){
        if  self.coinArray.count != 0 {
            let space:CGFloat = 10
            let startSpace:CGFloat = 15
            var currentX:CGFloat = 0
            var maxX:CGFloat = 0
            
            for item in 0...self.coinArray.count - 1 {
                let coin = self.coinArray[item] as! String
                let btn = UIButton.init(type: .custom)
                btn.setTitle(coin, for: .normal)
                btn.setTitleColor(UIColor.white , for: .selected)
                btn.setTitleColor(normalColor , for: .normal)
                btn.isSelected = item == 0 ? true : false
                btn.addTarget(self, action: #selector(chooseCoinOnClick(_:)), for: .touchUpInside)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.layer.cornerRadius = 5
                btn.layer.masksToBounds = true
                btn.tag = item + 1
                btn.backgroundColor = item == 0 ? R_UIThemeColor : UIColor.clear
                scrollView.addSubview(btn)
                
                //计算位置
                let width = Tools.textWidth(text: coin, fontSize: 14, height: 35) + 20
                if item == 0 {
                     btn.frame = CGRect(x:startSpace, y: 10, width: width, height:35)
                }else{
                    let lastBtn = scrollView.viewWithTag(item) as! UIButton
                    currentX =  space + lastBtn.frame.maxX
                    btn.frame = CGRect(x:currentX, y: 10, width: width, height:35)
                    //获取最右边的值
                    maxX = item == coinArray.count - 1 ? btn.frame.maxX : 0
                }
            }
            scrollView.contentSize = CGSize(width: maxX, height: 0)
        }
    }
}

