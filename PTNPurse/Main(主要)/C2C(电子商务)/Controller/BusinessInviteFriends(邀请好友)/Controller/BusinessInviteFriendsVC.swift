//
//  BusinessInviteFriends.swift
//  PTNPurse
//
//  Created by tam on 2018/4/8.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class BusinessInviteFriendsVC: UIViewController {
    fileprivate let businessInviteFriendsCell = "BusinessInviteFriendsCell"
    fileprivate lazy var viewModel : BusinessInviteFriendsVM = BusinessInviteFriendsVM()
    fileprivate var pageSize:Int = 0
    fileprivate var lineSize:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        getData()
        getListData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: inviteFriendsVw.tableBackGroundVw.width, height: inviteFriendsVw.tableBackGroundVw.height + 20))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessInviteFriendsCell", bundle: nil),forCellReuseIdentifier: self.businessInviteFriendsCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var inviteFriendsVw: BusinessInviteFriendsVw = {
        let view = Bundle.main.loadNibNamed("BusinessInviteFriendsVw", owner: nil, options: nil)?.last as! BusinessInviteFriendsVw
        view.frame = CGRect(x: 0, y: -20 , width: SCREEN_WIDTH, height:SCREEN_HEIGHT + 20)
        view.shareBtn.backgroundColor = R_UIThemeSkyBlueColor
        view.shareBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.shareBtn.tag = 1
        view.backBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.backBtn.tag = 2
        return view
    }()
    
    lazy var codeView: HomeCodeView = {
        let view = Bundle.main.loadNibNamed("HomeCodeView", owner: nil, options: nil)?.last as! HomeCodeView
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.isHidden = true
        return view
    }()
    
    override func loadViewIfNeeded() {
         inviteFriendsVw.tableBackGroundVw.addSubview(tableView)
    }
}

extension BusinessInviteFriendsVC {
    func setupUI(){
        view.addSubview(inviteFriendsVw)
    }
    
    func getListData(){
        let userNo = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let token = (UserDefaults.standard.getUserInfo().token)!
        let pageSize = "\(self.pageSize)"
        let lineSize = "\(self.lineSize)"
        let parameters = ["userNo":userNo,"token":token,"pageSize":pageSize,"lineSize":lineSize]
        viewModel.loadListSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetUserByInvitation, parameters: parameters, showIndicator: false) {
            self.tableView.reloadData()
        }
    }
    
    @objc func onClick(_ sender:UIButton){
        if sender.tag == 1 {
            if self.viewModel.inviteModel.url != nil {
                let model = self.viewModel.inviteModel
                let invitationCode = model.invitationCode == nil ? "" : (model.invitationCode)!
                let url = model.url == nil ? "" : (model.url)! + invitationCode
                self.codeView.codeImageView.image = Tools.createQRForString(qrString: url, qrImageName: "")
                self.codeView.isHidden = false
            }
        }else if sender.tag == 2 {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension BusinessInviteFriendsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.inviteModel.bonusDetails?.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessInviteFriendsCell, for: indexPath) as! BusinessInviteFriendsCell
        cell.selectionStyle = .none
        cell.model = viewModel.inviteModel.bonusDetails?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


