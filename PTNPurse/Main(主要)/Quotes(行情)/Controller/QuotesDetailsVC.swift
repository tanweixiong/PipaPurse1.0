//
//  QuotesDetailsVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class QuotesDetailsVC: MainViewController {
    fileprivate var viewModel : QuotesVM = QuotesVM()
    var model = QuotesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var quotesDetailsView: QuotesDetailsView = {
        let view = Bundle.main.loadNibNamed("QuotesDetailsView", owner: nil, options: nil)?.last as! QuotesDetailsView
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviHeight , width: SCREEN_WIDTH, height: 110)
        return view
    }()
    
    lazy var conversionStatusView: HomeConversionStatusView = {
        let view = Bundle.main.loadNibNamed("HomeConversionStatusView", owner: nil, options: nil)?.last as! HomeConversionStatusView
        view.frame = CGRect(x: 0, y: Int(MainViewControllerUX.naviHeight_y) , width: Int(SCREEN_WIDTH), height: 75)
        view.rankLabel1.text = LanguageHelper.getString(key: "homePage_Numbers")
        view.model = model
        return view
    }()
    
    lazy var webView : UIWebView = {
        let webView = UIWebView()
         webView.frame = CGRect(x: 15, y: self.quotesDetailsView.frame.maxY, width: SCREEN_WIDTH - 30, height: SCREEN_HEIGHT - self.quotesDetailsView.frame.maxY - 15)
        let coinNo = (self.model?.coinNo?.stringValue)!
        let url = ZYConstAPI.kAPIQuotesDetailsH5BaseURL + coinNo
         webView.loadRequest(URLRequest(url:URL(string: url)!))
         webView.layer.cornerRadius = 5
         webView.layer.masksToBounds = true
         webView.delegate = self
         return  webView
    }()
}

extension QuotesDetailsVC:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show(withStatus:LanguageHelper.getString(key: "please_wait"))
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
         SVProgressHUD.dismiss()
    }
}

extension QuotesDetailsVC{
    func setupUI(){
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: LanguageHelper.getString(key: "quotes_details"))
        naviBarView.addSubview(conversionStatusView)
        view.addSubview(quotesDetailsView)
        view.addSubview(webView)
    }
    
    func getData(){
        let coinNo = (model?.coinNo?.stringValue)!
        let parameters = ["language":Tools.getLocalLanguage(),"coinNo":coinNo]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIMarket, parameters: parameters, showIndicator: false) {
            self.quotesDetailsView.model = self.viewModel.detsilsModel
            let  coinIcon = self.viewModel.detsilsModel.coinIcon == nil ? "" : self.viewModel.detsilsModel.coinIcon
            self.conversionStatusView.iconImageView.sd_setImage(with:NSURL(string: coinIcon! as String)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        }
    }
    
}
