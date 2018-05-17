//
//  NewsDetailViewController.swift
//  GuiCoinPlatform
//
//  Created by zhengyi on 2017/11/8.
//  Copyright © 2017年 郑义. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var topView: CreatTopView?
    var webView: WKWebView?
    var progressView: UIProgressView?
    var news: InformationData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        let topViewHeight:CGFloat = 64
        
        topView = CreatTopView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: topViewHeight))
        topView?.setViewContent(title: LanguageHelper.getString(key: "news_newsdetail"))
        topView?.setButtonCallBack(block: { (sender) in
            self.navigationController?.popViewController(animated: true)
        })
        
        self.view.addSubview(topView!)
        
        progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: CGFloat(topViewHeight), width: CGFloat(SCREEN_WIDTH), height: 1))
        progressView?.tintColor = UIColor.red
        self.view.addSubview(progressView!)
        
        webView = WKWebView.init(frame: CGRect.init(x: 15, y: CGFloat(topViewHeight + 1), width: CGFloat(SCREEN_WIDTH ), height: SCREEN_HEIGHT - topViewHeight - 10))
        self.view.addSubview(webView!)
        
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
       
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        if let urlstring = news?.newsUrl {
            if urlstring.contains("http://") || urlstring.contains("https://") {
                if let url = URL.init(string: (news?.newsUrl)!) {
                    webView?.load(URLRequest.init(url: url))
                }
            }
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if  keyPath == "estimatedProgress" {
            self.progressView?.progress = Float((self.webView?.estimatedProgress)!)
            if self.progressView?.progress == 1 {
                
                UIView.animate(withDuration: 0.25, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.4)
                }, completion: { (finish) in
                    //self.progressView?.isHidden = true
                })
                
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView?.isHidden = false
        progressView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.5)
        self.view.bringSubview(toFront: progressView!)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView?.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        progressView?.isHidden = true

    }
    
    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
