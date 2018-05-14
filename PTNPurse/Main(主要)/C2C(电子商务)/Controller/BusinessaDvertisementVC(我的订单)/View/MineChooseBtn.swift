//
//  MineChooseBtn.swift
//  BCPPurse
//
//  Created by tam on 2018/4/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineChooseBtn: UIView {
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var titleLab: UILabel!
    static func createView()-> MineChooseBtn {
        return Bundle.main.loadNibNamed("MineChooseBtn", owner: nil, options: nil)!.last as! MineChooseBtn
    }

}
