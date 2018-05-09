//
//  BusinessModel.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class BusinessModel: Mappable {
    var date: String?
    var rangeMinPrice: String?
    var entrustMaxPrice: NSNumber?
    var entrustMinPrice: NSNumber?
    var completeState: String?
    var receivablesType: NSNumber?
    var userNo: String?
    var poundage: String?
    var dateFormatDate: String?
    var entrustCoin: String?
    var remark: String?
    var coinCore: String?
    var entrustNum: NSNumber?
    var aPIType: String?
    var judgeType: String?
    var nickname: String?
    var poundageCoin: String?
    var tradeSize: String?
    var id: String?
    var state: NSNumber?
    var aPIDealNumber: String?
    var poundageScale: String?
    var remainNum: NSNumber?
    var aPIMatchNumber: String?
    var photo: String?
    var dealNum: NSNumber?
    var securityState: String?
    var matchingType: String?
    var aPIDealEditType: String?
    var rangeMaxPrice: String?
    var matchNum: String?
    var aPIMatchEditType: String?
    var minPrice: String?
    var entrustPrice: NSNumber?
    var entrustRange: String?
    var entrustType: String?
    var maxPrice: String?
    var conductState: String?
    var username: String?
    
    var entrustNo:String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        date        <- map["date"]
        rangeMinPrice     <- map["rangeMinPrice"]
        entrustMaxPrice        <- map["entrustMaxPrice"]
        entrustMinPrice        <- map["entrustMinPrice"]
        completeState      <- map["completeState"]
        receivablesType        <- map["receivablesType"]
        userNo        <- map["userNo"]
        poundage        <- map["poundage"]
        dateFormatDate        <- map["dateFormatDate"]
        entrustCoin        <- map["entrustCoin"]
        remark        <- map["remark"]
        coinCore        <- map["coinCore"]
        entrustNum        <- map["entrustNum"]
        aPIType        <- map["aPIType"]
        judgeType        <- map["judgeType"]
        nickname        <- map["nickname"]
        poundageCoin        <- map["poundageCoin"]
        tradeSize        <- map["tradeSize"]
        id        <- map["id"]
        photo        <- map["photo"]
        entrustNum        <- map["entrustNum"]
        username        <- map["username"]
        entrustMaxPrice        <- map["entrustMaxPrice"]
        entrustPrice        <- map["entrustPrice"]
        remainNum        <- map["remainNum"]
        entrustNo        <- map["entrustNo"]

    }
}
