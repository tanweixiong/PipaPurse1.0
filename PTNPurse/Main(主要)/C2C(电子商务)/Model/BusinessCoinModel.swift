//
//  BusinessModel.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class BusinessCoinModel: Mappable {
    var coinName: String?
    var id: NSNumber?
    var marketPrice:NSNumber?
    var tradeMinPrice:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        coinName        <- map["coinName"]
        id     <- map["id"]
        marketPrice     <- map["marketPrice"]
        tradeMinPrice     <- map["tradeMinPrice"]
    }
}
