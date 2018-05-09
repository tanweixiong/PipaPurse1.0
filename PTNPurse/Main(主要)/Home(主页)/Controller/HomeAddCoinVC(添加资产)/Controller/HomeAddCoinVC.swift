//
//  HomeAddCoinVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum HomeAddCoinStatus{
    case ptnState
    case conventionalState
    case otherState
}
protocol HomeAddCoinDelegate {
    func homeAddCoinReloadData(status:HomeAddCoinStatus)
}
class HomeAddCoinVC: MainViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate let homeAddCoinCell = "HomeAddCoinCell"
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    fileprivate lazy var viewModel : HomeAddCoinVM = HomeAddCoinVM()
    var delegate:HomeAddCoinDelegate?
    var status = HomeAddCoinStatus.ptnState
    override func viewDidLoad() {
        super.viewDidLoad()
        setNormalNaviBar(title: LanguageHelper.getString(key: "homePage_Details_Add_New_Asset"))
        self.view.addSubview(tableView)
        self.getData()
    }
    
    func getData(){
        let token = UserDefaults.standard.getUserInfo().token
        let language = Tools.getLocalLanguage()
        let parameters = ["token":token!,"language":language]
        viewModel.loadCoinListSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetWalletStates, parameters: parameters, showIndicator: false) {
            self.tableView.reloadData()
        }
    }
    
    //设置的状态
    func setState(walletState:String,walletType:String){
        let language = Tools.getLocalLanguage()
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["walletState":walletState,"walletType":walletType,"language":language,"token":token!]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIEditWalletState, parameters: parameters, showIndicator: false) {(model:HomeBaseModel) in
            self.delegate?.homeAddCoinReloadData(status: self.status)
        }
    }
    
    func setDataState(switchFuc:UISwitch){
        let model = self.viewModel.model[switchFuc.tag]
        model.state = switchFuc.isOn == true ? 1 : 0
        let dataArray = NSMutableArray()
        dataArray.addObjects(from: self.viewModel.model)
        dataArray.replaceObject(at: switchFuc.tag, with: model)
        self.viewModel.model = dataArray as! [HomeAddCoinListModel]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        view.backgroundColor = R_UISectionLineColor
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeAddCoinCell, for: indexPath) as! HomeAddCoinCell
        cell.selectionStyle = .none
        let model = self.viewModel.model[indexPath.section]
        cell.model = self.viewModel.model[indexPath.section]
        cell.backgroundColor = UIColor.clear
        cell.switchFunc.tag = indexPath.section
        cell.switchFunc.isOn = model.state == 1 ? true : false
        cell.homeAddCoinBlock = { (sender:UISwitch) in
            let model = self.viewModel.model[sender.tag]
            let state = sender.isOn == true ? "1" : "0"
            let id = model.type
            self.setState(walletState: state, walletType: (id?.stringValue)!)
            self.setDataState(switchFuc: sender)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: MainViewControllerUX.naviHeight_y, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviHeight_y))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeAddCoinCell", bundle: nil),forCellReuseIdentifier: self.homeAddCoinCell)
        tableView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xEDEDED)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        tableView.separatorStyle = .none
        return tableView
    }()
}
