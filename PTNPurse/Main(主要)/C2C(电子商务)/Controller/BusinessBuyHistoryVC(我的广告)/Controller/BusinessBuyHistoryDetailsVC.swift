//
//  BusinessBuyHistoryDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/22.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class BusinessBuyHistoryDetailsVC: MainViewController {
    var style = BusinessBuyHistoryStatus.processingStyle
    fileprivate lazy var detailsViewModel : BusinessVM = BusinessVM()
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    var entrustNo = String()
    var isHiddenDrop = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getDetailsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var detailsView: BusinessBuyHistoryDetailsVw = {
        let view = Bundle.main.loadNibNamed("BusinessBuyHistoryDetailsVw", owner: nil, options: nil)?.last as! BusinessBuyHistoryDetailsVw
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight + 15, width: SCREEN_WIDTH, height: 395)
        return view
    }()
    
    lazy var remarkView: BusinessRemarkView = {
        let view = Bundle.main.loadNibNamed("BusinessRemarkView", owner: nil, options: nil)?.last as! BusinessRemarkView
        view.frame = CGRect(x: 0, y: detailsView.frame.maxY, width: SCREEN_WIDTH, height: 84)
        view.isUserInteractionEnabled = false
        view.remarkLab.text = LanguageHelper.getString(key: "C2C_publish_order_Message")
        return view
    }()

    lazy var dropBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(LanguageHelper.getString(key: "C2C_mine_my_advertisement_Drop"), for: .normal)
        btn.frame = CGRect(x: SCREEN_WIDTH - 15 - 45, y: 32, width: 45, height: 22)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(dropOnClick(_:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.titleLabel?.textAlignment = .right
        btn.tag = 1
        btn.isHidden = self.style == .processingStyle ? false : true
        btn.isHidden = self.isHiddenDrop 
        return btn
    }()
}

extension BusinessBuyHistoryDetailsVC {
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "C2C_mine_My_advertisement_details"))
        view.addSubview(detailsView)
        view.addSubview(remarkView)
        view.addSubview(dropBtn)
    }
    
    //查看订单详情
    func getDetailsData(){
        let parameters = ["id":self.entrustNo]
        detailsViewModel.loadLiberateSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetSpotEntrustById, parameters: parameters, showIndicator: false, finishedCallback: {
            if self.detailsViewModel.liberateModel.username != nil {
                self.detailsView.model = self.detailsViewModel.liberateModel
                self.remarkView.remarkTV.text = self.detailsViewModel.liberateModel.remark
            }
        })
    }
    
    //下架
   @objc func dropOnClick(_ sender:UIButton){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let entrustNo = self.detailsViewModel.liberateModel.entrustNo!
        let language = Tools.getLocalLanguage()
        let userNo = (UserDefaults.standard.getUserInfo().id?.stringValue)!
        let parameters = ["token":token,"entrustNo":entrustNo,"language":language,"userNo":userNo]
        baseViewModel.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIDelSpotEntrust, parameters: parameters, showIndicator: false) { (json) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: R_NotificationAdvertisingeReload), object: nil)
            SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "C2C_mine_my_advertisement_Drop_finish"))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                 self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
}
