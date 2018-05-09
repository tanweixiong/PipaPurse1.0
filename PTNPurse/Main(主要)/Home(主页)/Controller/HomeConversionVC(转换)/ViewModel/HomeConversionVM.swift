//
//  HomeConversionVM.swift
//  PTNPurse
//
//  Created by tam on 2018/1/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class HomeConversionVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var PTNmodel : [HomeConversionListModel] = [HomeConversionListModel]()
    lazy var Conventionalmodel : [HomeConversionListModel] = [HomeConversionListModel]()
    
    //PTN专区
    func loadPTNConversionSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeConversionListModel>().mapArray(JSONObject: model.data)
            self.PTNmodel = responseData!
            print(self.PTNmodel)
            finishedCallback()
        }
    }
    
    //常规专区
    func loadConventionalConversionSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeConversionListModel>().mapArray(JSONObject: model.data)
            self.Conventionalmodel = responseData!
            finishedCallback()
//            if model.code == 200 {
//                finishedCallback(true)
//            }else{
//                finishedCallback(false)
//            }
        }
    }
}

