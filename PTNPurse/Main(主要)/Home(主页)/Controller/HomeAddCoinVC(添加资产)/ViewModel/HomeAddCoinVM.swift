//
//  HomeAddCoinVM.swift
//  PTNPurse
//
//  Created by tam on 2018/1/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class HomeAddCoinVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    lazy var model : [HomeAddCoinListModel] = [HomeAddCoinListModel]()
    func loadCoinListSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            print(model.data!)
            let responseData = Mapper<HomeAddCoinDataModel>().map(JSONObject: model.data)
            self.model = (responseData?.userWallets)!
            finishedCallback()
        }
    }
}
