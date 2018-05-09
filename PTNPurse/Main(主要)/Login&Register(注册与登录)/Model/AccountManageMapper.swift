//
//  AccountManageMapper.swift
//  rryproject
//
//  Created by zhengyi on 2018/1/16.
//  Copyright © 2018年 inesv. All rights reserved.
//

import UIKit
import ObjectMapper

class NodataResponse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: String?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}

class LoginResponse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: UserInfoData?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}

class TradePwdFlag: Mappable {
    var flag: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        flag                <- map["flag"]
    }
}

class UserInfoData: Mappable {
    var date: String?
    var id: Int?
    var nickname: String?
    var password: String?
    var photo: String?
    var state: Int?
    var timeout: String?
    var tradePassword: String?
    var username: String?
    var token: String?
    
    var ptnaddress:String?
    var language:String?
    
    var address:String?
    
    required init?(map: Map) {
        
    }
    
    init?() {
        
    }
    
    func mapping(map: Map) {
        date                <- map["date"]
        id             <- map["id"]
        nickname                <- map["nickname"]
        username             <- map["username"]
        token                <- map["token"]
        password                <- map["password"]
        photo             <- map["photo"]
        state                <- map["state"]
        timeout             <- map["timeout"]
        tradePassword                <- map["tradePassword"]
        
        ptnaddress              <- map["ptnaddress"]
        language                <- map["language"]
        
        address                <- map["address"]
    }
}

class UserWallet: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
    }
}

class FriendsRespondse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: [Friend]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}


class Friend: Mappable {
    var name: String?
    var photo: String?
    var id: Int?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name                <- map["name"]
        photo             <- map["photo"]
        id             <- map["id"]

    }
}



class VersionRespondse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: Version?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}

class Version: Mappable {
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

class InfoRespondse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: PageInfo?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}

class PageInfo: Mappable {
    
    var pageInfo: InformationData?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        pageInfo                <- map["pageInfo"]
       
    }
}

class InformationData: Mappable {
    var pageNum: Int?
    var pageSize: Int?
    var size: Int?
    var orderBy: String?
    var startRow: Int?
    var endRow: Int?
    var total: Int?
    var pages: Int?
    var list: [Information]?
    var isLastPage: Bool?
    var hasNextPage: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        pageNum                <- map["pageNum"]
        pageSize             <- map["pageSize"]
        size             <- map["size"]
        orderBy                <- map["orderBy"]
        startRow             <- map["startRow"]
        endRow             <- map["endRow"]
        total             <- map["total"]
        pages             <- map["pages"]
        list             <- map["list"]
        isLastPage             <- map["isLastPage"]
        hasNextPage             <- map["hasNextPage"]
        
    }
}


class Information: Mappable {
    var newsTitle: String?
    var newsText: String?
    var createTime: Int?
    var id: Int?
    var adminId: Int?
    var newsUrl: String?
    var newsImg: String?
    var newsLangue: Int?
    var newsSummary: String?

    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        newsTitle                <- map["newsTitle"]
        newsText                 <- map["newsText"]
        createTime             <- map["createTime"]
        adminId                <- map["adminId"]
        id                  <- map["id"]
        newsUrl             <- map["newsUrl"]
        newsImg             <- map["newsImg"]
        newsLangue          <- map["newsLangue"]
        newsSummary          <- map["newsSummary"]
    }
}


class HadSetTradePwdResponse: Mappable {
    var code: Int?
    var message: String?
    var page: Int?
    var data: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code                <- map["code"]
        message             <- map["message"]
        page                <- map["page"]
        data             <- map["data"]
    }
}

