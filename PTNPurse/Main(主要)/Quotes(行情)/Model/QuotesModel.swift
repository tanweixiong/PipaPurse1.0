//
//  QuotesModel.swift
//  PTNPurse
//
//  Created by tam on 2018/3/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class QuotesDetsilsModel: Mappable {
    var high: NSNumber?
    var vol: NSNumber?
    var last: NSNumber?
    var low: NSNumber?
    var price: NSNumber?
    var buy: NSNumber?
    var sell: NSNumber?
    var range: String?
    var state: NSNumber?
    var priceBySys: NSNumber?
    var coinIcon:NSString?

    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        high        <- map["high"]
        vol     <- map["vol"]
        last        <- map["last"]
        low        <- map["low"]
        price        <- map["price"]
        buy        <- map["buy"]
        sell        <- map["sell"]
        range        <- map["range"]
        state        <- map["state"]
        priceBySys        <- map["priceBySys"]
        coinIcon        <- map["coinIcon"]

    }
}

class QuotesModel: Mappable {
    var id: NSNumber?
    var coinNo: NSNumber?
    var coinIcon: String?
    var coinPriceBySys: NSNumber?
    var coinPrice: NSNumber?
    var coinName: String?
    var coinImg: String?
    var coinType:NSNumber?
    var coinBlock:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        coinIcon        <- map["coinIcon"]
        coinNo     <- map["coinNo"]
        coinName        <- map["coinName"]
        coinPriceBySys        <- map["coinPriceBySys"]
        coinPrice        <- map["coinPrice"]
        coinImg        <- map["coinImg"]
        coinType        <- map["coinType"]
        coinBlock        <- map["coinBlock"]
    }
}
