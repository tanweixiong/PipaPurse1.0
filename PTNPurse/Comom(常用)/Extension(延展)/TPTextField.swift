//
//  TPTextField.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/23.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit

class TPTextField: UITextField {

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect:CGRect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= XMAKE(5)
        return rect
    }
}
