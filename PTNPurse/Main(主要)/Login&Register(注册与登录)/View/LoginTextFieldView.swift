//
//  LoginTextFieldView.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/10.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

public enum LoginTextfieldViewType {
    case DefaultType //左侧有视图，右侧没有按钮
    case RightBtnType //右侧有按钮，可以相应
    case SecondsCountType //右侧时间倒计时按钮
    case RightLabelAndBtnType //右侧有标签和按钮
    case DoubleBtnType //存在两个btn
}

class LoginTextFieldView: UIView , UITextFieldDelegate{
    
    // MARK: - Properties
    
    fileprivate struct ViewStyle {
        static let placeholderColor = R_GrayColor
        static let textFieldColor = UIColor.black
        static let leftFontSize: CGFloat = 13
        static let midFontSize: CGFloat = 15
        static let rightFontSize: CGFloat = 13
        static let statusViewRatio: CGFloat = 1.93
        static let leftImageHeightRatio: CGFloat = 1
        static let leftViewWidth: CGFloat = 15
        static let rightBtnHeightRatio: CGFloat = 0.4
        static let leftPaddingSpace = 0
        static let bottomPaddingSpace = 8
        static let rightBtnWidth = 90
        static let rightBtnHeight = 30

    }
    
    public var loginTextfieldViewType: LoginTextfieldViewType?
    
    public var titleLabel = UILabel()
    let textField = DHSTextField()
    public var rightBtn = UIButton()
    public var rightAutorBtn = AutorizeButton()
    public var rightLabel = UITextField()
    public var leftTitleBtn1 = UIButton()
    public var leftImageBtn1 = UIButton()
    public var leftTitleBtn2 = UIButton()
    public var leftImageBtn2 = UIButton()
    
    var bottomLine = UIView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addLeftImageAndBottomLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addLeftImageAndBottomLine()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addLeftImageAndBottomLine()
    }
}


extension LoginTextFieldView {
    
    // MARK: - Private Method
    
