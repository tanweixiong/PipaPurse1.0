//
//  BusinessMeunVw.swift
//  PTNPurse
//
//  Created by tam on 2018/5/11.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessMeunVw: UIView {
    @IBOutlet weak var selectMeunLab: UILabel!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var indexPath = IndexPath()
    var dataArray = NSMutableArray(){
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        self.isHidden = true
    }
    
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("BusinessMeunCell", owner: nil, options: nil)?[0] as! BusinessMeunCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
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
    }
    
}
