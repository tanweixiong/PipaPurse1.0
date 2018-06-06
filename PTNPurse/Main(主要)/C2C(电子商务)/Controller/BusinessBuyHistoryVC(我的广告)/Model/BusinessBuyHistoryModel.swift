//
//  BusinessBuyHistoryModel.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class BusinessBuyHistoryModel: Mappable {
    var photo: String?
    var username: String?
    
    var entrustMaxPrice:NSNumber?//最大限额
    var entrustMinPrice:NSNumber?//最小限额
    var coinCore:String?
    var entrustNum:NSNumber? //交易总数量
    var entrustNo:String?
    var dealNum:NSNumber? //交易总数量
    var entrustPrice:NSNumber? //交易价格
    var matchNum:NSNumber?
    
    var date:String?
    var state:NSNumber?
    
    var id:NSNumber?
    
    var receivablesType:NSNumber?

    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        photo        <- map["photo"]
        username        <- map["username"]
        entrustMaxPrice        <- map["entrustMaxPrice"]
        entrustMinPrice        <- map["entrustMinPrice"]
        coinCore        <- map["coinCore"]
        entrustNum        <- map["entrustNum"]
        dealNum         <- map["dealNum"]
        entrustPrice    <- map["entrustPrice"]
        matchNum        <- map["matchNum"]
        date        <- map["date"]
        state        <- map["state"]
        entrustNo        <- map["entrustNo"]
        id        <- map["id"]
        receivablesType        <- map["receivablesType"]
   
    }
}

class BusinessBuyFinishModel: Mappable {
    var data: BusinessBuyFinishDataModel?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        data        <- map["data"]
    }
}

class BusinessBuyFinishDataModel: Mappable {
    var orderId: NSNumber?
    var phone :NSNumber?
    var tradePrice:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        orderId        <- map["orderId"]
        phone        <- map["phone"]
        tradePrice        <- map["tradePrice"]
    }
}

class BusinessLiberateFinishModel: Mappable {
    var data: BusinessLiberateFinishDataModel?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        data        <- map["data"]
    }
}

class BusinessLiberateFinishDataModel: Mappable {
    var entrustId: NSNumber?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        entrustId        <- map["entrustId"]
    }
}
