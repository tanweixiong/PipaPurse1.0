//
//  MineSetPaymentVC.swift
//  PTNPurse
//
//  Created by tam on 2018/5/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineSetPaymentVC: MainViewController {
    fileprivate let securitySetViewCell = "SecuritySetViewCell"
    fileprivate let dataArray = ["binding_Alipay_account","binding_Wechat_account","binding_BankCard_account"]

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
        tableView.register(UINib(nibName: "SecuritySetViewCell", bundle: nil),forCellReuseIdentifier: self.securitySetViewCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension MineSetPaymentVC {
    func setupUI(){
         setNormalNaviBar(title: LanguageHelper.getString(key: "Mine_PaymentMethod"))
         view.addSubview(tableView)
    }
}

extension MineSetPaymentVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: securitySetViewCell, for: indexPath) as! SecuritySetViewCell
        cell.selectionStyle = .none
        cell.headingContentLab.text = LanguageHelper.getString(key: dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
             let mineSetAccountVC = MineSetAccountVC()
             mineSetAccountVC.style = .alipayStyle
             self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
        case 1:
            let mineSetAccountVC = MineSetAccountVC()
            mineSetAccountVC.style = .weChatStyle
            self.navigationController?.pushViewController(mineSetAccountVC, animated: true)
        case 2:
            let vc = MineBankCardBindingVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
}
