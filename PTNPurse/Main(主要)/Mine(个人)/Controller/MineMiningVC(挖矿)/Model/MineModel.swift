//
//  MineModel.swift
//  PTNPurse
//
//  Created by tam on 2018/5/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper


class HomeMiningMineDetailsModel: Mappable {
    var mineDetails: [HomeMiningListModel]?
    var remarkUrl:String?
    var remark:String?
    var mineSumNum:NSNumber?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        mineDetails     <- map["mineDetails"]
        remarkUrl       <- map["remarkUrl"]
        remark       <- map["remark"]
        mineSumNum       <- map["mineSumNum"]
    }
}

class HomeMiningListModel: Mappable {
    var date: NSString?
    var dateFormat: NSString?
    var bonus:NSNumber?
    var userNo:NSNumber?
    var photo: NSString?
    var scale:NSNumber?
    var coinNo:NSNumber?
    var dateFormat1: NSString?
    var dateFormat2: NSString?
    var grade: NSString?
    var id: NSNumber?
    var state: NSNumber?
    var username: NSString?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        date     <- map["date"]
        dateFormat     <- map["dateFormat"]
        bonus    <- map["bonus"]
        userNo    <- map["userNo"]
        photo    <- map["photo"]
        scale    <- map["scale"]
        coinNo    <- map["coinNo"]
        dateFormat1    <- map["dateFormat1"]
        dateFormat2    <- map["dateFormat2"]
        grade    <- map["grade"]
        id    <- map["id"]
        state    <- map["state"]
        username    <- map["username"]
        
    }
}


class HomeMiningModel: Mappable {
    var mineRank: [HomeMiningListModel]?
    var mineList:[HomeMiningListModel]?

    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        mineRank     <- map["mineRank"]
        mineList     <- map["mineList"]
    }
}
