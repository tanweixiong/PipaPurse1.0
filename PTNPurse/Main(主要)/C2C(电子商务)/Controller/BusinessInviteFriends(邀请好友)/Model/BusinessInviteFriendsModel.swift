//
//  BusinessInviteFriendsModel.swift
//  PTNPurse
//
//  Created by tam on 2018/4/11.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class BusinessInviteFriendsModel: Mappable {
    var userphoto: String?
    var sumPrice: String?
    var nickname: String?
    var sumNumber: String?
    var logo: String?
    var detail:String?
    var title :String?
    var invitationCode :String?
    var url :String?
    var username:String?
   
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        userphoto        <- map["userphoto"]
        sumPrice        <- map["sumPrice"]
        nickname        <- map["nickname"]
        sumNumber        <- map["sumNumber"]
        logo        <- map["logo"]
        detail        <- map["detail"]
        title        <- map["title"]
        invitationCode        <- map["invitationCode"]
        url        <- map["url"]
        username        <- map["username"]
    }
}

class BusinessInviteListModel: Mappable {
    var date: String?
    var userphoto: String?
    var bonusKey: String?
    var initialState: String?
    var sumPrice: String?
    
    var remark:String?
    var userId :NSNumber?
    var coinNo :NSNumber?
    
    var recWallet :String?
    var price:NSNumber?
    
    var sumNumber :String?
    var id :NSNumber?
    var state :NSNumber?
    var recId :NSNumber?
    
    var username :String?
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        date        <- map["date"]
        userphoto        <- map["userphoto"]
        bonusKey        <- map["bonusKey"]
        initialState        <- map["initialState"]
        sumPrice        <- map["sumPrice"]
        remark        <- map["remark"]
        userId        <- map["userId"]
        coinNo        <- map["coinNo"]
        
        recWallet        <- map["recWallet"]
        price        <- map["price"]
        sumNumber        <- map["sumNumber"]
        id        <- map["id"]
        state        <- map["state"]
        recId        <- map["recId"]
        username        <- map["username"]
    }
}
