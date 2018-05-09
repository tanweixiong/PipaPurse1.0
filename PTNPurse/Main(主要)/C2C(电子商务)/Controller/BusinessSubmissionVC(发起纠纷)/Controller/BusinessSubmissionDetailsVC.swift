//
//  BusinessSubmissionDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessSubmissionDetailsVC: MainViewController {
    fileprivate lazy var viewModel : BusinessSubmissionMessageVM = BusinessSubmissionMessageVM()
    var model = BusinessSubmissionMsgModel()
    var disputeId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var detailsVw: BusinessSubmissionMessageVW = {
        let view = Bundle.main.loadNibNamed("BusinessSubmissionMessageVW", owner: nil, options: nil)?.last as! BusinessSubmissionMessageVW
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return view
    }()
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight)
        scrollView.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xF0F2F5)
        return scrollView
    }()
    
    override func loadViewIfNeeded() {
         let maxY = model?.reason == nil || model?.reason == ""  ? detailsVw.replyNorVw.frame.maxY : detailsVw.replyVw.frame.maxY
         scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: maxY + 20)
         detailsVw.height = detailsVw.replyVw.frame.maxY + 20
    }
}

extension BusinessSubmissionDetailsVC {
    //绘制视图
    func setupUI(){
        setNormalNaviBar(title: LanguageHelper.getString(key: "C2C_transaction_Feedback"))
        view.addSubview(scrollView)
        scrollView.addSubview(detailsVw)
    }
    
    func getData(){
        let token = (UserDefaults.standard.getUserInfo().token)!
        let language = Tools.getLocalLanguage()
        let disputeId = self.disputeId
        let parameters = ["token":token,"language":language,"disputeId":disputeId]
        viewModel.loadSubmissionDetailsSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPISpotDisputeDisputeDetail, parameters: parameters, showIndicator: false) {
            let model = self.viewModel.detailsModel
            let type = model.type!
            let explainStr = model.remark!
            let reason = model.reason == nil ? "" : model.reason
            self.detailsVw.reasonLab.text = Tools.getSubmissionDetailsStr(number: type)
            self.detailsVw.explainLab.text = explainStr
            self.detailsVw.officialReplyLab.text = reason
            self.detailsVw.replyNorVw.isHidden = model.reason == nil || model.reason == "" ? false : true
            self.detailsVw.dataTime.text = model.dateStr == nil ? "" : model.dateStr
            self.detailsVw.layoutIfNeeded() //重新获取高度
            
            let img1 = model.img1 == nil ? "" : model.img1
            let img2 = model.img2 == nil ? "" : model.img2
            let img3 = model.img3 == nil ? "" : model.img3
            let arrayImage = [img1,img2,img3]
            if arrayImage.count != 0 {
                for item in 0...arrayImage.count - 1 {
                    let name = arrayImage[item]
                    let imageView = self.detailsVw.viewWithTag(item + 1) as! UIImageView
                    imageView.sd_setImage(with: NSURL(string: name!)! as URL, placeholderImage: UIImage.init(named:""))
                }
            }
        }
    }
    
    
}
