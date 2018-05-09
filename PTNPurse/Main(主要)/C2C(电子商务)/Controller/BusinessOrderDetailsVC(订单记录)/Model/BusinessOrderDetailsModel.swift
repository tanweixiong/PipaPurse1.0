//
//  BusinessOrderDetailsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class BusinessOrderDetailsModel: Mappable {
    var date: String?
    var dealType: NSNumber?
    var sumPrice: String?
    var buyEntrust: String?
    var completeState: String?
    var userNo: String?
    var poundage: NSNumber?
    var dateFormatDate: String?
    var sellUserPhoto: String?
    var dealPrice: NSNumber?
    
    var coinNo: String?
    var buyUserPhoto: String?
    var coinCore: String?
    var dateType: String?
    
    var poundageCoin: String?
    var id: String?
    
    var poundageScale: String?
    var orderNo: String?
    var photo: String?
    var dealNum: NSNumber?
    var attr2: String?
    var buyUserNo: String?
    var attr1: String?
    var sellEntrust: String?
    
    var sellUserNo: String?
    var buyUserName: String?
    var matchNo: String?
    var entrustPrice: String?
    var conductState: String?
    var sellUserName: String?
    var username: String?
    
    var minerFee:NSNumber?
    
    var remark:String?
    
    var state:NSNumber?
    
    var buyAccount:String?
    var sellAccount:String?
    var receivablesType:NSNumber?
    
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        
        date        <- map["date"]
        dealType     <- map["dealType"]
        sumPrice        <- map["sumPrice"]
        buyEntrust      <- map["buyEntrust"]
        completeState        <- map["completeState"]
        
        
        userNo        <- map["userNo"]
        poundage        <- map["poundage"]
        dateFormatDate        <- map["dateFormatDate"]
        
        
        sellUserPhoto        <- map["sellUserPhoto"]
        dealPrice        <- map["dealPrice"]
        
        
        coinNo        <- map["coinNo"]
        buyUserPhoto        <- map["buyUserPhoto"]
        coinCore        <- map["coinCore"]
        dateType        <- map["dateType"]
        poundageCoin        <- map["poundageCoin"]
        id        <- map["id"]
        poundageScale        <- map["poundageScale"]
        orderNo        <- map["orderNo"]
        photo        <- map["photo"]
        dealNum        <- map["dealNum"]
        attr2        <- map["attr2"]
        buyUserNo        <- map["buyUserNo"]
        attr1        <- map["attr1"]
        sellEntrust        <- map["sellEntrust"]
        sellUserNo        <- map["sellUserNo"]
        buyUserName        <- map["buyUserName"]
         matchNo        <- map["matchNo"]
         entrustPrice        <- map["entrustPrice"]
         conductState        <- map["conductState"]
         sellUserName        <- map["sellUserName"]
         username        <- map["username"]
        
         minerFee        <- map["minerFee"]
        
         remark        <- map["remark"]
        
         state        <- map["state"]
        
        buyAccount        <- map["buyAccount"]
        sellAccount        <- map["sellAccount"]
        receivablesType        <- map["receivablesType"]

    }
}

class BusinessHisteryDetailsModel: Mappable {
    var date: String?
    var dealType: String?
    var sumPrice: String?
    var buyEntrust: String?
    
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        date        <- map["date"]
        dealType     <- map["dealType"]
        sumPrice        <- map["sumPrice"]
        buyEntrust      <- map["buyEntrust"]

    }
}
