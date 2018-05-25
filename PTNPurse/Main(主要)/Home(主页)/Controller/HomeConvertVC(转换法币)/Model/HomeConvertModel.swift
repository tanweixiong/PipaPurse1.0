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
    var changeList:String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        coinImg     <- map["coinImg"]
        totalbalance     <- map["totalbalance"]
        fakebalance     <- map["fakebalance"]
        changeList     <- map["changeList"]
    }
}

class HomeConvertListModel: Mappable {
    var coinImg:String?
    var totalbalance:NSNumber?
    var fakebalance:NSNumber?
    var changeList:String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        coinImg     <- map["coinImg"]
        totalbalance     <- map["totalbalance"]
        fakebalance     <- map["fakebalance"]
        changeList     <- map["changeList"]
    }
}
