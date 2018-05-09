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

class InformationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var tableView: UITableView!
    
    var pageNumber: Int = 1
    var pageSize: Int = 5
    var hasNextPage: Bool = true
    
    var infoArray: NSMutableArray = NSMutableArray()
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let token = SingleTon.shared.userInfo?.token!
        let params = [ "pageNum" : pageNumber, "pageSize":pageSize, "token" : token!] as [String : Any]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.get, URLString: ZYConstAPI.kAPIGetNews, language: true, parameters: params, showIndicator: true, success: { (jsonObjc) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            let result = Mapper<InfoRespondse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                if code == 200 {
                    if removeData {
                        self.infoArray.removeAllObjects()
                    }
                    self.infoArray.addObjects(from: (result?.data?.pageInfo?.list)!)
                    self.hasNextPage = (result?.data?.pageInfo?.hasNextPage)!
                    self.tableView.reloadData()
    
                    if self.hasNextPage {
                        self.pageNumber += 1
                    }
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
    
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("InfoTableViewCell", owner: nil, options: nil)?[0] as! InfoTableViewCell
        cell.info = infoArray[indexPath.row] as? Information
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailvc = NewsDetailViewController()
        detailvc.news = (infoArray[indexPath.row] as! Information)
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
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(InformationVC.refreshHeader))
        self.tableView.mj_footer = MJRefreshBackFooter.init(refreshingTarget: self, refreshingAction: #selector(InformationVC.refreshFooter))

    }
    
    @objc func refreshHeader() {
        pageNumber = 1
        hasNextPage = true
        getNews(removeData: true)
    }
    
    @objc func refreshFooter() {
    
        if hasNextPage {
            getNews(removeData: false)
        } else {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "net_nomoredata"))
            self.tableView.mj_footer.endRefreshing()
        }
    }

}
