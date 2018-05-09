//
//  HomeListDetsilsVM.swift
//  PTNPurse
//
//  Created by tam on 2018/1/27.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class HomeListDetsilsVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : HomeDetailsModel = HomeDetailsModel()!
    func loadDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeDetailsModel>().map(JSONObject: model.data)
            self.model = responseData!
            finishedCallback()
        }
    }

    lazy var maxModel : HomeTransferMaxModel = HomeTransferMaxModel()!
    func loadCoinNumberSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeTransferMaxModel>().map(JSONObject: model.data)
            self.maxModel = responseData!
            finishedCallback()
        }
    }
}

