//
//  QuotesVM.swift
//  PTNPurse
//
//  Created by tam on 2018/3/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class QuotesVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    
    lazy var model : [QuotesModel] = [QuotesModel]()
    func loadQuotesSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.model = Mapper<QuotesModel>().mapArray(JSONObject: model.data)!
            finishedCallback()
        }
    }
    
    lazy var detsilsModel : QuotesDetsilsModel = QuotesDetsilsModel()!
    func loadDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.detsilsModel = Mapper<QuotesDetsilsModel>().map(JSONObject: model.data)!
            finishedCallback()
        }
    }
}
