//
//  BusinessSubmissionMessageVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessSubmissionMessageVC: MainViewController {
    fileprivate let businessSubmissionMessageCell = "BusinessSubmissionMessageCell"
    fileprivate var pageNum = 1
    fileprivate var pageSize = 4
    fileprivate lazy var viewModel : BusinessSubmissionMessageVM = BusinessSubmissionMessageVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width:SCREEN_WIDTH , height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BusinessSubmissionMessageCell", bundle: nil),forCellReuseIdentifier: self.businessSubmissionMessageCell)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.getData()
        })
        return tableView
    }()
    
    lazy var noDataImgeVw: UIImageView = {
        let image = UIImageView()
        image.image = UIImage.init(named: "ic_home_finish")
        let size = CGSize(width: 130, height: 100)
        image.frame = CGRect(x: SCREEN_WIDTH/2 - size.width/2, y: (SCREEN_HEIGHT/2 - size.height/2) - YMAKE(50), width: size.width, height: size.height)
        view.addSubview(image)
        let lab = UILabel()
        lab.text = LanguageHelper.getString(key: "no_record")
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = .center
        lab.frame = CGRect(x: 0, y: image.height + 5, width: image.width, height: 22)
        lab.textColor = R_UIThemeColor
        image.addSubview(lab)
        return image
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BusinessSubmissionMessageVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "Mine_Representation_Record"))
        view.addSubview(tableView)
    }
    
    func getData(){
        let language = Tools.getLocalLanguage()
        let token = (UserDefaults.standard.getUserInfo().token)!
        let userId = (UserDefaults.standard.getUserInfo().id)!
        let pageNum = "\(self.pageNum)"
        let pageSize = "\(self.pageSize)"
        let parameters = ["language":language,"token":token,"userId":userId,"pageNum":pageNum,"pageSize":pageSize] as [String : Any]
        viewModel.loadSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPISpotDisputeDisputeList, parameters: parameters, showIndicator: false) {
            self.pageNum = self.pageNum + 1
            self.tableView.reloadData()
            if self.viewModel.model.count == 0 {
                self.view.bringSubview(toFront: self.noDataImgeVw)
            }else{
                self.view.bringSubview(toFront: self.tableView)
            }
        }
        self.tableView.mj_footer.endRefreshing()
    }
}

extension BusinessSubmissionMessageVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: businessSubmissionMessageCell, for: indexPath) as! BusinessSubmissionMessageCell
        cell.selectionStyle = .none
        cell.model = viewModel.model[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.model[indexPath.row]
        let businessSubmissionDetailsVC = BusinessSubmissionDetailsVC()
        businessSubmissionDetailsVC.model = viewModel.model[indexPath.row]
        businessSubmissionDetailsVC.disputeId = (model.id?.stringValue)!
        self.navigationController?.pushViewController(businessSubmissionDetailsVC, animated: true)
    }
}
