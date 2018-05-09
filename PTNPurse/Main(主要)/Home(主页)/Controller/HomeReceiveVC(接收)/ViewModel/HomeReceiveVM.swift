//
//  HomeReceiveVM.swift
//  PTNPurse
//
//  Created by tam on 2018/1/29.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class HomeReceiveVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    //导入钱包
    lazy var model : HomeBackupListModel = HomeBackupListModel()!
    func loadReceiveSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            if model.code == 400 {
                SVProgressHUD.showInfo(withStatus: model.message)
                finishedCallback()
                return
            }
            let responseData = Mapper<HomeBackupListModel>().map(JSONObject: model.data)
            self.model = responseData!
            finishedCallback()
        }
    }
}
