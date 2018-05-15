//
//  MineBindingBankModel.swift
//  PTNPurse
//
//  Created by tam on 2018/4/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class MineBindingBankModel: Mappable {
    var address: String?
    var bank: String?
    var branch:String?
    var code:String?
    var date:String?
    var id:NSNumber?
    var name:String?
    var state:NSNumber?
    var userId:NSNumber?
    
    func mapping(map: Map) {
        address     <- map["address"]
        bank     <- map["bank"]
        branch     <- map["branch"]
        code    <- map["code"]
        date    <- map["date"]
        id    <- map["id"]
        name    <- map["name"]
        state    <- map["state"]
        userId    <- map["userId"]
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}


