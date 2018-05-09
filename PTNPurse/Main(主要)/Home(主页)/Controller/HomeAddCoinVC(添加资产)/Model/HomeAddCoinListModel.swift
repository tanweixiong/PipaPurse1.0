//
//  HomeAddCoinListModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeAddCoinDataModel: Mappable {
    var userWallets: [HomeAddCoinListModel]?
    
    func mapping(map: Map) {
        userWallets     <- map["userWallets"]
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}

class HomeAddCoinListModel: Mappable {
    var type: NSNumber?
    var state: NSNumber?
    var coinName:String?
    var address:String?
    var balance:String?
    var coinImg:String?
    var coinType:String?
    var date:String?
    var id:NSNumber?
    var moneyRate:String?
    var unbalance:String?
    var userId:String?

    func mapping(map: Map) {
        type     <- map["type"]
        state     <- map["state"]
        coinName    <- map["coinName"]
        address    <- map["address"]
        balance    <- map["balance"]
        coinImg    <- map["coinImg"]
        coinType    <- map["coinType"]
        date    <- map["date"]
        id    <- map["id"]
        moneyRate    <- map["moneyRate"]
        unbalance    <- map["unbalance"]
        userId    <- map["userId"]
    }

    required init?(map: Map) {

    }

    required init?() {

    }
}


