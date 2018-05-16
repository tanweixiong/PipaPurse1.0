//
//  IntegralApplicationStatusVw.swift
//  BCPPurse
//
//  Created by tam on 2018/4/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

protocol IntegralApplicationStatusDelegate{
    func integralApplicationStatusSelectRow(index:NSInteger,name:String,selectList:NSInteger)
}

class IntegralApplicationStatusVw: UIView {
    fileprivate let integralApplicationStatusCell = "IntegralApplicationStatusCell"
    var selectFirstIndex = IndexPath()
    var selectSecondIndex = IndexPath()
    var selectList = NSInteger()
    var dataArray = NSMutableArray(){
        didSet{
            self.statusTw.reloadData()
        }
    }
    fileprivate var lastIndexPath = IndexPath(row: 0, section: 0)
    var delegare:IntegralApplicationStatusDelegate?
    @IBOutlet weak var titleVw: UIView!
    @IBOutlet weak var backGroundVw: UIView!
    @IBOutlet weak var statusVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusVw.addSubview(statusTw)
    }
    
    lazy var statusTw: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: titleVw.frame.maxY, width: SCREEN_WIDTH, height: 144))
        tableView.register(UINib(nibName: "IntegralApplicationStatusCell", bundle: nil),forCellReuseIdentifier: self.integralApplicationStatusCell)
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.R_UIColorFromRGB(color: 0x979797)
        return tableView
    }()
    
    @IBAction func onClick(_ sender: UIButton) {
        self.isHidden = true
    }
}

extension IntegralApplicationStatusVw:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: integralApplicationStatusCell, for: indexPath) as! IntegralApplicationStatusCell
        cell.selectionStyle = .none
        cell.headingLab.text = dataArray[indexPath.row] as? String
        cell.iconImgeVw.sd_setImage(with: NSURL(string: "")! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        cell.statusBtn.isSelected = indexPath == self.lastIndexPath ? true : false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titles = dataArray[indexPath.row]
        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! IntegralApplicationStatusCell
        cell.statusBtn.isSelected = true

        self.isHidden = true
        self.lastIndexPath = indexPath
        
        self.delegare?.integralApplicationStatusSelectRow(index: indexPath.row, name: (titles as? String)!, selectList: self.selectList)
        self.statusTw.reloadData()
    }
}
