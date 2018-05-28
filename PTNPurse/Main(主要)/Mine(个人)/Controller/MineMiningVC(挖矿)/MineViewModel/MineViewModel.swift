//
//  MineViewModel.swift
//  PTNPurse
//
//  Created by tam on 2018/5/15.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper

class MineViewModel: NSObject {
    var totalMoney = String()
    fileprivate let baseViewModel = BaseViewModel()
    
    //气泡模型
    lazy var balloonModel : HomeMiningMineDetailsModel = HomeMiningMineDetailsModel()!
    
    lazy var rankModel : [HomeMiningListModel] = [HomeMiningListModel]()

    lazy var mineListModel : [HomeMiningListModel] = [HomeMiningListModel]()
    
    lazy var homeConvertModel : HomeConvertModel = HomeConvertModel()!
    
     lazy var homeConvertListModel : [HomeConvertListModel] = [HomeConvertListModel]()
    
    func loadSuccessfullyReturnedData(requestType: HTTPMethod, URLString : String, parameters : [String : Any]? = nil, showIndicator: Bool,finishedCallback : @escaping (_ data:Bool) -> ()) {
        baseViewModel.loadSuccessfullyReturnedData(requestType: requestType, URLString: URLString, parameters: parameters, showIndicator: showIndicator) {(model:HomeBaseModel) in
            //获取气泡
            if URLString.contains(ZYConstAPI.kAPIGetMineList){
                let responseData = Mapper<HomeMiningMineDetailsModel>().map(JSONObject: model.data)
                self.balloonModel = responseData!
                finishedCallback(true)
            //获取个人收益
            }else if URLString.contains(ZYConstAPI.kAPIGetMine){
                let responseData = Mapper<HomeMiningModel>().map(JSONObject: model.data)!
                self.rankModel = responseData.mineRank!
                //分页效果
                let arr = NSMutableArray()
                arr.addObjects(from: self.mineListModel)
                arr.addObjects(from: responseData.mineList!)
                self.mineListModel = arr as! [HomeMiningListModel]
                finishedCallback(responseData.mineList?.count != 0 ? true : false)
            //获取转换法币接口
            }else if URLString.contains(ZYConstAPI.kAPIConvertCoinList){
                let responseData = Mapper<HomeConvertModel>().map(JSONObject: model.data)!
                self.homeConvertModel = responseData
                //下拉刷新
                let arr = NSMutableArray()
                arr.addObjects(from: self.homeConvertListModel)
                arr.addObjects(from: responseData.changeList!)
                self.homeConvertListModel = arr as! [HomeConvertListModel]
                finishedCallback(responseData.changeList?.count != 0 ? true : false)
            }
        }
    }
}
