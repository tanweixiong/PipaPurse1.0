//
//  BusinessSubmissionMessageVM.swift
//  PTNPurse
//
//  Created by tam on 2018/3/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class BusinessSubmissionMessageVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : [BusinessSubmissionMsgModel] = [BusinessSubmissionMsgModel]()
    func loadSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let data = model.data as! NSDictionary
            let list = data.object(forKey: "list")
            let array = Mapper<BusinessSubmissionMsgModel>().mapArray(JSONObject: list)!
            let dataArray = NSMutableArray()
            dataArray.addObjects(from: self.model)
            dataArray.addObjects(from: array)
            self.model = dataArray as! [BusinessSubmissionMsgModel]
            finishedCallback()
        }
    }
    
    
    lazy var detailsModel : BusinessSubmissionMsgModel = BusinessSubmissionMsgModel()!
    func loadSubmissionDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.detailsModel = Mapper<BusinessSubmissionMsgModel>().map(JSONObject: model.data)!
            finishedCallback()
        }
    }
    
}

