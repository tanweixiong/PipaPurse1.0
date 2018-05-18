//
//  MineRuleDescriptionVC.swift
//  PTNPurse
//
//  Created by tam on 2018/5/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineRuleDescriptionVC: MainViewController {
    var url = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var webView : UIWebView = {
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight)
        let url = self.url
        webView.loadRequest(URLRequest(url:URL(string: url)!))
        return  webView
    }()
}

extension MineRuleDescriptionVC {
    func setupUI(){
         setNormalNaviBar(title: "规则说明")
         view.addSubview(webView)
    }
}
