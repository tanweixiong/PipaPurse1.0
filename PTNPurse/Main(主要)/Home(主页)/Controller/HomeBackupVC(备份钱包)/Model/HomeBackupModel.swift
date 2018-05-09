//
//  HomeBackupDetailsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/27.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper
//备份钱包
class HomeBackupModel: Mappable {
    var data: [HomeBackupListModel]?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {

        data        <- map["data"]
    }
}

class HomeBackupListModel: Mappable {
    var id: NSNumber?
    var userId: String?
    var address: String?
    var type: String?
    var state: String?
    var balance: String?
    var unbalance: String?
    var date: String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        userId     <- map["userId"]
        address        <- map["address"]
        type        <- map["type"]
        state     <- map["state"]
        balance        <- map["balance"]
        unbalance        <- map["unbalance"]
        date     <- map["date"]
    }
}

//新增钱包地址
class HomeBackupAddressModel: Mappable {
    var data: [HomeBackupAddressListModel]?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        data        <- map["data"]
    }
}

class HomeBackupAddressListModel: Mappable {
    var address: String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        address        <- map["address"]
    }
}

//获取助记词
class HomeBackupMemoModel: Mappable {
    var data: [HomeBackupMemoListModel]?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        data        <- map["data"]

    }
}

class HomeBackupMemoListModel: Mappable {
    var id: NSNumber?
    var memo: String?
    var date: String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        id        <- map["id"]
        memo     <- map["memo"]
        date        <- map["date"]
    }
}

