//
//  HomeTransferMaxModel.swift
//  PTNPurse
//
//  Created by tam on 2018/2/1.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeTransferMaxModel: Mappable {
    var minFee: NSNumber?
    var maxFee: NSNumber?
    var feeCore: NSNumber?
    var poundage: NSNumber?

    
    func mapping(map: Map) {
        minFee     <- map["minFee"]
        maxFee     <- map["maxFee"]
        feeCore     <- map["feeCore"]
        poundage     <- map["poundage"]
    }
    
    required init?(map: Map) {
        
    }
    
    required init?() {
        
    }
}
