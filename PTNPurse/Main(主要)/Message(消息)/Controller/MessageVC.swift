//
//  MessageVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/27.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MessageVC: MainViewController {
    fileprivate let messageCell = "MessageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var messageInformationVw: MessageInformationVw = {
        let view = Bundle.main.loadNibNamed("MessageInformationVw", owner: nil, options: nil)?.last as! MessageInformationVw
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: 95)
        Tools.setViewShadow(view)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: messageInformationVw.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - messageInformationVw.frame.maxY))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil),forCellReuseIdentifier: self.messageCell)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var deleteButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(self, action: #selector(deleteOnClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    //添加好友
    lazy var addFriendBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("", for: .normal)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 30, y: 70, width: 30, height:30)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.tag = 1
        return btn
    }()
    
    //通讯录
    lazy var contactsBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("", for: .normal)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 30 - 30 - 10, y: 70, width: 30, height:30)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x545B71), for: .normal)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.tag = 2
        return btn
    }()
}

extension MessageVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath) as! MessageCell
        cell.selectionStyle = .none
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let top = UITableViewRowAction(style: .normal, title: "置顶") {
            action, index in
        }
        top.backgroundColor = UIColor.white
        return [top]
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
         configIOS11ForCustomCellButton()
    }
    
}

extension MessageVC {
    func setupUI(){
        setNormalNaviBar(title: "消息")
        view.addSubview(messageInformationVw)
        view.addSubview(tableView)
    }
    
    func configIOS11ForCustomCellButton(){
        if #available(iOS 11.0, *) {
            for subview in self.tableView.subviews{
                print(self.tableView.subviews)
                if subview.isKind(of: NSClassFromString("UISwipeActionPullView")!){
                   self.createCustomCellButton(cellView: subview)
                }
            }
        }
    }
    
    func createCustomCellButton(cellView:UIView){
        cellView.layer.cornerRadius = 5
        cellView.layer.masksToBounds = true
        for btn in cellView.subviews {
            if btn.isKind(of:NSClassFromString("UISwipeActionStandardButton")!){
                for view in btn.subviews {
                    if view.isKind(of: UIView.classForCoder()){
                        let contentVw = UIView()
                        contentVw.frame = CGRect(x: 0, y: 0, width: XMAKE(55), height:80)
                        contentVw.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xFF4757)
                        contentVw.layer.cornerRadius = 5
                        contentVw.layer.masksToBounds = true
                        view.addSubview(contentVw)
                        
                        let btn = UIButton(type: .custom)
                        btn.setTitle("删除", for: .normal)
                        btn.setTitleColor(UIColor.white, for: .normal)
                        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                        btn.frame = contentVw.bounds
                        view.addSubview(btn)
                    }
                }
            }
        }
    }
    
    @objc func deleteOnClick(_ sender:UIButton){
        
    }
    
    @objc func onClick(_ sender:UIButton){
        
    }
    
}

