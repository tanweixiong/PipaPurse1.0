//
//  BusinessInviteFriendsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/4/11.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class InviteFriendsModel: Mappable {
    var detail: String?
    var invitationCode: String?
    var logo: String?
    var nickname: String?
    var sumNumber: String?
    var sumPrice: String?
    var title: String?
    var url: String?
    var username: String?
    var userphoto: String?
    
    var bonusDetails:[BusinessBonusDetailsModel]?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        detail        <- map["detail"]
        invitationCode        <- map["invitationCode"]
        logo        <- map["logo"]
        nickname        <- map["nickname"]
        sumNumber        <- map["sumNumber"]
        sumPrice        <- map["sumPrice"]
        title        <- map["title"]
        url        <- map["url"]
        username        <- map["username"]
        userphoto        <- map["userphoto"]

    }
}

class BusinessBonusDetailsModel: Mappable {
    var bonusKey: String?
    var coinNo: String?
    var date: String?
    var id: NSNumber?
    var initialState: String?
    var price:NSNumber?
    var recId :String?
    var recWallet :String?
    var remark :String?
    var state:NSNumber?
    var sumNumber:NSNumber?
    var sumPrice:NSNumber?
    var userId:String?
    var username:String?
    var userphoto:String?
   
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        bonusKey        <- map["bonusKey"]
        coinNo        <- map["coinNo"]
        date        <- map["date"]
        id        <- map["id"]
        initialState        <- map["initialState"]
        price        <- map["price"]
        
        recId        <- map["recId"]
        recWallet        <- map["recWallet"]
        remark        <- map["remark"]
        state        <- map["state"]
        sumNumber        <- map["sumNumber"]
        sumPrice        <- map["sumPrice"]
        userId        <- map["userId"]
        username        <- map["username"]
        userphoto        <- map["userphoto"]
    }
}


