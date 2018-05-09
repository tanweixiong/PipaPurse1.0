//
//  MineBackupVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit


class MineBackupVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate let mineBackupCell = "MineBackupCell"
    fileprivate let dataScore = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        self.view.addSubview(tableView)
    }
    
    func setData(){
//        Tools.storeJsonInDocuments(jsonDict: ["男朋友":"毛小孩","肥美":"高田"], fileName: "用户数据")
//        if Tools.getJsonFileArrayInDocuments().count != 0 {
//            let data = Tools.getJsonFileArrayInDocuments()
//            dataScore.addObjects(from: data as! [Any])
//        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataScore.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mineBackupCell, for: indexPath) as! MineBackupCell
        cell.selectionStyle = .none
        cell.headingContentLabel.text = dataScore[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MineBackupCell", bundle: nil),forCellReuseIdentifier: self.mineBackupCell)
        tableView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xEDEDED)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        return tableView
    }()
}
