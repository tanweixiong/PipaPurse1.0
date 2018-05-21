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
        let view = UIView(frame: CGRect(x: 15, y:115, width: QuotesUX.chooseWidth, height: 60))
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
        btn.frame = CGRect(x: 0, y: 15, width: QuotesUX.chooseWidth/3 - 3, height: QuotesUX.chooseHeight)
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
        btn.frame = CGRect(x: QuotesUX.chooseWidth/3 +  5, y: 15, width: QuotesUX.chooseWidth/3 - 3, height: QuotesUX.chooseHeight)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.tag = 2
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: chooseView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - chooseView.frame.maxY - 44))
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
            self.getData()
        })
        return tableView
    }()
    
    lazy var searchBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "ic_quotes_search"), for: .normal)
        btn.setTitle("", for: .normal)
        btn.setTitle("取消", for: .selected)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 50, y: 70, width: 50, height:30)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.addTarget(self, action: #selector(searchOnClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.tag = 1
        return btn
    }()
    
    lazy var textView:UITextView = {
        let view = UITextView.init(frame: CGRect.init(x: 0, y: 0, width:0, height: 0))
//        view.placeholderText = "输入关键词搜索"
//        view.placeholderFont = UIFont.systemFont(ofSize: 14)
//        view.place = UIColor.R_UIColorFromRGB(color: 0x828A9E)
        view.textColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
        view.font = UIFont.systemFont(ofSize: 14)
        view.delegate = self
        view.frame = CGRect(x: 15, y: 67.5, width: SCREEN_WIDTH - searchBtn.width - 50, height: 35)
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 0.8)
        view.isHidden = true
        return view
    }()
    
    lazy var placeholderLab: UILabel = {
        let lab = UILabel(frame: CGRect(x: 20, y: 67.5, width: 100, height: textView.height))
        lab.textColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
        lab.text = LanguageHelper.getString(key: "quotes_search")
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.isUserInteractionEnabled = true
        lab.isHidden = true
        return lab
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
        view.addSubview(searchBtn)
        view.addSubview(textView)
        view.addSubview(placeholderLab)
    }
    
    func getData(){
        let userId = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["language":Tools.getLocalLanguage(),"userId":userId,"token":token!]
        viewModel.loadQuotesSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIOpenCoinList, parameters: parameters, showIndicator: false) {
            //处理数据类型 0 常规1 光子
            self.removeData()
            if self.viewModel.model.count != 0 {
                for index in 0...self.viewModel.model.count - 1{
                    let data = self.viewModel.model[index]
                    //常规专区
                    if data.coinBlock == 0 {
                        self.normalArray.add(data)
                    //光子专区
                    }else {
                        self.otherArray.add(data)
                    }
                    self.searchArray.add(data.coinName!)
                    self.dataScore.add(data)
                }
                if self.style == .normalStyle {
                    self.dataArray.addObjects(from: self.normalArray as! [Any])
                }else if self.style == .otherStyle{
                    self.dataArray.addObjects(from: self.otherArray as! [Any])
                }
            }
            self.tableView.reloadData()
        }
        self.tableView.mj_header.endRefreshing()
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
    
    @objc func searchOnClick(_ sender:UIButton){
        searchBtn.isSelected = !searchBtn.isSelected
        if sender.isSelected {
            textView.isHidden = false
            placeholderLab.isHidden = textView.text == "" ? false : true
            searchBtn.setImage(UIImage.init(named: ""), for: .normal)
            searchBtn.backgroundColor = UIColor.clear
            titleLabel.text = ""
        }else{
            textView.isHidden = true
            placeholderLab.isHidden = true
            searchBtn.setImage(UIImage.init(named: "ic_quotes_search"), for: .normal)
            searchBtn.backgroundColor = UIColor.white
            titleLabel.text = titleTex
            closeKeyboard()
        }
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
    
    func removeData(){
        self.dataArray.removeAllObjects()
        self.dataScore.removeAllObjects()
        self.searchArray.removeAllObjects()
        self.normalArray.removeAllObjects()
        self.otherArray.removeAllObjects()
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
        if model.coinNo == 40 || model.coinNo == 50 {
             return
        }
        let quotesDetailsVC = QuotesDetailsVC()
        quotesDetailsVC.model = model
        self.navigationController?.pushViewController(quotesDetailsVC, animated: true)
    }
}

extension QuotesVC:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if OCTools.isPositionTextViewDidChange(textView) {
            self.dataArray.removeAllObjects()
            let text = textView.text!
            let bigText = text.uppercased()
            var hasData = false
            for (index,value) in searchArray.enumerated() {
                let newValue = value as! String
                if  OCTools.hasString(newValue, otherStr: bigText) {
                    let data = dataScore[index] as! QuotesModel
                    self.dataArray.add(data)
                    hasData = true
                }
            }
            
            if hasData == false {
                self.dataArray.removeAllObjects()
            }
                self.tableView.reloadData()
            
            if text == "" {
                self.placeholderLab.isHidden = false
                self.setReload()
            }else{
                self.placeholderLab.isHidden = true
            }
        }
        if textView.text != "" {
            self.placeholderLab.isHidden = true
        }
    }
}

