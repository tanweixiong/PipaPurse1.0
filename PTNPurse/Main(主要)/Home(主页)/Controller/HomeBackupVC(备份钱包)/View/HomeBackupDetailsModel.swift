//
//  HomeBackupDetailsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/25.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeBackupDetailsModel: NSObject {
    var name:String?
    var tag:Int?
    
    init(name:String,tag:NSInteger) {
        self.name = name
        self.tag = tag
    }
    
}
