//
//  BusinessInviteFriendsVM.swift
//  PTNPurse
//
//  Created by tam on 2018/4/11.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import Alamofire
import SVProgressHUD
import ObjectMapper

class BusinessInviteFriendsVM: NSObject {
    fileprivate let baseViewModel = BaseViewModel()
    
//    lazy var model : BusinessInviteFriendsModel = BusinessInviteFriendsModel()!
//    func loadSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
//        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
//            self.model = Mapper<BusinessInviteFriendsModel>().map(JSONObject: model.data)!
//            finishedCallback()
//        }
//    }
    
    lazy var inviteModel : InviteFriendsModel = InviteFriendsModel()!
    func loadListSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping () -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            self.inviteModel = Mapper<InviteFriendsModel>().map(JSONObject: model.data)!
            finishedCallback()
        }
    }
}


