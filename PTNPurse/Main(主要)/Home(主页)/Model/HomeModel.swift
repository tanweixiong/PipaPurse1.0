
//  HomeModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/25.
//  Copyright © 2018年 Wilkinson. All rights reserved.

import ObjectMapper

class HomeModel: Mappable {
    var langue: NSNumber?
    var totalMoney: NSNumber?
    var balanceState: NSNumber?
    var userWallets: [HomeWalletsModel]?

    required init?(map: Map) {

    }

    required init?() {

    }

    func mapping(map: Map) {
        langue        <- map["langue"]
        totalMoney     <- map["totalMoney"]
        userWallets     <- map["userWallets"]
        balanceState     <- map["balanceState"]
    }
}

class HomeWalletsModel: Mappable {
    var address: String?
    var balance: NSNumber?
    var coinName:String?
    var coinType:NSNumber?
    var date:String?
    var id:String?
    var moneyRate:NSNumber?
    var state:NSNumber?
    var type:NSNumber?
    var userId:NSNumber?
    var photo:String?
    var coinImg:String?
    var totalBalance:NSNumber?
    
    var enableBalance:String?
    var unableBalance:String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        address     <- map["address"]
        balance     <- map["balance"]
        coinName    <- map["coinName"]
        coinType    <- map["coinType"]
        date        <- map["date"]
        id          <- map["id"]
        moneyRate   <- map["moneyRate"]
        state       <- map["state"]
        type        <- map["type"]
        userId      <- map["userId"]
        photo        <- map["photo"]
        coinImg        <- map["coinImg"]
        totalBalance        <- map["totalBalance"]
        
        enableBalance        <- map["enableBalance"]
        unableBalance        <- map["unableBalance"]
    }
}

class HomeDetailsModel: Mappable {
    var Money: NSNumber?
    var langue: NSString?
    var userWallet:HomeWalletsModel?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        Money     <- map["Money"]
        langue     <- map["langue"]
        userWallet    <- map["userWallet"]

    }
}


class HomeImprotWalletBaseModel: Mappable {
    var code: NSNumber?
    var data:[HomeImprotWalletModel]?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        code     <- map["code"]
        data     <- map["data"]
        message     <- map["message"]
    }
}

class HomeImprotWalletModel: Mappable {
    var address: String?
    var balance: NSNumber?
    var coinImg:String?
    var coinName:String?
    var coinType:String?
    var date:String?
    var flag:String?
    var id:String?
    var moneyRate:String?
    var state:String?
    var totalBalance:String?
    var type:NSNumber?
    var unbalance:String?
    var userId:String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        address     <- map["address"]
        balance     <- map["balance"]
        coinImg    <- map["coinImg"]
        coinName    <- map["coinName"]
        coinType    <- map["coinType"]
        coinName    <- map["coinName"]
        date    <- map["date"]
        flag    <- map["flag"]
        id    <- map["id"]
         moneyRate    <- map["moneyRate"]
         state    <- map["state"]
         totalBalance    <- map["totalBalance"]
        type    <- map["type"]
        unbalance    <- map["unbalance"]
        userId    <- map["userId"]
    }
}

