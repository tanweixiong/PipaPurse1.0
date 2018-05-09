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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BusinessSubmissionMessageVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "C2C_transaction_Feedback_record"))
        view.addSubview(tableView)
    }
    
    func getData(){
        let language = Tools.getLocalLanguage()
        let token = (UserDefaults.standard.getUserInfo().token)!
        let userId = (UserDefaults.standard.getUserInfo().id)!
        let pageNum = "\(self.pageNum)"
        let pageSize = "\(self.pageSize)"
        let parameters = ["language":language,"token":token,"userId":userId,"pageNum":pageNum,"pageSize":pageSize] as [String : Any]
        print(parameters)
        viewModel.loadSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPISpotDisputeDisputeList, parameters: parameters, showIndicator: false) {
             self.pageNum = self.pageNum + 1
             self.tableView.reloadData()
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
