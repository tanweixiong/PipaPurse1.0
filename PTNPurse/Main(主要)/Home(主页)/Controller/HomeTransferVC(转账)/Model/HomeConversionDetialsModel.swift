//
//  ConversionDetialsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/2/1.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeConversionDetialsModel: Mappable {
    var address: String?
    var coinName: String?
    var coinNo:NSNumber?
    var date:String?
    var id:NSNumber?
    var inCoin:NSNumber?
    var orderNo:String?
    var outCoin:NSNumber?
    var pnt:NSNumber?
    var ratio:NSNumber?
    var remark:String?
    var userId:NSNumber?
    var dateString:String?
    var coinNum:NSNumber?
    
    var outCoinName:String?
    var inCoinName:String?
    var coinFlag:NSNumber?
    
    func mapping(map: Map) {
        address     <- map["address"]
        coinName     <- map["coinName"]
        date     <- map["date"]
        id    <- map["id"]
        inCoin    <- map["inCoin"]
        orderNo    <- map["orderNo"]
        outCoin    <- map["outCoin"]
        pnt    <- map["pnt"]
        ratio    <- map["ratio"]
        remark      <- map["remark"]
        userId      <- map["userId"]
        dateString      <- map["dateString"]
        coinNum      <- map["coinNum"]
        outCoinName      <- map["outCoinName"]
        coinFlag      <- map["coinFlag"]
        inCoinName      <- map["inCoinName"]
        
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}
