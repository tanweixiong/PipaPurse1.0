
//
//  NoteTextView.swift
//  rryproject
//
//  Created by zhengyi on 2018/1/15.
//  Copyright © 2018年 inesv. All rights reserved.
//

import UIKit

typealias TextViewDidEndEditingHandle = (_ text: String) -> Void

class NoteTextView: ILXibView, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var titleString: String?
    var placeholderString: String?
    var placeholderHadClean: Bool? = false
    
    var textViewEndEditingHandle: TextViewDidEndEditingHandle?
    
    func setTextViewHandle(block: @escaping TextViewDidEndEditingHandle) {
        self.textViewEndEditingHandle = block
    }
    
    
    var shouldChangePositionByKeyboard: Bool? {
        
        didSet {
            if !(shouldChangePositionByKeyboard!) {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    var hasChangedView: Bool = false //标识是否改变的窗体位置
    var keyboardRect: CGRect = CGRect.zero //键盘位置
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        hasChangedView = false
        
        
        
        setViewBoarderCorner(radius: 5)
        textView.delegate = self
        addTextInputAccessoryView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setTitleAndPlaceHolder(title: String, placeholder: String) {
        
        
        titleString = title
        placeholderString = placeholder
        
        let text = NSMutableAttributedString.init(string: title + placeholder)
        let attrTitle = NSMutableAttributedString.init(string: title)
        let attrPlaceHolder = NSMutableAttributedString.init(string: placeholder)
        
        let titleLength = attrTitle.length
        let totall = text.length
        
        text.setAttributes([NSAttributedStringKey.foregroundColor: R_GrayColor], range: NSRange.init(location: 0, length: titleLength))
        text.setAttributes([NSAttributedStringKey.foregroundColor: R_ZYPlaceholderColor], range: NSRange.init(location: titleLength , length: totall - titleLength))
        
        textView.attributedText = text
        
    }
    
    func setPlaceholder(placeholder: String, color: UIColor) {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = color
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if (textView.text.lengthOfBytes(using: .utf8) != 0) {
            placeholderLabel.alpha = 0
        } else {
            placeholderLabel.alpha = 1
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewEndEditingHandle != nil {
            textViewEndEditingHandle!(textView.text)
        }
    }
    
    @objc func keyboardWillShown(notif: NSNotification) {
        
        let info: Dictionary = notif.userInfo!
        let value: NSValue = info[UIKeyboardFrameBeginUserInfoKey]! as! NSValue
        keyboardRect = value.cgRectValue
        self.touchInput(sender: self.textView)
    }
    
    @objc func keyboardWillHidden(notif: NSNotification) {
        
        if hasChangedView {
            hasChangedView = false
            let screenView: UIView = self.getScreenView()
            let movementDuration: CGFloat = 0.3
            UIView.beginAnimations("anim", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(TimeInterval(movementDuration))
            screenView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            UIView.commitAnimations()
        }
    }
    
    func touchInput(sender: Any) {
        
        if self.textView.isFirstResponder && keyboardRect.origin.y > 0 && hasChangedView == false {
            let screenView = self.getScreenView()
            let absRect: CGRect = screenView.convert(self.frame, from: self)
            
            if (absRect.origin.y + absRect.size.height + 45) > (screenView.frame.size.height - keyboardRect.size.height) {
                hasChangedView = true
                
                let movementDuration: CGFloat = 0.3
                let movement = (screenView.frame.size.height-keyboardRect.size.height) - ( absRect.origin.y+absRect.size.height + 45 )
                UIView.beginAnimations("anim", context: nil)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.setAnimationDuration(TimeInterval(movementDuration))
                let y = screenView.frame.origin.y + movement
                screenView.frame.origin.y = y
                
                UIView.commitAnimations()
            }
        }
    }
    
    
    
    func addTextInputAccessoryView() {
        
        let bar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        
        
        let completeBtn = UIBarButtonItem.init(title: LanguageHelper.getString(key: "login_ok"), style: .plain, target: self, action: #selector(NoteTextView.resignTextFieldResponder))
        completeBtn.setTitleTextAttributes([ NSAttributedStringKey.foregroundColor: R_UIThemeColor], for: .normal)
        let cancelBtn = UIBarButtonItem.init(title: LanguageHelper.getString(key: "login_cancle"), style: .plain, target: self, action: #selector(NoteTextView.resignTextFieldResponder))
        cancelBtn.setTitleTextAttributes([ NSAttributedStringKey.foregroundColor: R_UIThemeColor], for: .normal)
        let flexBtn = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(NoteTextView.resignTextFieldResponder))
        
        bar.setItems([cancelBtn, flexBtn, completeBtn], animated: true)
        textView.inputAccessoryView = bar
        
    }
    
    @objc func resignTextFieldResponder() {
        textView.resignFirstResponder()
    }
    
    func getScreenView() -> UIView {
        var view: UIView? = nil
        view = self.superview
        while (view != nil) && (view!.superview != nil) {
            view = view?.superview
        }
        return view!
    }

}
