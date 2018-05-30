//
//  UserInfo.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/22.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

class UserInfo: NSObject,NSCoding {
    @objc var date: AnyObject?
    @objc var id: NSNumber?
    @objc var nickname: AnyObject?
    @objc var password: AnyObject?
    @objc var photo: AnyObject?
    @objc var state: NSNumber?
    @objc var timeout: AnyObject?
    @objc var tradePassword: String?
    @objc var username: AnyObject?
    @objc var token: String?
    @objc var ptnaddress: String?
    @objc var language: AnyObject?
    @objc var pTNAddress: AnyObject?
    
    @objc var apay: String?
    @objc var weChat: String?
    
    @objc var invitationCode: AnyObject?
    @objc var address: String?
    
    @objc var tradePasswordState:NSNumber?
    @objc var phone:String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey:"date")
        aCoder.encode(id, forKey:"id")
        aCoder.encode(nickname, forKey:"nickname")
        aCoder.encode(password, forKey:"password")
        aCoder.encode(photo, forKey:"photo")
        aCoder.encode(state, forKey:"state")
        aCoder.encode(timeout, forKey:"timeout")
        aCoder.encode(tradePassword, forKey:"tradePassword")
        aCoder.encode(username, forKey:"username")
        aCoder.encode(token, forKey:"token")
        aCoder.encode(ptnaddress, forKey:"ptnaddress")
        aCoder.encode(language, forKey:"language")
        
        aCoder.encode(pTNAddress, forKey:"pTNAddress")
        
        aCoder.encode(apay, forKey:"apay")
        aCoder.encode(weChat, forKey:"weChat")
        aCoder.encode(invitationCode, forKey:"invitationCode")
        
        aCoder.encode(address, forKey:"address")
        aCoder.encode(tradePasswordState, forKey:"tradePasswordState")
        aCoder.encode(phone, forKey:"phone")
    }
    
    required init?(coder aDecoder: NSCoder) {
      self.date = aDecoder.decodeObject(forKey: "date") as AnyObject
      self.id = aDecoder.decodeObject(forKey: "id") as? NSNumber ?? 0
      self.nickname = aDecoder.decodeObject(forKey: "nickname") as AnyObject
      self.password = aDecoder.decodeObject(forKey: "password") as AnyObject
      self.photo = aDecoder.decodeObject(forKey: "photo") as AnyObject
      self.state = aDecoder.decodeObject(forKey: "state") as? NSNumber ?? 0
      self.timeout = aDecoder.decodeObject(forKey: "state") as AnyObject
      self.tradePassword = aDecoder.decodeObject(forKey: "tradePassword") as? String
      self.username = aDecoder.decodeObject(forKey: "username") as AnyObject
        self.token = aDecoder.decodeObject(forKey: "token") as? String
      self.ptnaddress = aDecoder.decodeObject(forKey: "ptnaddress") as? String
      self.language = aDecoder.decodeObject(forKey: "language") as AnyObject
        
      self.pTNAddress = aDecoder.decodeObject(forKey: "pTNAddress") as AnyObject
        
        self.weChat = aDecoder.decodeObject(forKey: "weChat") as? String
        self.apay = aDecoder.decodeObject(forKey: "apay") as? String
        
        self.invitationCode = aDecoder.decodeObject(forKey: "invitationCode") as AnyObject
        self.address = aDecoder.decodeObject(forKey: "address") as? String
        self.tradePasswordState = aDecoder.decodeObject(forKey: "tradePasswordState") as? NSNumber ?? 0
        
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String
    }
    
    override init() {

    }
    
    //构造方法
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
   
}







