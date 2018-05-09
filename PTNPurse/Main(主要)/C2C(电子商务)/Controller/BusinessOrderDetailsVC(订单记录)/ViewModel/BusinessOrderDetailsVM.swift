//
//  BusinessOrderDetailsVM.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class BusinessOrderDetailsVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : BusinessOrderDetailsModel = BusinessOrderDetailsModel()!
    func loadSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.model = Mapper<BusinessOrderDetailsModel>().map(JSONObject: model.data)!
            finishedCallback()
        }
    }
}
