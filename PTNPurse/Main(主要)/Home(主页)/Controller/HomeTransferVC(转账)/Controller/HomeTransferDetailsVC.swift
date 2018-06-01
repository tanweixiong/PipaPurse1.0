//
//  HomeTransferDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

enum HomeTransferDetailsStatus{
    case receiveStyle //接收详情
    case transferStyle //转账详情
    case conversionStyle //转换详情
}
class HomeTransferDetailsVC: MainViewController,UITableViewDataSource,UITableViewDelegate {
    fileprivate lazy var viewModel : HomeTransferDetailsVM = HomeTransferDetailsVM()
    var conversionDetials = HomeConversionDetialsModel()
    var style = HomeTransferDetailsStatus.receiveStyle
    var transactionId = String()
//    LanguageHelper.getString(key: "net_rightphone")
    fileprivate let homeTransferDetailsCell = "HomeTransferDetailsCell"
//    fileprivate let headingArray = ["交易号","交易类型","接收地址","交易时间","手续费"]
    fileprivate let headingArray = NSMutableArray()
    //接收详情
    fileprivate let receiveHeadingArray = [
         LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Number")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Type")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Quantity")
        ,LanguageHelper.getString(key: "homePage_Finish_Transfer_Address")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Time")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Fee")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Remarks")]
    //转账详情
    fileprivate let transferHeadingArray = [
         LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Number")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Type")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Quantity")
        ,LanguageHelper.getString(key: "homePage_Finish_Transfer_Address")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Time")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Fee")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Remarks")]
    //转换详情
    fileprivate let conversionHeadingArray = [
         LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Number")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Type")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Quantity")
        ,LanguageHelper.getString(key: "homePage_Details_Conversion_List")
        ,LanguageHelper.getString(key: "homePage_Finish_Transfer_Address")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Time")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Fee")
        ,LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Remarks")]
    let headingContentArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        var title = ""
        if style == .receiveStyle {
            title = LanguageHelper.getString(key: "homePage_Details_Receive") + LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Details")
            headingArray.addObjects(from: receiveHeadingArray)
            self.getReceiveDetails()
        }else if style == .transferStyle {
              title = LanguageHelper.getString(key: "homePage_Details_Transfer") + LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Details")
            headingArray.addObjects(from: transferHeadingArray)
            self.getTransferDetails()
        }else if style == .conversionStyle {
            title = LanguageHelper.getString(key: "homePage_Details_Conversion") + LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Details")
            headingArray.addObjects(from: conversionHeadingArray)
            self.getConversionDetials()
        }
        setNormalNaviBar(title: title)
        self.view.addSubview(tableView)
    }
    
    //获取转账详情
    func getTransferDetails(){
        let tradeNo = self.transactionId
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["tradeNo":tradeNo,"token":token!]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetTradeInfoByNo, parameters: parameters, showIndicator: false) {
            let model = self.viewModel.model
            let orderNo = model.orderNo
            let trans = LanguageHelper.getString(key: "homePage_Details_Transfer")
            let tradeNum = "-" + Tools.setNSDecimalNumber(model.tradeNum == nil ? 0 : (model.tradeNum)!) + " " + LanguageHelper.getString(key: "homePage_Numbers")
            let inAddress = model.inAddress
            let data = model.date!
            let ratioCore = model.ratioCore == nil ? "" : (model.ratioCore)!
            let ratio = Tools.setNSDecimalNumber((model.ratio)!) + ratioCore
            let remark = model.remark
            if remark == "" {
               self.headingContentArray.addObjects(from: [orderNo!,trans,tradeNum,inAddress!,data,ratio])
            }else{
                self.headingContentArray.addObjects(from: [orderNo!,trans,tradeNum,inAddress!,data,ratio,remark!])
            }
            self.tableView.reloadData()
        }
    }
    
    //获取转换详情
    func getConversionDetials(){
      //["交易号","交易类型","交易数量","转账地址","交易时间","手续费","备注信息"]
        if transactionId == "" {
//             0：转出，1：转入
            let orderNo = conversionDetials?.orderNo
            let trans = LanguageHelper.getString(key: "homePage_Details_Conversion")
            let add =  "-"
            let ptnAdd =  "+"
            let coinNum = add + (conversionDetials?.coinNum?.stringValue)! + " " + (conversionDetials?.coinName!)!
            let inAddress = conversionDetials?.address
            let date = conversionDetials?.dateString
            let ratio = add + (conversionDetials?.ratio?.stringValue)! + " " + (conversionDetials?.coinName!)!
            let remark = conversionDetials?.remark
            let ptn = ptnAdd + " " + (conversionDetials?.pnt?.stringValue)! + " " + Tools.getAppCoinName()
            //如果空则不存在备注
            if remark == ""{
                self.headingContentArray.addObjects(from: [orderNo!,trans,coinNum,ptn,inAddress!,date!,ratio])
            }else{
                self.headingContentArray.addObjects(from: [orderNo!,trans,coinNum,ptn,inAddress!,date!,ratio,remark!])
            }
            self.tableView.reloadData()
        }
    }
    
    //获取接收详情
    func getReceiveDetails(){
        let tradeNo = self.transactionId
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["tradeNo":tradeNo,"token":token!]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetTradeInfoByNo, parameters: parameters, showIndicator: false) {
            //            ["交易号","转账地址","交易数量","交易类型","交易时间","手续费"]
            let model = self.viewModel.model
            let orderNo = model.orderNo
            let trans = LanguageHelper.getString(key: "homePage_Details_Receive")
            let tradeNum = "+" + (model.tradeNum?.stringValue)!
//            let tradeNum = "+" + (model.tradeNum?.stringValue)! + " " + LanguageHelper.getString(key: "homePage_Numbers")
            let inAddress = model.outAddress
            let data = model.date!
            let ratio =  String(format: "%.2f", (model.ratio?.doubleValue)!)
            let remark = model.remark
            if remark == "" {
                self.headingContentArray.addObjects(from: [orderNo!,trans,tradeNum,inAddress!,data,ratio])
            }else{
                self.headingContentArray.addObjects(from: [orderNo!,trans,tradeNum,inAddress!,data,ratio,remark!])
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headingContentArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeTransferDetailsCell, for: indexPath) as! HomeTransferDetailsCell
        cell.selectionStyle = .none
        cell.titleLab.text = headingArray[indexPath.row] as? String
        cell.contentLab.text = headingContentArray[indexPath.row] as? String
        //转换
        if headingContentArray[indexPath.row] as? String == LanguageHelper.getString(key: "homePage_Details_Conversion") {
            cell.contentLab.textColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
        //转账
        }else if headingContentArray[indexPath.row] as? String == LanguageHelper.getString(key: "homePage_Details_Transfer") {
            cell.contentLab.textColor = UIColor.R_UIColorFromRGB(color: 0x00D85A)
        //接收
        }else if headingContentArray[indexPath.row] as? String == LanguageHelper.getString(key: "homePage_Details_Receive") {
             cell.contentLab.textColor = UIColor.R_UIColorFromRGB(color: 0xFF7052)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0.0, y: CGFloat(MainViewControllerUX.naviNormalHeight), width: SCREEN_WIDTH, height: SCREEN_HEIGHT -  CGFloat(MainViewControllerUX.naviNormalHeight)))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeTransferDetailsCell", bundle: nil),forCellReuseIdentifier: self.homeTransferDetailsCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.tableFooterView = UIView()
        tableView.separatorColor = R_UISectionLineColor
        return tableView
    }()
}
