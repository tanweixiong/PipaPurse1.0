//
//  HomeConversionListModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeConversionDataModel: Mappable {
    var data:[HomeConversionListModel]?
    
    func mapping(map: Map) {
        data     <- map["data"]
      
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}

class HomeConversionListModel: Mappable {
    var id: NSNumber?
    var coinNo: NSNumber?
    var coinName:String?
    var coinPriceBySys:NSNumber?
    var coinPrice:NSNumber?
    var coinImg:String?
    var coinBlock:NSNumber?
    
    func mapping(map: Map) {
        id     <- map["id"]
        coinNo     <- map["coinNo"]
        coinName     <- map["coinName"]
        coinPriceBySys    <- map["coinPriceBySys"]
        coinPrice    <- map["coinPrice"]
        coinImg    <- map["coinImg"]
        coinBlock    <- map["coinBlock"]
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}
