//
//  HomeViewModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/25.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class HomeViewModel: NSObject {
    var totalMoney = String()
    var balanceState = NSNumber()
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : [HomeWalletsModel] = [HomeWalletsModel]()
    func loadHomeSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeModel>().map(JSONObject: model.data)
            self.model = (responseData?.userWallets)!
            self.totalMoney =  responseData?.totalMoney == nil ? "0" : (responseData?.totalMoney?.stringValue)!
            self.balanceState = responseData?.balanceState == nil ? 0 : (responseData?.balanceState)!
            finishedCallback()
        }
    }
}
