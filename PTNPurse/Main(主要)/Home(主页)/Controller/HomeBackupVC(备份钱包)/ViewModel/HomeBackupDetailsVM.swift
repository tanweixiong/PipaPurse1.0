//
//  HomeBackupDetailsVM.swift
//  PTNPurse
//
//  Created by tam on 2018/1/27.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class HomeBackupDetailsVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    //导入钱包
    lazy var mnemonicJson : String = String()
    func loadBackupSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.mnemonicJson = model.data as! String
            finishedCallback()
        }
    }
    
    //获取助记词
    lazy var memoModel : [HomeBackupMemoListModel] = [HomeBackupMemoListModel]()
    func loadMemosSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeBackupMemoListModel>().mapArray(JSONObject: model.data)
            self.memoModel = responseData!
            finishedCallback()
        }
    }
    
    //获取钱包地址
    lazy var addressModel : [HomeBackupMemoListModel] = [HomeBackupMemoListModel]()
    func loadAddressSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            let responseData = Mapper<HomeBackupMemoModel>().map(JSONObject: model.data)
            self.memoModel = (responseData?.data)!
            finishedCallback()
        }
    }

}

