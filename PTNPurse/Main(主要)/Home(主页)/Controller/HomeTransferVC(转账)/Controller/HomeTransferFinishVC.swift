//
//  HomeTransferFinishVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeTransferFinishVC: MainViewController {
    fileprivate var headingString = String()
    var conversionDetials = HomeConversionDetialsModel()
    var style  = HomeTransferDetailsStatus.receiveStyle
    var price = String()
    var transactionId = String()
    var coinName = String()
    var fee = String()//矿工费
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(finishView)
        setNormalNaviBar(title: "转账成功")
        self.backToBtn.isHidden = true
        
        coinName = coinName == "" ? Tools.getAppCoinName() : coinName
        if style == .transferStyle {
            headingString = LanguageHelper.getString(key: "homePage_Details_Successfully_Transfer_Finish") +     " " + "\(price)" + LanguageHelper.getString(key: "homePage_Details_Successfully_A_Finish")  + coinName + " " + LanguageHelper.getString(key: "homePage_Miner_Fee") + " " + fee + coinName
            title = LanguageHelper.getString(key: "homePage_Details_Transfer_Finish")
            finishView.detailsBtn.setTitle(LanguageHelper.getString(key: "homePage_Finish_Transfer_Details"), for: .normal)
        }else if style == .conversionStyle{
            headingString = LanguageHelper.getString(key: "homePage_Details_Successfully_Conversion_Finish")  + " " + coinName + "\(price)" + LanguageHelper.getString(key: "homePage_Numbers")
            title = LanguageHelper.getString(key: "homePage_Details_Successfully_Conversion_Finish")
            finishView.detailsBtn.setTitle(LanguageHelper.getString(key: "homePage_Finish_Conversion_Details"), for: .normal)
        }
        self.finishView.titleLabel.text = headingString
    }
    
    @objc func onClick(_ sender:UIButton){
        if sender.tag == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            let homeTransferDetailsVC = HomeTransferDetailsVC()
            homeTransferDetailsVC.style = self.style
            homeTransferDetailsVC.conversionDetials = self.conversionDetials
            homeTransferDetailsVC.transactionId = self.transactionId
            self.navigationController?.pushViewController(homeTransferDetailsVC, animated: true)
        }
    }
    
    lazy var finishView: HomeTransferFinishView = {
        let view = Bundle.main.loadNibNamed("HomeTransferFinishView", owner: nil, options: nil)?.last as! HomeTransferFinishView
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height:SCREEN_HEIGHT)
        view.closeBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.detailsBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.closeBtn.tag = 1
        view.detailsBtn.backgroundColor = R_UIThemeColor
        view.detailsBtn.tag = 2
        return view
    }()
}
