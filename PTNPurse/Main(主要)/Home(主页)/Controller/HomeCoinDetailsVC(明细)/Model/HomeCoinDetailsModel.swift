//
//  HomeCoinDetailsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/29.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeCoinDetailsModel: Mappable {
    var id: NSNumber?
    var userId: NSNumber?
    var coinNo:NSNumber?
    var type:NSNumber?
    var orderNo:String?
    var tradeNum:NSNumber?
    var state:NSNumber?
    var ratio:NSNumber?
    var remark:String?
    var date:String?
    var dateFormat:String?
    var changeFlag:NSNumber?
    var coinName:String?
    
    var outName:String?
    var dataString:String?
    
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        id     <- map["id"]
        userId     <- map["userId"]
        coinNo    <- map["coinNo"]
        type    <- map["type"]
        orderNo    <- map["orderNo"]
        tradeNum    <- map["tradeNum"]
        state    <- map["state"]
        ratio    <- map["ratio"]
        remark    <- map["remark"]
        date    <- map["date"]
        dateFormat    <- map["dateFormat"]
        changeFlag    <- map["changeFlag"]
        coinName    <- map["coinName"]
        outName    <- map["outName"]
        dataString    <- map["dataString"]
        
    }
}
