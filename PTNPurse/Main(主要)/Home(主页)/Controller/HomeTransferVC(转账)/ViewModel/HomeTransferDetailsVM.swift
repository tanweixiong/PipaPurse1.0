//
//  HomeTransferDetailsVM.swift
//  PTNPurse
//
//  Created by tam on 2018/1/31.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

class HomeTransferDetailsVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : HomeTransferDetailsModel = HomeTransferDetailsModel()!
    func loadDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeTransferDetailsModel>().map(JSONObject: model.data)
            self.model = responseData!
            finishedCallback()
        }
    }
    
    lazy var conversionModel : HomeConversionDetailsModel = HomeConversionDetailsModel()!
    func loadConversionDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeConversionDetailsModel>().map(JSONObject: model.data)
            self.conversionModel = responseData!
            finishedCallback()
        }
    }
}
