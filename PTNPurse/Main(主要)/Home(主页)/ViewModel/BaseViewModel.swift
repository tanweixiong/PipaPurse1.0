//
//  BaseViewModel.swift
//  PTNPurse
//
//  Created by tam on 2018/1/25.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class BaseViewModel: NSObject {
    //基类模型试图
    func loadSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping (_ model:HomeBaseModel) -> ()) {
        ZYNetWorkTool.requestData(requestType, URLString: URLString, language:false, parameters: parameters, showIndicator: showIndicator, success: { (json) in
            let responseData = Mapper<HomeBaseModel>().map(JSONObject: json)
            if let code = responseData?.code {
                guard  200 == code || 300 == code || 1044 == code else {
                    //未设置支付密码
                    SVProgressHUD.showInfo(withStatus: responseData?.message)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        SVProgressHUD.dismiss()
                    })
                    return
                }
                if showIndicator {
                    SVProgressHUD.showSuccess(withStatus: responseData?.message)
                }
                finishedCallback(responseData!)
            }
        }) { (error) in
        }
    }
}
