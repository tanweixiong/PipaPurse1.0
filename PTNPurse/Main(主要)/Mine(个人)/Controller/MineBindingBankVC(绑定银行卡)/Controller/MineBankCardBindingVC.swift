//
//  MineBankCardBindingVC.swift
//  BCPPurse
//
//  Created by SKINK on 2018/4/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum MineBankCardBindingStyle{
    case normalStyle
    case selectStyle
    case modifyStyle
}
protocol MineBankCardBindingDelegate {
    func mineBankCardBindingSelectFinish(id:String,bankCardName:String,bankCardNum:String)
}
class MineBankCardBindingVC: MainViewController {
    fileprivate let mineBankCardBindingCell = "MineBankCardBindingCell"
    fileprivate lazy var viewModel : MineBindingBankVM = MineBindingBankVM()
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    var delegate:MineBankCardBindingDelegate?
    var style = MineBankCardBindingStyle.normalStyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
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
        tableView.register(UINib(nibName: "MineBankCardBindingCell", bundle: nil),forCellReuseIdentifier: self.mineBankCardBindingCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //33 32
    lazy var addBankCardBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 34, y: 32, width: 34, height: 22)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle(LanguageHelper.getString(key: "binding_Add"), for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(addBankCardOnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(R_NotificationBankListReload), object: nil)
    }
    
}

extension MineBankCardBindingVC {
    func setupUI(){
        setNormalNaviBar(title:LanguageHelper.getString(key: "binding_Bank_card_binding"))
        view.addSubview(tableView)
        view.addSubview(addBankCardBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: R_NotificationBankListReload), object: nil)
    }
    
   @objc func addBankCardOnClick(_ sender:UIButton){
        let vc = MineBindingDetailsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteOnClick(_ sender:UIButton){
        let model = viewModel.model[sender.tag]
        let token = (UserDefaults.standard.getUserInfo().token)!
        let id = (model.id?.stringValue)!
        let parameters = ["token":token,"id":id]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIBindDeleteBankCard, parameters: parameters, showIndicator: false) { (json) in
             self.viewModel.model.remove(at: sender.tag)
             SVProgressHUD.showSuccess(withStatus: "删除成功")
             self.tableView.reloadData()
        }
    }
    
  @objc func getData(){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let parameters = ["token":token]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIBindGetBankCard, parameters: parameters, showIndicator: false) {
            self.tableView.reloadData()
        }
    }
}

extension MineBankCardBindingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mineBankCardBindingCell, for: indexPath) as! MineBankCardBindingCell
        cell.selectionStyle = .none
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteOnClick(_:)), for: .touchUpInside)
        cell.model = viewModel.model[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if style == .selectStyle {
            let model = viewModel.model[indexPath.row]
            self.delegate?.mineBankCardBindingSelectFinish(id: (model.id?.stringValue)!, bankCardName: model.bank!, bankCardNum: model.code!)
            self.navigationController?.popViewController(animated: true)
        }else if style == .modifyStyle{
            let mineBindingDetailsVC = MineBindingDetailsVC()
            self.navigationController?.pushViewController(mineBindingDetailsVC, animated: true)
        }
    }
    
}
