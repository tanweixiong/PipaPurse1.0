//
//  HomeBackupVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/18.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import YYText
import SVProgressHUD

class HomeBackupVC: MainViewController,YYTextViewDelegate {
    fileprivate lazy var viewModel : HomeBackupDetailsVM = HomeBackupDetailsVM()
    fileprivate var memoryStr = ""
    fileprivate let memoryArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundBtn)
        view.backgroundColor = UIColor.R_UIRGBColor(red: 240, green: 242, blue: 245, alpha: 1)
        setNormalNaviBar(title: LanguageHelper.getString(key: "homePage_Backup_Wallet_Navi"))
        self.setUI()
        self.getMemoryWords()
    }
    
    func setUI(){
        titlesLabel.text = LanguageHelper.getString(key: "homePage_Backup_Wallet_Prompt1")
        
        titlesLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(MainViewControllerUX.naviNormalHeight + 15)
            make.left.equalTo(self.view.snp.left).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-15)
            make.height.equalTo(40)
        }
        
        let size = titlesLabel.getStringSize(text:memoryStr, size: CGSize(width:SCREEN_WIDTH,height:CGFloat(MAXFLOAT)), font: 14)
        textView?.text = memoryStr
        textView?.snp.updateConstraints { (make) in
            make.top.equalTo(titlesLabel.snp.bottom).offset(25)
            make.left.equalTo(self.view.snp.left).offset(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.height.equalTo(size.height + 30)
        }
        
        nextBtn.snp.updateConstraints { (make) in
            make.top.equalTo((textView?.snp.bottom)!).offset(80)
            make.left.equalTo(self.view.snp.left).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-15)
            make.height.equalTo(50)
        }
    }
    
    func getMemoryWords(){
        let token = UserDefaults.standard.getUserInfo().token
        let parameters = ["token":token!]
        SVProgressHUD.show(withStatus:LanguageHelper.getString(key: "please_wait"))
        viewModel.loadMemosSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIMemoGetMemos, parameters:parameters, showIndicator: false) {
            SVProgressHUD.dismiss()
            if self.viewModel.memoModel.count != 0 {
                for index in 0...self.viewModel.memoModel.count - 1 {
                    let model = self.viewModel.memoModel[index]
                    self.memoryStr = self.memoryStr + model.memo! + " "
                    let memory = model.memo == nil ? "" : model.memo
                    self.memoryArray.add(memory!)
                    self.setUI()
                }
            }
        }
    }
    
    lazy var backgroundBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - MainViewControllerUX.naviNormalHeight)
        btn.addTarget(self, action: #selector(closeKeyboard), for: .touchUpInside)
        return btn
    }()
    
    lazy var titlesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        self.view.addSubview(label)
        return label
    }()
    
    lazy var nextBtn: UIButton = {
        let btn  = UIButton(type: .system)
        btn.setTitle(LanguageHelper.getString(key: "homePage_Backup_Wallet_NEXT"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(nextStep(_:)), for: .touchUpInside)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = R_UIThemeColor
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var textView:YYTextView? = {
        let view = YYTextView.init(frame: CGRect.init(x: 0, y: 0, width:0, height: 0))
        view.placeholderFont = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
        view.placeholderTextColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 14)
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        self.view.addSubview(view)
        return view
    }()
    
    @objc func nextStep(_ sender:UIButton){
        let homeBackupDetailsVC = HomeBackupDetailsVC()
        homeBackupDetailsVC.memoryArray = self.memoryArray
        self.navigationController?.pushViewController(homeBackupDetailsVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
