//
//  AutorizeButton.swift
//  DHSWallet
//  短信验证码按钮
//  Created by zhengyi on 2017/8/14.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

let countTime = 61

class AutorizeButton: UIButton {

    var countDownTimer: Timer?
    
    var remainingSeconds: Int = 0 {
        
        willSet {
            self.setTitle("\(newValue)S", for: .normal)
            
            if newValue <= 0 {
                self.setTitle(LanguageHelper.getString(key: "login_refreshcode"), for: .normal)
                isCounting = false
            } else {
            }
            
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AutorizeButton.updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = countTime
                countDownTimer?.fire()
            } else {
                countDownTimer?.invalidate()
                countDownTimer = nil
            }
            
            if isCounting {
                Tools.setButtonType(isBoarder: true, sender: self, fontSize: 13, bgcolor: R_ZYThemeColor)
            } else {
                Tools.setButtonType(isBoarder: false, sender: self, fontSize: 13, bgcolor: R_ZYThemeColor)
            }
            
            self.isEnabled = !newValue
        }
    }
    
    func changeToOriginState() {
        
        self.remainingSeconds = 0
    }
    
    
    @objc func updateTime(_ timer: Timer) {
        
        remainingSeconds -= 1
    }
    
    /*
    func buttonClick(_ sender: UIButton) {
        
        isCounting = true
        
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        Tools.setButtonType(isBoarder: true, sender: self, fontSize: 13, bgcolor: R_ZYThemeColor)
        self.setTitle(LanguageHelper.getString(key: "register_getcode"), for: .normal)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        countDownTimer?.invalidate()
        countDownTimer = nil
    }

}
