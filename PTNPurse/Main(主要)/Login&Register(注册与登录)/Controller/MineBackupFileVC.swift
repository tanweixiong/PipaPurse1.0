//
//  MineBackupFileVC.swift
//  PTNPurse
//
//  Created by tam on 2018/1/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class MineBackupFileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backupView)
    }
    
    lazy var backupView: MineBackupFileView = {
        let view = Bundle.main.loadNibNamed("HomeHeadView", owner: nil, options: nil)?.last as! MineBackupFileView
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height:250)
        return view
    }()
}
