//
//  HomeReceiveVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

enum HomeReceiveStyle{
    case otherStyle
    case ptnStyle
}
class HomeReceiveVC: UIViewController,UITextViewDelegate {
    fileprivate lazy var viewModel : HomeReceiveVM = HomeReceiveVM()
    var style = HomeReceiveStyle.otherStyle
    var detailsModel = HomeWalletsModel()
    var walletaddress = String()//钱包地址
    var coinName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(receiveView)
        self.getAddress()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //获取钱包地址
    func getAddress(){
        //如果是ptn从本地获取
        if style == .ptnStyle {
            self.walletaddress = UserDefaults.standard.getUserInfo().ptnaddress!
        }
            self.createImageCode()
    }
    
    func createImageCode(){
        //钱包头像
        var mineAvatar = ""
        if detailsModel?.coinImg != nil {
            mineAvatar = (detailsModel?.coinImg)!
        }
        self.receiveView.headImageView.sd_setImage(with:NSURL(string: mineAvatar)! as URL, placeholderImage: UIImage.init(named: "ic_defaultPicture"))
        //钱包地址
        self.receiveView.addressLabel.text = walletaddress
        setCodeImage()
    }
    
    func setCodeImage(){
        let message = self.receiveView.promptTextField.text
        let addesssDict = ["address":self.walletaddress,"message":message]
        let addesssJson = R_Theme_QRCode + ":" + Tools.getJSONStringFromDictionary(dictionary: addesssDict as NSDictionary)
        self.receiveView.codeImageView.image = Tools.createQRForString(qrString: addesssJson, qrImageName: "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength:Int = 0
        if textField == self.receiveView.promptTextField {
            maxLength = 20
        }
        //限制长度
        let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        if proposeLength > maxLength { return false }
        return true
    }
    
    lazy var receiveView: HomeReceiveView = {
        let view = Bundle.main.loadNibNamed("HomeReceiveView", owner: nil, options: nil)?.last as! HomeReceiveView
        view.frame = CGRect(x: 0, y: -20 , width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 20)
        view.backBtn.addTarget(self, action: #selector(backOnClick(_:)), for: .touchUpInside)
        view.copyAddressBtn.addTarget(self, action: #selector(copyCodeOnClick(_:)), for: .touchUpInside)
        view.nickNameLabel.text = coinName
        view.addressLabel.text = UserDefaults.standard.getUserInfo().ptnaddress!
        view.promptTextField.delegate = self
        view.backgroundBtn.addTarget(self, action: #selector(closeTheKeyboard), for: .touchUpInside)
        view.codeViewBtn.addTarget(self, action: #selector(closeTheKeyboard), for: .touchUpInside)
        view.copyAddressBtn.backgroundColor = R_UIThemeSkyBlueColor
        return view
    }()
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Float
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let keyboardH:CGFloat = (keyboardRect?.size.height)!
        UIView.animate(withDuration: TimeInterval(duration)) {
            if keyboardH > 200 {
                self.view.frame = CGRect(x: 0, y: -YMAKE(230), width: SCREEN_WIDTH, height: SCREEN_HEIGHT_INSIDE)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification) {
        let userInfo = notification.userInfo! as NSDictionary
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Float
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let textContent = textView.text
        let textNum = textContent?.count
        if textNum! > 30 {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: 30)
            let str = textContent?.substring(to: index!)
            textView.text = str
        }
        if OCTools.isPositionTextViewDidChange(textView) {
            self.setCodeImage()
        }
    }
    
    @objc func closeTheKeyboard(){
        self.closeKeyboard()
    }
    
    @objc func copyCodeOnClick(_ sender:UIButton){
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.receiveView.addressLabel.text
        SVProgressHUD.showSuccess(withStatus: LanguageHelper.getString(key: "Copy_successful"))
    }
    
    @objc func backOnClick(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
