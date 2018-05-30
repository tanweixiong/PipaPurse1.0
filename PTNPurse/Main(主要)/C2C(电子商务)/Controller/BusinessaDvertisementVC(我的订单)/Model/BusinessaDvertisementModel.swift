//
//  BusinessaDvertisementModel.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class BusinessaDvertisementModel: Mappable {
    var photo: String?
    var username: String?
    var orderNo:String?
    var dealPrice:NSNumber?// 交易金额-单价
    var dealNum:NSNumber?//交易数量
    var coinCore:String? //货币英文名称
    var dateFormatDate:String?//时间
    var dealType:NSNumber?//0购买 1出售
    var state:NSNumber?//状态
    var id:NSNumber?
    var sumPrice:NSNumber?
    var entrustNo:String?
    var receivablesType:NSNumber?
    var paymentCode:String?

    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        photo        <- map["photo"]
        username        <- map["username"]
        orderNo        <- map["orderNo"]
        dealPrice        <- map["dealPrice"]
        dealNum        <- map["dealNum"]
        coinCore        <- map["coinCore"]
        dateFormatDate        <- map["dateFormatDate"]
        dealType        <- map["dealType"]
        state        <- map["state"]
        id        <- map["id"]
        sumPrice        <- map["sumPrice"]
        entrustNo        <- map["entrustNo"]
        receivablesType        <- map["receivablesType"]
        paymentCode        <- map["paymentCode"]
    }
}
