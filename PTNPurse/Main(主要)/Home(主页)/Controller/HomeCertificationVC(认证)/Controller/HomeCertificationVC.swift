//
//  HomeCertificationVC.swift
//  PTNPurse
//
//  Created by tam on 2018/3/7.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeCertificationVC: MainViewController{
    fileprivate var isuploadFinish = false
    var mineDocumentName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var certificationView: HomeCertificationView = {
        let view = Bundle.main.loadNibNamed("HomeCertificationView", owner: nil, options: nil)?.last as! HomeCertificationView
        view.frame = CGRect(x: 0, y: MainViewControllerUX.naviNormalHeight, width: SCREEN_WIDTH, height: 150)
        view.uploadBtn.addTarget(self, action: #selector(HomeCertificationVC.chooseUploadFile), for: .touchUpInside)
        view.companyNameTF.delegate = self
        view.fileNameTF.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(HomeCertificationVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: view.companyNameTF)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeCertificationVC.textFieldTextDidChangeOneCI), name:NSNotification.Name.UITextFieldTextDidChange, object: view.fileNameTF)
        return view
    }()
    
    lazy var submitBtn : UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: certificationView.frame.maxY + 100, width: SCREEN_WIDTH - 40, height: 50))
        button.setTitle(LanguageHelper.getString(key: "perseon_Submit_Review"), for: .normal)
        button.addTarget(self, action: #selector(HomeCertificationVC.uploadFile), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    @objc func textFieldTextDidChangeOneCI(notification:NSNotification){
        let fileName = certificationView.fileNameTF.text!
        let companyName = certificationView.companyNameTF.text!
        self.submitBtn.isSelected = fileName != "" && companyName != "" ?  true : false
        self.setSubmitBtnStyle()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
}

//绘制UI
extension HomeCertificationVC {
    //绘制UI
    func setupUI(){
        setCustomNaviBar(backgroundImage: "ic_naviBar_backgroundImg",title: LanguageHelper.getString(key: "perseon_Company_Settled"))
        view.addSubview(certificationView)
        view.addSubview(submitBtn)
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closeKeyboard)))
        setSubmitBtnStyle()
    }
    
    //上传文件
    @objc func uploadFile(){
        if checkInput() && isuploadFinish == false{
            isuploadFinish = true
            let userId = (UserDefaults.standard.getUserInfo().id?.stringValue)!
            let company = certificationView.companyNameTF.text!
            let token = UserDefaults.standard.getUserInfo().token!
            let parameter = ["language":Tools.getLocalLanguage(),"userId":userId,"company":company,"remark":"","token":token]
            let filePath = self.getDocumentDirectoryUrl() + "/" + certificationView.fileNameTF.text!
            let fileName = certificationView.fileNameTF.text!
            ZYNetWorkTool.uploadFile(url: ZYConstAPI.kAPIUploadWhitePaper, parameter: parameter, filePath: filePath, fileName: fileName, success: { (json) in
                self.isuploadFinish = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }, fail: { (error) in
                SVProgressHUD.showInfo(withStatus:LanguageHelper.getString(key: "perseon_Failed_Upload"))
            })
        }
    }
    
    @objc func chooseUploadFile(){
          let homeCertificationListVC = HomeCertificationListVC()
          homeCertificationListVC.delegate = self
          self.navigationController?.pushViewController(homeCertificationListVC, animated: true)
    }
    
    func checkInput()->Bool{
        if certificationView.companyNameTF.text! == "" {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "perseon_Enter_Company_Name"))
            return false
        }
        
        if certificationView.fileNameTF.text! == "" {
            SVProgressHUD.showInfo(withStatus: LanguageHelper.getString(key: "perseon_Select_File"))
            return false
        }
        
        if certificationView.companyNameTF.text! == "" &&  certificationView.fileNameTF.text! == "" {
            SVProgressHUD.showInfo(withStatus:LanguageHelper.getString(key: "perseon_Can_Not_Be_Empty"))
            return false
        }
        
        return true
    }
    
    func setSubmitBtnStyle(){
        if submitBtn.isSelected {
            submitBtn.backgroundColor = R_UIThemeColor
            submitBtn.setTitleColor(UIColor.white, for: .normal)
            submitBtn.layer.borderWidth = 0
            submitBtn.isUserInteractionEnabled = true
        }else{
            submitBtn.backgroundColor = UIColor.clear
            submitBtn.setTitleColor(UIColor.R_UIRGBColor(red: 213, green: 215, blue: 232, alpha: 1), for: .normal)
            submitBtn.layer.borderWidth = 1
            submitBtn.layer.borderColor = UIColor.R_UIRGBColor(red: 213, green: 215, blue: 232, alpha: 1).cgColor
            submitBtn.layer.masksToBounds = true
            submitBtn.isUserInteractionEnabled = false
        }
    }
    
    func getDocumentDirectoryUrl()->String{
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = documentPaths[0]
        return documentPath
    }
}

extension HomeCertificationVC : HomeCertificationListDelegate {
    var documentName: String {
        return mineDocumentName
    }
    
    func certificationSelectDocument(name: String) {
         mineDocumentName = name
         self.certificationView.fileNameTF.text = mineDocumentName
        
        let fileName = certificationView.fileNameTF.text!
        let companyName = certificationView.companyNameTF.text!
        self.submitBtn.isSelected = fileName != "" && companyName != "" ?  true : false
         setSubmitBtnStyle()
    }
}



