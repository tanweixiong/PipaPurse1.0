//
//  FileListViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/29.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

protocol FileListViewControllerDelegate {
    func didSelectFile(filename: String) -> Void
}

class FileListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var tableView: UITableView!
    
    var fileListArray: NSMutableArray = NSMutableArray()
    
    var delegate: FileListViewControllerDelegate?
    
    // MARK: - life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
        getFileList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - NetWork Method
    func getFriends() {
        
    }
    
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return fileListArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        let filename = fileListArray[indexPath.section] as! String
        cell.textLabel?.text = filename
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if view.isKind(of: UITableViewHeaderFooterView.self) {
            let footerview = view as! UITableViewHeaderFooterView
            footerview.contentView.backgroundColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let filename = fileListArray[indexPath.section] as! String
        let contentstr = Tools.getJsonFileContentInDocuments(fileName: filename)
        SingleTon.shared.fileName = filename
        
        if self.delegate != nil {
            self.delegate?.didSelectFile(filename: filename)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        topView.setViewContent(title: LanguageHelper.getString(key: "login_selectfile"))
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
         tableView.tableFooterView = UIView()
    }
    
    func getFileList() {
        
        fileListArray = Tools.getJsonFileArrayInDocuments()
        tableView.reloadData()
    }
    
    
    
    

}
