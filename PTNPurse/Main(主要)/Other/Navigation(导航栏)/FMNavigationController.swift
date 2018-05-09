//
//  TPNavigationController.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/8.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

//导航栏的颜色
public let navigationColor:UIColor = UIColor.clear

class FMNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航栏
        self.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor : UIColor.white
        ]
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage.creatImageWithColor(color: UIColor.clear, size: CGSize(width:SCREEN_WIDTH,height:64), alpha: 1), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
    }
    
    // MARK: - private method
    func setBackBarButtonItem() -> UIBarButtonItem {
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "ic_nav_back_white"), for: .normal)
        backButton.addTarget(self, action:  #selector(backClick), for: .touchUpInside)
        backButton.frame = CGRect(x:0, y:0, width:60, height:44)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0)
        return UIBarButtonItem.init(customView: backButton)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        }
        super.pushViewController(viewController, animated: true)
    }
    
    /// 返回
    @objc func backClick() {
        SVProgressHUD.dismiss()
        self.popViewController(animated: true)
    }
    
    func setNoBgNavi() {
        self.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        self.navigationBar.shadowImage = UIImage.init()
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
}


