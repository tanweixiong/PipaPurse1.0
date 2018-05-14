//
//  MineBindingDetailsVC.swift
//  BCPPurse
//
//  Created by SKINK on 2018/4/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class MineBindingDetailsVC: MainViewController {
    fileprivate lazy var viewModel : BaseViewModel = BaseViewModel()
    fileprivate let mineBindingDetailsCell = "MineBindingDetailsCell"
    fileprivate var cardholderNameTF = UITextField()
    fileprivate var accountTF = UITextField()
    fileprivate var branchBankTF = UITextField()
    fileprivate var bankCardNumberTF = UITextField()
    var style = MineBankCardBindingStyle.modifyStyle
    var dataModel = MineBindingBankModel()
    
    fileprivate let headdingArr =
        [LanguageHelper.getString(key: "binding_Cardholder_name")
        ,LanguageHelper.getString(key: "binding_Bank_account")
        ,LanguageHelper.getString(key: "binding_Bank_branch_bank")
        ,LanguageHelper.getString(key: "binding_Bank_card_number")]
    fileprivate let headdingPlArr = [
        LanguageHelper.getString(key: "binding_Please_type_in_your_name")
        ,LanguageHelper.getString(key: "binding_Please_enter_bank")
        ,LanguageHelper.getString(key: "binding_Please_enter_account_branch_bank")
        ,LanguageHelper.getString(key: "binding_Please_enter_your_bank_card_number")]

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
        tableView.register(UINib(nibName: "MineBindingDetailsCell", bundle: nil),forCellReuseIdentifier: self.mineBindingDetailsCell)
        tableView.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = footView
        return tableView
    }()
    
    lazy var footView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 90))
        view.backgroundColor = UIColor.R_UIRGBColor(red: 249, green: 249, blue: 251, alpha: 1)
        return view
    }()
    
    //33 32
    lazy var submitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 34, y: 32, width: 34, height: 22)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0xBDBDBD), for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.setTitle("新增", for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(determinebOnClick(_:)), for: .touchUpInside)
        return btn
    }()
}

extension MineBindingDetailsVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "binding_Add_bank_card"))
        view.addSubview(tableView)
        view.addSubview(submitBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(MineBindingDetailsVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    @objc func determinebOnClick(_ sender:UIButton){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let name = cardholderNameTF.text!
        let bank = accountTF.text!
        let branch = branchBankTF.text!
        let code = bankCardNumberTF.text!
        let address = ""
        let parameters = ["token":token,"bank":bank,"branch":branch,"name":name,"code":code,"address":address]
        viewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIBindAddBankCard, parameters: parameters, showIndicator: false) { (model:HomeBaseModel) in
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "add_sucess"))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationBankListReload), object: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc func textFieldTextDidChangeOneCI(notification:NSNotification){
        self.setSubmitBtnStyle()
    }
    
    func setSubmitBtnStyle(){
        if cheackInpunt() {
            submitBtn.setTitleColor(UIColor.white, for: .normal)
            submitBtn.isEnabled = true
        }else{
            submitBtn.setTitleColor(R_ZYSelectNormalColor, for: .normal)
            submitBtn.isEnabled = false
        }
    }
    
    func cheackInpunt()->Bool{
        let cardholderName = cardholderNameTF.text!
        let account = accountTF.text!
        let branchBank = branchBankTF.text!
        let bankCardNumber = bankCardNumberTF.text!
        if cardholderName.count == 0 {
            return false
        }
        if account.count == 0 {
            return false
        }
        
        if branchBank.count == 0 {
            return false
        }
        
        if bankCardNumber.count > 21 {
            return false
        }
        
        if bankCardNumber.count < 13 {
            return false
        }
        
        return true
    }
}

extension MineBindingDetailsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headdingArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mineBindingDetailsCell, for: indexPath) as! MineBindingDetailsCell
        cell.selectionStyle = .none
        cell.titleLab.text = headdingArr[indexPath.row]
        cell.textField.placeholder = headdingPlArr[indexPath.row]
        cell.textField.textColor = UIColor.R_UIColorFromRGB(color: 0x979797)
        if indexPath.row == 0 {
            cardholderNameTF = cell.textField
        }else if indexPath.row == 1 {
            accountTF = cell.textField
        }else if indexPath.row == 2 {
            branchBankTF = cell.textField
        }else if indexPath.row == 3 {
            cell.textField.keyboardType = .decimalPad
            bankCardNumberTF = cell.textField
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        tableView.contentSize = CGSize(width: 0, height: SCREEN_HEIGHT + 50)
    }
    
}
