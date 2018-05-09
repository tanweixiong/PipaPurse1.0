//
//  TPMainViewController.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/10.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainViewController: UIViewController {
    let titleLabel = UILabel()
    let naviBarView = UIView()
    var backToBtn = UIButton()
    struct MainViewControllerUX {
        static let naviHeight_y:CGFloat = 111
        static let naviHeight:CGFloat = 186
        static let naviNormalHeight:CGFloat = 115.00
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    //返回按钮点击响应
    @objc func backToPrevious() {
        SVProgressHUD.dismiss()
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func rightImageBtn(_ sender:UIBarButtonItem) {
        
    }
    
    @objc func leftImageBtn(_ sender:UIBarButtonItem) {
        
    }
    
    @objc func rightTextBtn(_ sender:UIBarButtonItem) {
        
    }
    
    @objc func leftTextBtn(_ sender:UIBarButtonItem) {
        
    }
    
    func setHideBackBtn(){
        self.backToBtn.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainViewController {
    
    func setCustomNaviBar(backgroundImage:String,title:String){
        self.naviBarView.frame = CGRect(x: 0, y: 0, width: Int(SCREEN_WIDTH), height: Int(MainViewController.MainViewControllerUX.naviHeight))
        //背景图片
        let image = UIImageView(frame:self.naviBarView.bounds)
        image.image = UIImage.init(named: backgroundImage)
        self.naviBarView.addSubview(image)
        //返回按钮
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage.init(named: "ic_back_let"), for: .normal)
        backBtn.addTarget(self, action:#selector(backToPrevious), for: .touchUpInside)
        backBtn.frame = CGRect(x: 15, y: 30, width: 50, height: 50)
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -25, bottom: 0, right: 0)
        self.naviBarView.addSubview(backBtn)
        self.titleLabel.frame = CGRect(x: 15, y: backBtn.frame.maxY + 10 - 10 - 5, width: SCREEN_WIDTH - 15, height: 36)
        self.titleLabel.text = title
        self.titleLabel.textColor = UIColor.white
        self.naviBarView.addSubview(self.titleLabel)
        self.view.addSubview(self.naviBarView)
    }
    
    func setNormalNaviBar(title:String){
        navigationController?.navigationBar.isHidden = true
        naviBarView.frame = CGRect(x: 0, y: 0, width: Int(SCREEN_WIDTH), height: Int(MainViewController.MainViewControllerUX.naviNormalHeight))
        //背景图片
        let image = UIImageView(frame:naviBarView.bounds)
        image.image = UIImage.init(named: "ic_pubilc_normalBackground")
        naviBarView.addSubview(image)
        
        //标题
        titleLabel.frame = CGRect(x: 15, y: 70 , width: SCREEN_WIDTH - 15, height: 36)
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        naviBarView.addSubview(titleLabel)
        view.addSubview(naviBarView)
        
        //返回按钮
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage.init(named: "ic_back_let"), for: .normal)
        backBtn.addTarget(self, action:#selector(backToPrevious), for: .touchUpInside)
        backBtn.frame = CGRect(x: 15, y: 30, width: 100, height: 100)
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: -60, left: -80, bottom: 0, right: 0)
        backBtn.backgroundColor = UIColor.clear
        naviBarView.addSubview(backBtn)
        
        self.backToBtn = backBtn
    }

     func addDefaultBackBarButtonLeft() {
        let button =   UIButton(type: .custom)
        button.frame = CGRect(x:0, y:0, width:60, height:44)
        button.setImage(UIImage(named:"ic_nav_back_white"), for: .normal)
        button.addTarget(self, action: #selector(backToPrevious), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0)
        let leftBarBtn = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    
    func addDefaultButtonTextRight(_ title:String) {
        let button =   UIButton(type: .custom)
        button.frame = CGRect(x:0, y:0, width:60, height:44)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(rightTextBtn(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let leftBarBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = leftBarBtn
    }
    
    func addDefaultButtonTextLeft(_ title:String) {
        let button =   UIButton(type: .custom)
        button.frame = CGRect(x:0, y:0, width:60, height:44)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(leftTextBtn(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        let leftBarBtn = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = leftBarBtn
    }
    
    func addDefaultButtonImageRight(_ buttonImage:String) {
        let image = UIImage(named:buttonImage)?.withRenderingMode(.alwaysOriginal)
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightImageBtn(_ :)))
        self.navigationItem.rightBarButtonItem = item;
    }
    
    func addDefaultButtonImageLeft(_ buttonImage:String) {
        let image = UIImage(named:buttonImage)?.withRenderingMode(.alwaysOriginal)
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftImageBtn(_:)))
        self.navigationItem.leftBarButtonItem = item
    }
    
    func addRemoveBackImageLeft(){
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    func pushNextViewController(_ viewController:UIViewController,_ animated:Bool) {
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: animated)
    }

    
    
}
