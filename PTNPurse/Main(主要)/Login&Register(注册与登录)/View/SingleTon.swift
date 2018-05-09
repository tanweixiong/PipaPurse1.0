//
//  SingleTon.swift
//  GuiCoinPlatform
//
//  Created by 郑义 on 2017/9/18.
//  Copyright © 2017年 郑义. All rights reserved.
//

import UIKit
import ObjectMapper

class SingleTon: NSObject {
    
    var userInfo: UserInfoData?
    var fileName: String?
    var pwdstate: Int?
    
    static let shared = SingleTon()
    
    
    private override init() {
        
    }
    
    //设置单例信息
    class func setUserInfoData(userInfo:UserInfoData){
          UserDefaults.standard.setValue(userInfo.ptnaddress, forKey: R_Theme_PtnAddressKey)
    }
    
    //个人信息单例首次登录调用
    class func getUserInfoData(){
        if (UserDefaults.standard.object(forKey: "token") != nil) {
            let userInfo = UserInfoData()
            userInfo?.token = UserDefaults.standard.object(forKey: "token") as? String
            userInfo?.ptnaddress = UserDefaults.standard.object(forKey: R_Theme_PtnAddressKey) as? String
            userInfo?.language = "1"      //默认为中文
            SingleTon.shared.userInfo = userInfo
        }
    }
}
