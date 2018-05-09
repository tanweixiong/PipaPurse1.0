//
//  FriendsViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/21.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var tableView: UITableView!
    
    var friendArray: NSMutableArray = NSMutableArray()
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
        getFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - EventResponse Method
    @objc func refreshHeader() {
        getFriends()
    }
    
    @objc func refreshFooter() {
        getFriends()
    }
    
    // MARK: - NetWork Method
    func getFriends() {
        
        let token = SingleTon.shared.userInfo?.token!
        let params = [ "token" : token!]
        SVProgressHUD.show(with: .black)
        ZYNetWorkTool.requestData(.get, URLString: ZYConstAPI.kAPIGetTradeFriends, language: false, parameters: params, showIndicator: true, success: { (jsonObjc) in
            self.tableView.mj_header.endRefreshing()
            let result = Mapper<FriendsRespondse>().map(JSONObject: jsonObjc)
            if let code = result?.code {
                SVProgressHUD.dismiss()
                if code == 200 {
                    self.friendArray.removeAllObjects()
                    self.friendArray.addObjects(from: (result?.data)!)
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: result?.message)
                }
            } else {
                SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            SVProgressHUD.showError(withStatus: LanguageHelper.getString(key: "net_networkerror"))
        }
        
    }
    
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: nil, options: nil)?[0] as! FriendTableViewCell
        cell.friend = friendArray[indexPath.row] as! Friend
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
   
    // MARK: - Private Method
    func setViewStyle() {
        
        topView.setViewContent(title: LanguageHelper.getString(key: "person_friend"))
        topView.setButtonCallBack { (sender) in
        self.navigationController?.popViewController(animated: true)
        }
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(FriendsViewController.refreshHeader))
    }

}
