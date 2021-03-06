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
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight , width: SCREEN_WIDTH, height: 150)
        return view
    }()
    
    lazy var webView : UIWebView = {
        let webView = UIWebView()
         webView.frame = CGRect(x: 15, y: self.quotesDetailsView.frame.maxY + 5, width: SCREEN_WIDTH - 30, height: SCREEN_HEIGHT - self.quotesDetailsView.frame.maxY - 15 - 5)
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
        setNormalNaviBar(title:LanguageHelper.getString(key: "quotes_details"))
        view.addSubview(quotesDetailsView)
        view.addSubview(webView)
    }
    
    func getData(){
        let coinNo = (model?.coinNo?.stringValue)!
        let parameters = ["language":Tools.getLocalLanguage(),"coinNo":coinNo]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIMarket, parameters: parameters, showIndicator: false) {
            self.quotesDetailsView.model = self.viewModel.detsilsModel
        
        }
    }
    
}
