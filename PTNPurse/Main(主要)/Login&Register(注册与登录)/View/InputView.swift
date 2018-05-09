//
//  InputView.swift
//  AGTMall
//
//  Created by tam on 2017/10/17.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class InputView: UIView,UITextFieldDelegate {
    
    struct InputViewUX {
        static let iconImageSize:Float = 30
        static let inputTFHeight:Float = 120
        static let placeholderFont:Float = 14
    }
    
    // MARK: - OverrideMethod
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func createUI(){
        
        self.backgroundColor = UIColor.clear
        
        let layers = CALayer()
        layers.frame = CGRect(x: 0 , y: self.frame.size.height, width: self.frame.size.width  ,height:0.5)
        layers.backgroundColor  = UIColor.R_UIColorFromRGB(color: 0xdddddd).cgColor
        self.layer.addSublayer(layers)

//        self.addSubview(placeholderLabel)
        self.addSubview(AGTextField)
    }
    
    lazy var iconImageView :UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
//    lazy var placeholderLabel :UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = UIColor.R_UIRGBColor(red: 255, green: 255, blue: 255, alpha: 1)
//        label.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        return label
//    }()
    
    lazy var AGTextField :UITextField = {
        let textField  = UITextField()
        textField.delegate = self
        textField.font = UIFont.systemFont(ofSize: CGFloat(InputViewUX.placeholderFont))
        textField.textColor = UIColor.white
        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//        textField.setValue(UIColor.R_UIRGBColor(red: 207, green: 207, blue: 207, alpha: 1), forKeyPath: "_placeholderLabel.textColor")
//        textField.backgroundColor = UIColor.white
        return textField
    }()

}
