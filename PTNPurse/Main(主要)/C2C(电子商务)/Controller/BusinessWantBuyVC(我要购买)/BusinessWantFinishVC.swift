//
//  BusinessWantFinishVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/12.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

enum BusinessWantFinishStyle {
    case buyFinishStyle
    case liberateStyle
}

class BusinessWantFinishVC: MainViewController {
    var style = BusinessWantFinishStyle.buyFinishStyle
    var liberateStyle = BusinessTransactionStyle.buyStyle
    var phoneNum = String()
    var orderNo = String()
    var coinName = String()
    var tradePrice = NSNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var finishView: BusinessWantFinishView = {
        let view = Bundle.main.loadNibNamed("BusinessWantFinishView", owner: nil, options: nil)?.last as! BusinessWantFinishView
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight)
        view.contactBtn.addTarget(self, action: #selector(contactOnClick), for: .touchUpInside)
        view.remindBtn.addTarget(self, action: #selector(checkDetailsOnClick), for: .touchUpInside)
        view.remindBtn.backgroundColor = R_UIThemeColor
        return view
    }()
}

extension BusinessWantFinishVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "C2C_home_finish_Published_successfully"))
        view.addSubview(finishView)
        let liberateTitle = liberateStyle == .buyStyle ? LanguageHelper.getString(key: "C2C_mine_My_advertisement_Buy") : LanguageHelper.getString(key: "C2C_mine_My_advertisement_Sell")
        let text = LanguageHelper.getString(key: "C2C_transaction_finish_liberate")
        let currency = LanguageHelper.getString(key: "C2C_transaction_finish_liberate_currency")
        let newText = text + liberateTitle + currency + coinName
        finishView.finishTitleLab.text = style == .buyFinishStyle ? "\(liberateTitle)" + LanguageHelper.getString(key: "C2C_home_finish_Order_submitted_Waiting_for_buyer_to_pay") : newText
        
        if style == .buyFinishStyle {
            if liberateStyle == .buyStyle {
                finishView.finishTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Buy_Finish") + LanguageHelper.getString(key: "C2C_mine_My_The_transaction_price_is") + (tradePrice.stringValue)
                if tradePrice == 0 {
                    finishView.finishTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Buy_Finish")
                }
            }else if liberateStyle == .sellStyle{
                finishView.finishTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Sell_Finish") + LanguageHelper.getString(key: "C2C_mine_My_The_transaction_price_is")  + (tradePrice.stringValue)
                if tradePrice == 0 {
                    finishView.finishTitleLab.text = LanguageHelper.getString(key: "C2C_mine_My_advertisement_Sell_Finish")
                }
            }
        }
    }
    
    @objc func contactOnClick(){
        if style == .liberateStyle {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkDetailsOnClick(){
        //购买详情
        if style == .buyFinishStyle {
            let businessOrderDetailsVC = BusinessOrderDetailsVC()
            businessOrderDetailsVC.orderNo = self.orderNo
            self.navigationController?.pushViewController(businessOrderDetailsVC, animated: true)
        }else{
            let businessWantBuyVC = BusinessBuyHistoryDetailsVC()
            businessWantBuyVC.entrustNo = self.orderNo
            businessWantBuyVC.isHiddenDrop = true
            self.navigationController?.pushViewController(businessWantBuyVC, animated: true)
        }
    }
}
