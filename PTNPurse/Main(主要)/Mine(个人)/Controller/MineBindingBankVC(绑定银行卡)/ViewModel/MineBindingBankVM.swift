//
//  MineBindingBankVM.swift
//  PTNPurse
//
//  Created by tam on 2018/4/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class MineBindingBankVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : [MineBindingBankModel] = [MineBindingBankModel]()
    func loadDetailsSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.model = Mapper<MineBindingBankModel>().mapArray(JSONObject:model.data)!
            finishedCallback()
        }
    }
}
