//
//  ConstAPIURL.swift
//  DHSWallet
//
//  Created by zhengyi on 2017/8/16.
//  Copyright © 2017年 zhengyi. All rights reserved.
//

import UIKit

struct ZYConstAPI {

//    static let kAPIH5BaseURL: String = "http://api.ptn.one:8080"
//    static let kAPIBaseURL: String = "http://api.ptn.one:8080/"  //正式服务
    static let kAPIBaseURL: String = "http://192.168.20.24:8080/"  //正聪服务
//    static let kAPIBaseURL: String = "http://47.92.165.25:8080/"  //测试服务

    
    static let kAPIQuotesDetailsH5BaseURL: String = "http://47.92.165.25:7876/assets/appline/kline.html?coinNo="
    
    static let kAPILogin = kAPIBaseURL + "login.do" //登录接口
    static let kAPIQuitLogin = kAPIBaseURL + "logout.do"
    static let kAPIHasSetTradePwd = kAPIBaseURL + "getDealPwdState.do"
    static let kAPIUpdataUserName = kAPIBaseURL + "setNickName.do"
    static let kAPIUpdataUserPhoto = kAPIBaseURL + "setPhoto.do"
    
    static let kAPIUserIsExistence = kAPIBaseURL + "userIsExistence.do"
    
    static let kAPIGetUserInfoByToken = kAPIBaseURL + "getUserInfo.do"

    static let kAPIRegister = kAPIBaseURL + "addUser.do"   //注册接口
    static let kAPIGetAuthorCode = kAPIBaseURL + "sendSmsCode.do" //获取短信验证码
    static let kAPIModifyLoginPwd = kAPIBaseURL + "editPwd.do" //修改登录密码接口
    static let kAPIForgetLoginPwd = kAPIBaseURL + "forgetPwd.do" //忘记登录密码接口
    static let kAPIForgetTradePwd = kAPIBaseURL + "forgetDealPwd.do" //忘记登录密码接口
    static let kAPIModifyTradePwd = kAPIBaseURL + "editDealPwd.do" //修改交易密码接口
    static let kAPISetTradePwd = kAPIBaseURL + "setDealPwd.do" //设置交易密码接口
    
    static let kAPIGetUserByInvitation = kAPIBaseURL + "getUserByInvitation"//分享个人信息接口
    static let kAPIGetBonusDetailByUserNo = kAPIBaseURL + "getBonusDetailByUserNo"//分享个人信息列表接口
//    static let kAPIGetUserByInvitation = kAPIBaseURL + "getUserByInvitation"//获取邀请好友接口
    
    static let kAPIAddAdvise = kAPIBaseURL + "addOpinion.do"
    static let kAPIGetAdviseList = kAPIBaseURL + "getOpinion.do"
    static let kAPIDeleteAdvise = kAPIBaseURL + "deleteOpinion.do"

    static let kAPIAddFriend = kAPIBaseURL + "addFriends.do"
    static let kAPIGetFriendList = kAPIBaseURL + "getFriends.do"
    static let kAPIDeleteFriend = kAPIBaseURL + "delFriends.do"
    static let kAPIFriendDetail = kAPIBaseURL + "getFriendsOne.do"
    
    static let kAPIGetVersion = kAPIBaseURL + "getVersionInfo"

    static let kAPIGetTradeFriends = kAPIBaseURL + "getTradeFriends"
    static let kAPIGetNews = kAPIBaseURL + "getNewses"

    static let kAPIGetLastNotice = kAPIBaseURL + "/notice/getNoticeOne.do"   //获取最新公告
    static let kAPIGetNoticeList = kAPIBaseURL + "/notice/getNoticeByType.do"   //获取全部公告列表
    static let kAPIGetOnePageNoticeList = kAPIBaseURL + "/notice/getNoticeByTypeShouYe.do"   //获取首页公告列表（只包含最近五条）
    static let kAPIGetSpecifyNotice = kAPIBaseURL + "/notice/getNoticeById.do"   //获取指定公告接口
    static let kAPIGetBannerImage = kAPIBaseURL + "/other/getHomeImg.do"   //获取轮播图片

    
    //**************************************首页****************************************************************//
    //首页//
    static let kAPIGetBalance = kAPIBaseURL + "getBalance" //获取首页列表
    static let kAPIGetWalletStates = kAPIBaseURL + "getWalletStates" //获取资产列表
    static let kAPIEditWalletState = kAPIBaseURL + "editWalletState" //改变钱包状态
    static let kAPIGetCoinDetail = kAPIBaseURL + "getCoinDetail" //首页详情接口
    
    //转换//
    static let kAPIQueryRoutineList = kAPIBaseURL + "queryRoutineList" //常规专区列表转换
    static let kAPIQueryPntList = kAPIBaseURL + "queryPntList" //光子专区列表转换
    static let kAPIChangeChangeNum = kAPIBaseURL + "change/changeNum" //转换数值接口
    static let kAPIChangeChangeCoin = kAPIBaseURL + "change/changeCoin" //转换货币接口
    static let kAPIChangeDetail = kAPIBaseURL + "change/detail" //转换详情
    
    //转账//
    static let kAPIAddTradeInfo = kAPIBaseURL + "addTradeInfo.do" //常规专区列表转账
    static let kAPIGetCoinByNo = kAPIBaseURL + "getCoinByNo.do" //获取最大值与最小值
    static let kAPIGetTradeInfoByNo = kAPIBaseURL + "getTradeInfoByNo.do" //获取转账详情
    
    
    //备份钱包//
    static let kAPIExportAddress = kAPIBaseURL + "exportAddress" //备忘钱包
    static let kAPIImportAddress = kAPIBaseURL + "importAddress" //导入钱包
    static let kAPIMemoGetMemos = kAPIBaseURL + "memo/getMemos" //获取助记词
    static let kAPIAddWallet = kAPIBaseURL + "addWallet" //新增钱包地址
    
