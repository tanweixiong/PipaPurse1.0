//
//  HomeConvertModel.swift
//  PipaPurse
//
//  Created by tam on 2018/5/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeConvertModel: Mappable {
    var coinImg:String?
    var totalbalance:NSNumber?
    var fakebalance:NSNumber?
    var coinCore:String?
    var changeList:[HomeConvertListModel]?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        coinImg     <- map["coinImg"]
        coinCore     <- map["coinCore"]
        totalbalance     <- map["totalbalance"]
        fakebalance     <- map["fakebalance"]
        changeList     <- map["changeList"]
    }
}

class HomeConvertListModel: Mappable {
    var id:NSNumber?
    var orderNo:String?
    var userNo:NSNumber?
    var coinNo:NSNumber?
    var number:NSNumber?
    var address:String?
    var remark:String?
    var date:String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        id     <- map["id"]
        orderNo     <- map["orderNo"]
        userNo     <- map["userNo"]
        coinNo     <- map["coinNo"]
        number     <- map["number"]
        address     <- map["address"]
        remark     <- map["remark"]
        address     <- map["address"]
        date     <- map["date"]
    }
}
