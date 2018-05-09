//
//  WalletAddressModel.swift
//  rryproject
//
//  Created by zhengyi on 2018/1/14.
//  Copyright © 2018年 inesv. All rights reserved.
//

import UIKit
import ObjectMapper

class WalletAddress: Mappable {
    var id: Int?
    var userId: Int?
    var price: Double?
    var address: String?
    var name: String?
    var remark: String?
    var date: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id    <- map["id"]
        userId            <- map["userId"]
        price    <- map["price"]
        address            <- map["address"]
        name    <- map["name"]
        remark            <- map["remark"]
        date            <- map["date"]
    }
    
    init() {
    
    }
}

class TradeRecord: Mappable {

    var date: String?
    var address: String?
    var price: Double?
    var username: String?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        date    <- map["date"]
        address            <- map["address"]
        price             <- map["price"]
        username             <- map["username"]

    }
}


class WalletAddressListRespondse: Mappable {
    var page: Int?
    var code: Int?
    var data: [WalletAddress]?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page    <- map["page"]
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }

}

class TradeRecordListRespondse: Mappable {
    var page: Int?
    var code: Int?
    var data: [TradeRecord]?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page    <- map["page"]
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }
    
}

class TradeUserListRespondse: Mappable {
    var page: Int?
    var code: Int?
    var data: [TradeUser]?
    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page    <- map["page"]
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }
    
}

class TradeUser: Mappable {
    var name: String?
    var id: Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name    <- map["name"]
        id    <- map["id"]
      
    }
    
}

class UserBalanceRespondse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: UserBalance?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}

class TransferFeeRespondse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: TransferFee?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}

class TransferFee: Mappable {
    var price: Double?
    var fee: String?
    var userWalletList: [WalletAddress]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        price                <- map["price"]
        fee             <- map["fee"]
        userWalletList                <- map["userWalletList"]
    }
    
}

class UserBalance: Mappable {
    var price: Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        price                <- map["price"]
    }
}


class News: Mappable {
    var id: Int?
    var version: String?
    var versionName: String?
    var versionUrl: String?
    var date: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        version             <- map["version"]
        versionName         <- map["versionName"]
        versionUrl          <- map["versionUrl"]
        date                <- map["date"]
    }
}





