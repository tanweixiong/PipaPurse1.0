//
//  BusinessMeunVw.swift
//  PTNPurse
//
//  Created by tam on 2018/5/11.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

protocol BusinessMeunDelegate {
    func businessMeunSelectFinish(indexPath:IndexPath,text:String)
}
class BusinessMeunVw: UIView {
    @IBOutlet weak var selectMeunLab: UILabel!
    @IBOutlet weak var currentSelectLab: UILabel!
    fileprivate let businessMeunCell = "BusinessMeunCell"
    var delegate:BusinessMeunDelegate?
    var indexPath = IndexPath()
    var dataArray = NSMutableArray(){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(tableView)
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        self.isHidden = true
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: selectMeunLab.frame.maxY, width: 250, height: SCREEN_HEIGHT - selectMeunLab.frame.maxY))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessMeunCell", bundle: nil),forCellReuseIdentifier: self.businessMeunCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.R_UIColorFromRGB(color: 0xE8E8E8)
        return tableView
    }()
    
}

extension BusinessMeunVw:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessMeunCell, for: indexPath) as! BusinessMeunCell
        cell.selectionStyle = .none
        cell.titleLab.text = dataArray[indexPath.row] as? String
        if self.indexPath.count != 0 {
            cell.selectBtn.isHidden = indexPath == self.indexPath ? false : true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! BusinessMeunCell
        currentCell.titleLab.textColor = UIColor.R_UIColorFromRGB(color: 0x009BFD)
        currentCell.selectBtn.isHidden = false
        if indexPath.count != 0 {
            let currentCell = tableView.cellForRow(at: self.indexPath) as! BusinessMeunCell
            currentCell.titleLab.textColor = UIColor.R_UIColorFromRGB(color: 0x747E8B)
            currentCell.selectBtn.isHidden = true
        }
        self.indexPath = indexPath
        self.delegate?.businessMeunSelectFinish(indexPath: indexPath, text: dataArray[indexPath.row] as! String)
        self.isHidden = true
    }
}

