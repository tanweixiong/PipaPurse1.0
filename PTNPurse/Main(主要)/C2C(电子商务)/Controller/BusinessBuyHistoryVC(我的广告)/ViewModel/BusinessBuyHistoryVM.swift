//
//  BusinessBuyHistoryVM.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class BusinessBuyHistoryVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : [BusinessBuyHistoryModel] = [BusinessBuyHistoryModel]()
    func loadDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<BusinessBuyHistoryModel>().mapArray(JSONObject: model.data)
            self.model = responseData!
            finishedCallback()
        }
    }
}
