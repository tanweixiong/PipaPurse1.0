//
//  BusinessSubmissionMsgModel.swift
//  PTNPurse
//
//  Created by tam on 2018/3/27.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class BusinessSubmissionMsgModel: Mappable {
    var remark: String?
    var date: NSNumber?
    var state: String?
    var type: NSNumber?
    var reason: String?
    var dateStr:String?
    var img1 :String?
    var img2 :String?
    var img3 :String?
    var orderNo:String?
    var id:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        remark        <- map["remark"]
        state        <- map["state"]
        date        <- map["date"]
        type        <- map["type"]
        reason        <- map["reason"]
        dateStr        <- map["dateStr"]
        
        img1        <- map["img1"]
        img2        <- map["img2"]
        img3        <- map["img3"]
        orderNo        <- map["orderNo"]
        id        <- map["id"]
    }
}
