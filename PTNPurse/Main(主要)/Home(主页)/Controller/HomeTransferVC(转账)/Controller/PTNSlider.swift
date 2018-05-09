//
//  PTNSlider.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class PTNSlider: UISlider {
    fileprivate let silder:CGFloat = 15

    override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.size.height = silder
        return rect
    }

    override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.size.height = silder
        return rect
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.size.height = silder
        return rect
    }

}
