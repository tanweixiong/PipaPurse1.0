//
//  BusinessVM.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class BusinessVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    
    lazy var buyModel : [BusinessModel] = [BusinessModel]()
    lazy var sellModel : [BusinessModel] = [BusinessModel]()
    lazy var liberateModel : BusinessModel = BusinessModel()!
    func loadDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil,style:BusinessTransactionStyle,showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<BusinessModel>().mapArray(JSONObject: model.data)
            if style == .buyStyle{
               self.buyModel = responseData!
            }else{
               self.sellModel = responseData!
            }
            finishedCallback()
        }
    }
    
    lazy var coinModel : [BusinessCoinModel] = [BusinessCoinModel]()
    func loadCoinSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.coinModel = Mapper<BusinessCoinModel>().mapArray(JSONObject: model.data)!
            finishedCallback()
        }
    }
    
    func loadLiberateSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil,showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<BusinessModel>().map(JSONObject: model.data)
            if responseData != nil {
               self.liberateModel = responseData!
            }
            finishedCallback()
        }
    }
}
