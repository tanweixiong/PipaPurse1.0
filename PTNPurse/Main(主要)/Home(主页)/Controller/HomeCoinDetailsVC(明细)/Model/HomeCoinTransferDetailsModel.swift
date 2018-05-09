//
//  HomeCoinTransferDetailsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/29.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeCoinTransferDetailsModel: Mappable {
    var address: String?
    var changeFlag: NSNumber?
    var coinName:String?
    var coinNum:NSNumber?
    var date:String?
    var dateString:String?
    var id:NSNumber?
    var inCoin:NSNumber?
    var inCoinName:String?
    var orderNo:String?
    var outCoin:NSNumber?
    var outCoinName:String?
    var pnt:NSNumber?
    var ratio:NSNumber?
    var remark:String?
    var userId:NSNumber?
    
    var percentage:NSNumber?
    var flag:NSNumber?
    var frozenAssets:NSNumber?
    var available:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        address     <- map["address"]
        changeFlag     <- map["changeFlag"]
        coinName    <- map["coinName"]
        coinNum    <- map["coinNum"]
        date    <- map["date"]
        dateString    <- map["dateString"]
        id    <- map["id"]
        inCoin    <- map["inCoin"]
        inCoinName    <- map["inCoinName"]
        orderNo    <- map["orderNo"]
        outCoin    <- map["outCoin"]
        outCoinName    <- map["outCoinName"]
        pnt    <- map["pnt"]
        ratio    <- map["ratio"]
        remark    <- map["remark"]
        userId    <- map["userId"]
        
        percentage    <- map["percentage"]
        flag    <- map["flag"]
        frozenAssets    <- map["frozenAssets"]
        available    <- map["available"]
    }
}