    //明细//
    static let kAPIGetTradeInfo = kAPIBaseURL + "getTradeInfo.do" //获取交易记录
    
    //光子转换列表//
    static let kAPIChangeChangeList = kAPIBaseURL + "change/changeList" //获取交易记录
    
    //上传文件//
    static let kAPIUploadWhitePaper = kAPIBaseURL + "uploadWhitePaper.do" //上传文件

    //**************************************C2C*************************************************//
    static let kAPIAddSpotEntrust = kAPIBaseURL + "addSpotEntrust" //发布广告
    static let kAPISpotTrade = kAPIBaseURL + "spotTrade" //下单
    static let kAPIConfirmPay = kAPIBaseURL + "confirmPay" //买方确认付款
    static let kAPIConfirmReceive = kAPIBaseURL + "confirmReceive" //卖方确认收款
    static let kAPIRemindSms = kAPIBaseURL + "remindSms" //提醒卖家买家已付款短信
    static let kAPICancelDealDetail = kAPIBaseURL + "cancelDealDetail" //取消订单
    static let kAPIDelSpotEntrust = kAPIBaseURL + "delSpotEntrust" //撤销广告
    static let kAPISpotDisputeSubmission = kAPIBaseURL + "spotDispute/submission" //发起纠纷

    static let kAPIGetSpotEntrust = kAPIBaseURL + "getSpotEntrust.do" //获取平台广告
    static let kAPIGetSpotEntrustById = kAPIBaseURL + "getSpotEntrustById.do" //获取广告详情
    static let kAPIGetSpotEntrustByUserNo = kAPIBaseURL + "getSpotEntrustByUserNo.do" //获取个人广告
    static let kAPIGetDealDetailByUserNo = kAPIBaseURL + "getDealDetailByUserNo.do" //获取用户订单
    static let kAPIGetDealDetailById = kAPIBaseURL + "getDealDetailById.do" //获取用户订单详情
    static let kAPIGetCoin = kAPIBaseURL + "getCoin.do" //获取币种接口
    static let kAPISpotDisputeUploadImg = kAPIBaseURL + "spotDispute/uploadImg.do" //上传图片
    static let kAPISpotDisputeDisputeList = kAPIBaseURL + "spotDispute/disputeList.do" //意见反馈列表
    static let kAPISpotDisputeDisputeDetail = kAPIBaseURL + "spotDispute/disputeDetail.do" //申诉详情
    
    static let kAPIBindWeChat = kAPIBaseURL + "bindWeChat" //绑定微信
    static let kAPIBindApay = kAPIBaseURL + "bindApay" //绑定支付宝
    static let kAPIBindAddBankCard = kAPIBaseURL + "addBankCard" //绑定银行卡
    static let kAPIBindGetBankCard = kAPIBaseURL + "getBankCard" //获取银行卡
    static let kAPIBindDeleteBankCard = kAPIBaseURL + "deleteBankCard" //删除银行卡
    static let kAPIBindEditBankCard = kAPIBaseURL + "editBankCard" //修改用户银行卡
    static let kAPIBindPhone = kAPIBaseURL + "bindPhone" //绑定手机号
    
     //**************************************挖矿*************************************************//
    static let kAPIGetMine = kAPIBaseURL + "getMine.do" //获取挖矿主页信息
    static let kAPIAddMine = kAPIBaseURL + "addMine.do" //添加挖矿收益接口
    static let kAPIGetMineList = kAPIBaseURL + "getMineList.do" //获取挖矿小球信息

     //**************************************行情*************************************************//
    static let kAPIOpenCoinList = kAPIBaseURL + "openCoinList.do" //获取行情列表
    static let kAPIMarket = kAPIBaseURL + "market" //获取行情详情
    //**************************************修改个人信息*************************************************//
    static let kAPISetNickName = kAPIBaseURL + "setNickName.do" //设置用户昵称
    static let kAPISetUserAddress = kAPIBaseURL + "setUserAddress.do" //设置用户地址
    
    //**************************************转换法币*************************************************//
    static let kAPIConvertCoinList = kAPIBaseURL + "getChange" //获取法币列表
    static let kAPIChangeCoin = kAPIBaseURL + "change" //转换法币
    
    static let kAPIGetNewsDetail  = kAPIBaseURL + "getNewsDetail" //增加浏览量
    
    
    static let ShareMessage = "随时随地交易数字商品，24小时替你盯盘，替你赚钱！http://47.92.122.8"
    
    static let JPushAppKey = "44f0289ffb22d6c452404e21"
    static let JpushAppSecret = "a2b549b634397eabc43eccbe"
    
    static let NotificationShouldToLogin = "shouldToLogin"
    
    static let RSAPublicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9l4WqMqZPsY8ESKTK+moY/9sCozo6ZiQoQyIHO0QX4w/GSHsLb7f0XtWbz9iX30A5pebovJjfexxQKlHvv4Pqt69Jg5SlOyeo2ye5F1R1ta8pVhZfCXHhLvk9EqmEnAr9ZtV0RQhLSYakANKwc77DC8LU8MpADDChOZHbSwTb9wIDAQAB"

}

