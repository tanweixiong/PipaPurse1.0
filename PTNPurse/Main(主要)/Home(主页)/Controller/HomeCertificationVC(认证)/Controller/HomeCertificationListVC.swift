//
//  HomeCertificationListVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/7.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

protocol DocumentName {
    var documentName :String {get}
}

protocol HomeCertificationListDelegate:DocumentName {
    func certificationSelectDocument(name:String)
}

class HomeCertificationListVC: MainViewController{
    fileprivate var fileArray = NSMutableArray()
    var delegate:HomeCertificationListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.ym_registerCell(cell: HomeCertificationListCell.self)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        return tableView
    }()

}

extension HomeCertificationListVC {
    func setupUI(){
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: LanguageHelper.getString(key: "perseon_File_List"))
        self.fileArray  = Tools.getFileInDocuments()
        view.addSubview(tableView)
    }
}

extension HomeCertificationListVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  fileArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ym_dequeueReusableCell(indexPath: indexPath) as HomeCertificationListCell
        cell.headingLabel.text = self.fileArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = fileArray[indexPath.row] as! String
        self.delegate?.certificationSelectDocument(name: name)
        self.navigationController?.popViewController(animated: true)
    }
    
}

