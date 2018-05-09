//
//  HomeCoinDetailsVM.swift
//  PTNPurse
//
//  Created by tam on 2018/1/29.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class HomeCoinDetailsVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : [HomeCoinDetailsModel] = [HomeCoinDetailsModel]()
    func loadCoinDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.model = Mapper<HomeCoinDetailsModel>().mapArray(JSONObject: model.data)!
            finishedCallback()
        }
    }
    lazy var transferModel : [HomeCoinTransferDetailsModel] = [HomeCoinTransferDetailsModel]()
    var isCoinTransferFirst = true
    lazy var coinTransPages = 1
    lazy var coinTransPageNum = 1
    func loadCoinTransferDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        if self.coinTransPageNum <= self.coinTransPages {
            baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
                let dict = model.data as! NSDictionary
                print(dict)
                if (dict.object(forKey: "change") != nil){
                    if self.isCoinTransferFirst {
                        self.coinTransPages = dict.object(forKey: "pages") as! Int
                        self.coinTransPageNum = dict.object(forKey: "pageNum") as! Int
                        self.isCoinTransferFirst = false
                    }else{
                        self.coinTransPageNum = self.coinTransPageNum + 1
                    }
                    let changeArray = dict.object(forKey: "change")
                    let listArray = Mapper<HomeCoinTransferDetailsModel>().mapArray(JSONObject:changeArray)!
                    let array = NSMutableArray()
                    array.addObjects(from: self.transferModel)
                    array.addObjects(from: listArray)
                    self.transferModel = array as! [HomeCoinTransferDetailsModel]
                    finishedCallback()
                }
            }
        }
    }
}
