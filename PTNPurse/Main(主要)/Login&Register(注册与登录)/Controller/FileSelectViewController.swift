//
//  FileSelectViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/29.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

class FileSelectViewController: UIViewController, UITextFieldDelegate, FileListViewControllerDelegate {
    
    @IBOutlet weak var topView: CreatTopView!
    @IBOutlet weak var selectTextView: LoginTextFieldView!
    @IBOutlet weak var selectFileBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    
    
    // MARK: - lift cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - EventResponse Method
    @IBAction func importBtnTouched(_ sender: UIButton) {
        view.endEditing(true)
        let homeBackupDetailsVC = HomeBackupDetailsVC()
        homeBackupDetailsVC.style = .importStyle
        self.navigationController?.pushViewController(homeBackupDetailsVC, animated: true)
    }
    
    @IBAction func selectBtnTouched(_ sender: UIButton) {
        let filelistvc = FileListViewController()
        filelistvc.delegate = self
        navigationController?.pushViewController(filelistvc, animated: true)
    }
    
    // MARK: - NetWork Method
    func importWalletAddress(prompt: String, adddress: String) {
        
    }
    
    // MARK: - Delegate Method
    func textViewDidEndEditing(_ textView: UITextView) {
        changeBtnStyle()
    }
    
    func didSelectFile(filename: String) {
        selectTextView.textField.text = filename
        changeBtnStyle()
    }
    
    func changeBtnStyle() {
        if selectTextView.textField.text! != "" {
            Tools.setButtonType(isBoarder: false, sender: nextBtn, fontSize: R_ZYBtnFontSize, bgcolor: R_ZYThemeColor)
            nextBtn.isUserInteractionEnabled = true
        } else {
            Tools.setButtonType(isBoarder: true, sender: nextBtn, fontSize: R_ZYBtnFontSize, bgcolor: R_ZYThemeColor)
            nextBtn.isUserInteractionEnabled = false
        }
        
    }
    
    // MARK: - Private Method
    func setViewStyle() {
        
        selectTextView.addTextFieldAndRightBtn(viewType: .DefaultType)
        selectTextView.textField.setKeyboardStyle(textType: .TextFieldNormal)
        selectTextView.backgroundColor = UIColor.clear
        selectTextView.titleLabel.text = LanguageHelper.getString(key: "login_selectfile")
        selectTextView.textField.textColor = UIColor.black
        selectTextView.textField.placeholder = LanguageHelper.getString(key: "login_selectfileplaceholder")
        selectTextView.textField.delegate = self
        selectTextView.textField.isUserInteractionEnabled = false
        
        topView.setViewContent(title: LanguageHelper.getString(key: "login_importaccount"))
        
        selectFileBtn.setTitle(LanguageHelper.getString(key: "login_selectfile"), for: .normal)
        Tools.setButtonType(isBoarder: false, sender: selectFileBtn, fontSize: 14, bgcolor: R_UIThemeColor)
        
        nextBtn.setTitle(LanguageHelper.getString(key: "login_next"), for: .normal)
        
        Tools.setButtonType(isBoarder: true, sender: nextBtn, fontSize: R_ZYBtnFontSize, bgcolor: R_ZYThemeColor)
        
        topView.setButtonCallBack { (sender) in
            self.navigationController?.popViewController(animated: true)
        }
        
        changeBtnStyle()
        
    }
    
}

