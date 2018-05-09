//
//  BusinessaDvertisementVM.swift
//  PTNPurse
//
//  Created by tam on 2018/3/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class BusinessaDvertisementVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    
    lazy var processingModel : [BusinessaDvertisementModel] = [BusinessaDvertisementModel]()
    lazy var finishModel :[BusinessaDvertisementModel] = [BusinessaDvertisementModel]()
    
    func loadDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil,style:BusinessaDvertisementStyle, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            if style == .processingStyle{
               self.processingModel = Mapper<BusinessaDvertisementModel>().mapArray(JSONObject: model.data)!
            }else{
               self.finishModel = Mapper<BusinessaDvertisementModel>().mapArray(JSONObject: model.data)!
            }
            finishedCallback()
        }
    }
}
