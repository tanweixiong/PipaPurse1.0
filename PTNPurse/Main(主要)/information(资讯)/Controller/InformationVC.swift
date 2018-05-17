//
//  informationVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

enum InformationStyle {
    case announcement
    case news
}

class InformationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var  announcementArr = NSMutableArray()
    fileprivate var newsArr = NSMutableArray()
    
    var style = InformationStyle.announcement
    
    var announcementPageNumber: Int = 1
    var newsPageNumber: Int = 1
    var lineSize: Int = 5
    var hasNextPage: Bool = true
    var isFirst = true
    
    var infoArray: NSMutableArray = NSMutableArray()
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(announcementBtn)
        view.addSubview(newsBtn)
        
        getNews(removeData: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewStyle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - NetWork Method
    func getNews(removeData: Bool) {
        let token = (UserDefaults.standard.getUserInfo().token)!
        let type = style == .announcement ? "1" : "2"
        let pageSize = style == .announcement ? "\(announcementPageNumber)" : "\(newsPageNumber)"
        let params = [ "pageSize" : pageSize, "lineSize":lineSize, "token" : token,"type":type] as [String : Any]
        if isFirst {
           SVProgressHUD.show(with: .black)
           isFirst = false
        }
        ZYNetWorkTool.requestData(.get, URLString: ZYConstAPI.kAPIGetNews, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            let result = Mapper<InfoRespondse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    self.infoArray.removeAllObjects()
                    let arr = NSMutableArray()
                    if self.style == .announcement {
                        arr.addObjects(from: self.announcementArr as! [Any])
                        arr.addObjects(from: (result?.data)!)
                        self.announcementArr = arr
                        self.infoArray.addObjects(from: arr as! [Any])
                        self.announcementPageNumber = self.hasNextPage ? self.announcementPageNumber + 1 : self.announcementPageNumber
                    }else{
                        arr.addObjects(from: self.newsArr as! [Any])
                        arr.addObjects(from: (result?.data)!)
                        self.newsArr = arr
                        self.infoArray.addObjects(from: arr as! [Any])
                        self.newsPageNumber = self.hasNextPage ? self.newsPageNumber + 1 : self.newsPageNumber
                    }

                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                } else {
                    SVProgressHUD.showError(withStatus: result?.message)
                }
            } else {
                SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
    }
    
    @objc func onClick(_ sender:UIButton){
        //公告
        if sender == announcementBtn {
            style = .announcement
            announcementBtn.isSelected = true
            newsBtn.isSelected = false
            announcementBtn.backgroundColor = R_UIThemeSkyBlueColor
            newsBtn.backgroundColor = UIColor.clear
        //新闻
        }else if sender == newsBtn {
            style = .news
            announcementBtn.isSelected = false
            newsBtn.isSelected = true
            announcementBtn.backgroundColor = UIColor.clear
            newsBtn.backgroundColor = R_UIThemeSkyBlueColor
        }
        hasNextPage = false
        getNews(removeData: false)
    }
    
    lazy var announcementBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "Information_Announcement"), for: .normal)
        btn.isSelected = true
        btn.frame = CGRect(x: 15, y: topView.frame.maxY + 10, width: 80, height: 35)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD) , for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = R_UIThemeSkyBlueColor
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var newsBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "Information_News"), for: .normal)
        btn.frame = CGRect(x:announcementBtn.frame.maxX + 10, y: announcementBtn.frame.origin.y, width: 80, height:35)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD) , for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        return btn
    }()
    
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("InfoTableViewCell", owner: nil, options: nil)?[0] as! InfoTableViewCell
        cell.info = infoArray[indexPath.row] as? InformationData
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailvc = NewsDetailViewController()
        detailvc.news = (infoArray[indexPath.row] as! InformationData)
        self.navigationController?.pushViewController(detailvc, animated: true)
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        topView.setViewContent(title: LanguageHelper.getString(key: "news_news"))
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        topView.backBtn.isHidden = true
        
        self.tableView.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(InformationVC.refreshHeader))
        self.tableView.mj_footer = MJRefreshBackFooter.init(refreshingTarget: self, refreshingAction: #selector(InformationVC.refreshFooter))

    }
    
    @objc func refreshHeader() {
        if self.style == .announcement{
            self.announcementPageNumber = 1
            self.announcementArr.removeAllObjects()
        }else if self.style == .news {
            self.newsPageNumber = 1
            self.newsArr.removeAllObjects()
        }
        hasNextPage = true
        getNews(removeData: true)
    }
    
    @objc func refreshFooter() {
    
        if hasNextPage {
            hasNextPage = true
            getNews(removeData: false)
        } else {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "net_nomoredata"))
            self.tableView.mj_footer.endRefreshing()
        }
    }

}