    fileprivate func addLeftImageAndBottomLine() {
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.bottomLine)
        self.addSubview(self.textField)
        self.titleLabel.font = UIFont.init(name: R_ThemeFontName, size: ViewStyle.leftFontSize)
        self.titleLabel.textColor = R_ZYGrayColor
        self.textField.textColor = UIColor.black
        self.textField.font = UIFont.init(name: R_ThemeFontName, size: ViewStyle.leftFontSize)
    
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(ViewStyle.leftPaddingSpace)
            make.top.equalTo(self).offset(ViewStyle.leftPaddingSpace)
            make.width.equalTo(ViewStyle.leftViewWidth)
            make.width.equalTo(self).multipliedBy(0.4)
        }
        
        self.bottomLine.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(1)
        }
        
        self.backgroundColor = UIColor.white
        bottomLine.backgroundColor = R_ZYPlaceholderColor
        self.isUserInteractionEnabled = true

    }
    
    public func addTextFieldAndRightBtn(viewType:LoginTextfieldViewType) {
        
        switch viewType {
        case LoginTextfieldViewType.DefaultType:
            
            self.textField.snp.makeConstraints({ (make) in
               make.left.equalTo(self.titleLabel.snp.left)
               make.right.equalTo(self.snp.right).offset(ViewStyle.leftPaddingSpace)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(ViewStyle.bottomPaddingSpace)
               make.height.equalTo(self).multipliedBy(0.5)
           })
            

        case LoginTextfieldViewType.RightBtnType:
            
            self.addSubview(self.rightBtn)
            rightBtn.setTitleColor(R_ZYGrayColor, for: .normal)
            rightBtn.titleLabel?.font =  UIFont.init(name: R_ThemeFontName, size: ViewStyle.leftFontSize)

            self.textField.snp.makeConstraints({ (make) in
                make.left.equalTo(self.titleLabel.snp.left)
                make.right.equalTo(self.rightBtn.snp.left).offset(ViewStyle.leftPaddingSpace)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(ViewStyle.bottomPaddingSpace)
                make.height.equalTo(self).multipliedBy(0.5)
            })
            
            self.rightBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.textField.snp.centerY)
                make.right.equalTo(self.snp.right).offset(-ViewStyle.leftPaddingSpace)
                make.height.equalTo(ViewStyle.rightBtnHeight)
                make.width.equalTo(ViewStyle.rightBtnWidth)

            })
            
            
        case LoginTextfieldViewType.SecondsCountType:
            
            self.addSubview(self.rightAutorBtn)
            self.bringSubview(toFront: self.rightAutorBtn)
            
            
            self.textField.snp.makeConstraints({ (make) in
               
                make.left.equalTo(self.titleLabel.snp.left)

                make.right.equalTo(self.rightAutorBtn.snp.left).offset(ViewStyle.leftPaddingSpace)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(ViewStyle.bottomPaddingSpace)
                make.height.equalTo(self).multipliedBy(0.5)
            })
            
            self.rightAutorBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.textField.snp.centerY)
                make.right.equalTo(self.snp.right).offset(-ViewStyle.leftPaddingSpace)
                make.height.equalTo(ViewStyle.rightBtnHeight)
                make.width.equalTo(ViewStyle.rightBtnWidth)

            })
            
            
        case .RightLabelAndBtnType:
            
            self.addSubview(self.rightBtn)
            self.addSubview(self.rightLabel)
            
            self.textField.snp.makeConstraints({ (make) in
                make.right.equalTo(self.rightBtn.snp.left).offset(ViewStyle.leftPaddingSpace)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(ViewStyle.bottomPaddingSpace)
                make.height.equalTo(self).multipliedBy(0.5)
                
            })
            
            self.rightLabel.snp.makeConstraints({ (make) in
                
                make.centerY.equalTo(self.textField.snp.centerY)
                make.right.equalTo(self.snp.right).offset(-ViewStyle.leftPaddingSpace)
                make.height.equalTo(ViewStyle.rightBtnHeight)
                
            })
            
            self.rightLabel.textColor = UIColor.black
            self.rightLabel.font = UIFont.systemFont(ofSize: ViewStyle.rightFontSize)
        case .DoubleBtnType:
            
            self.textField.isUserInteractionEnabled = false
            self.addSubview(self.leftTitleBtn1)
            self.addSubview(self.leftImageBtn1)
            self.addSubview(self.leftTitleBtn2)
            self.addSubview(self.leftImageBtn2)
            
            self.textField.snp.makeConstraints({ (make) in
                make.left.equalTo(self.titleLabel.snp.left)
                make.right.equalTo(self.snp.right).offset(ViewStyle.leftPaddingSpace)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(ViewStyle.bottomPaddingSpace)
                make.height.equalTo(self).multipliedBy(0.5)
            })
            
            self.leftTitleBtn1.snp.makeConstraints({ (make) in
                
                make.left.centerY.equalTo(self.textField)
                make.height.equalTo(20)
                
            })
            
            self.leftImageBtn1.snp.makeConstraints({ (make) in
                
                make.centerY.equalTo(self.textField)
                make.left.equalTo(self.leftTitleBtn1.snp.right).offset(5)
                make.width.equalTo(12)
                make.height.equalTo(9)
                
            })
            
            self.leftTitleBtn2.snp.makeConstraints({ (make) in
                
                make.centerY.equalTo(self.textField)
                make.left.equalTo(self.leftImageBtn1.snp.right).offset(60)
                make.height.equalTo(20)
                
            })
            
            self.leftImageBtn2.snp.makeConstraints({ (make) in
                
                make.centerY.equalTo(self.textField)
                make.left.equalTo(self.leftTitleBtn2.snp.right).offset(5)
                make.width.equalTo(12)
                make.height.equalTo(9)
                
            })
            
            self.leftTitleBtn1.titleLabel?.font = UIFont.init(name: R_ThemeFontName, size: 12)
            self.leftTitleBtn1.setTitle(LanguageHelper.getString(key: "person_apperror"), for: .normal)
            self.leftTitleBtn1.setTitle(LanguageHelper.getString(key: "person_apperror"), for: .selected)
            self.leftTitleBtn1.setTitleColor(R_ZYGrayColor, for: .normal)
            self.leftTitleBtn1.setTitleColor(R_ZYThemeColor, for: .selected)
            self.leftImageBtn1.setBackgroundImage(UIImage.init(named: "person_checkmark"), for: .selected)
            self.leftImageBtn1.setBackgroundImage(UIImage.init(named: "person_checkmark_gray"), for: .normal)
            
            self.leftTitleBtn2.titleLabel?.font = UIFont.init(name: R_ThemeFontName, size: 12)
            self.leftTitleBtn2.setTitle(LanguageHelper.getString(key: "person_proadvice"), for: .normal)
            self.leftTitleBtn2.setTitle(LanguageHelper.getString(key: "person_proadvice"), for: .selected)
            self.leftTitleBtn2.setTitleColor(R_ZYGrayColor, for: .normal)
            self.leftTitleBtn2.setTitleColor(R_ZYThemeColor, for: .selected)
            self.leftImageBtn2.setBackgroundImage(UIImage.init(named: "person_checkmark"), for: .selected)
            self.leftImageBtn2.setBackgroundImage(UIImage.init(named: "person_checkmark_gray"), for: .normal)

        }
        self.layoutIfNeeded()
    }
}

extension LoginTextFieldView {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}
