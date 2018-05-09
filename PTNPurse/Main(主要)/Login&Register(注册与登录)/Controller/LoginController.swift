//
//  LoginController.swift
//  BCPPurse
//
//  Created by tam on 2018/4/2.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(loginVw)
        
        let marqueeView = CQMarqueeView.init(frame: CGRect(x: SCREEN_WIDTH/2 - 174.5/2 , y: YMAKE(295), width: 174.5, height: YMAKE(42)))
        marqueeView.marqueeTextArray = ["Welcome to Photon"]
        marqueeView.centerX  = self.view.centerX
        view.addSubview(marqueeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var loginVw: LoginVw = {
        let view = Bundle.main.loadNibNamed("LoginVw", owner: nil, options: nil)?.last as! LoginVw
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        view.createBtn.tag = 1
        view.createBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.importBtn.tag = 2
        view.importBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.chooseLanguageBtn.tag = 3
        view.chooseLanguageBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        return view
    }()
    
    @objc func onClick(_ sender:UIButton){
        if sender == loginVw.createBtn {
            let registerViewController = RegisterViewController()
            registerViewController.type = .register
            self.navigationController?.pushViewController(registerViewController, animated: true)
        }else if sender == loginVw.importBtn {
            let importWallet = MineImportWalletVC()
            self.navigationController?.pushViewController(importWallet, animated: true)
        }else if sender == loginVw.chooseLanguageBtn{
            let languageSetViewController = LanguageSetViewController()
            languageSetViewController.style = .special
            languageSetViewController.type = .language
            self.navigationController?.pushViewController(languageSetViewController, animated: true)
        }
    }
}
