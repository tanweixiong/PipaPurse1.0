//
//  HomeTransferDetailsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/31.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeTransferDetailsModel: Mappable {
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
    var inAddress:String?
    var outAddress:String?
    
    var ratioCore:String?
    
    func mapping(map: Map) {
        id     <- map["id"]
        userId     <- map["userId"]
        coinNo     <- map["coinNo"]
        type    <- map["type"]
        orderNo    <- map["orderNo"]
        tradeNum    <- map["tradeNum"]
        state    <- map["state"]
        ratio    <- map["ratio"]
        remark    <- map["remark"]
        date      <- map["date"]
        dateFormat      <- map["dateFormat"]
        inAddress      <- map["inAddress"]
        outAddress      <- map["outAddress"]
        ratioCore      <- map["ratioCore"]
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}

class HomeConversionDetailsModel: Mappable {
    var id: NSNumber?
    var userId: NSNumber?
    var coinName:String?
    var coinNum:NSNumber?
    var orderNo:String?
    var pnt:NSNumber?
    var address:String?
    var ratio:NSNumber?
    var remark:String?
    var date:NSNumber?
    var inCoin:NSNumber?
    var outCoin:NSNumber?
    var dateString:String?
    
    func mapping(map: Map) {
        id     <- map["id"]
        userId     <- map["userId"]
        coinName     <- map["coinName"]
        coinNum     <- map["coinNum"]
        orderNo     <- map["orderNo"]
        pnt     <- map["pnt"]
        address     <- map["address"]
        ratio     <- map["ratio"]
        remark     <- map["remark"]
        date     <- map["date"]
        inCoin     <- map["inCoin"]
        outCoin     <- map["outCoin"]
        dateString     <- map["dateString"]

    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}

class HomeTransferFinishModel: Mappable {
    var code: NSNumber?
    var data: NSNumber?
    var message:String?
    var page:NSNumber?

    
    func mapping(map: Map) {
        code     <- map["code"]
        data     <- map["data"]
        message     <- map["message"]
        page    <- map["page"]
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}
