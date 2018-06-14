//
//  HomeBaseModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/25.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import ObjectMapper

class HomeBaseModel: Mappable {
    var code: NSNumber?
    var message: String?
    var data: Any?
    
    var pageNum :Int?
    var pages :Int?
    var total :Int?

    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
    
    func mapping(map: Map) {
        code        <- map["code"]
        message     <- map["message"]
        data        <- map["data"]
        
        pageNum      <- map["pageNum"]
        pages        <- map["pages"]
        total        <- map["total"]
    }
}
