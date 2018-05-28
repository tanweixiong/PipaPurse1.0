//
//  RegularDefinition.swift
//  TradingPlatform
//
//  Created by tam on 2017/8/8.
//  Copyright © 2017年 Wilkinson. All rights reserved.
//

import UIKit
import SDWebImage

let        SCREEN_WIDTH = UIScreen.main.bounds.size.width;

let        SCREEN_HEIGHT = UIScreen.main.bounds.size.height;

let        SCREEN_HEIGHT_INSIDE = UIScreen.main.bounds.size.height - 64;

let        SCREEN_KeyWindowBounds = (UIApplication.shared.keyWindow?.bounds)!

let        STATUSBAR_HEIGHT = UIDevice.current.isX() ? CGFloat(44) : CGFloat(20)
let        NAVIGATIONBAR_HEIGHT = UIDevice.current.isX() ? CGFloat(88) : CGFloat(64)
let        TABBAR_HEIGHT = UIDevice.current.isX() ? CGFloat(83) : CGFloat(49)

func       XMAKE(_ x: CGFloat) -> CGFloat {
    return x * UIScreen.main.bounds.size.width/375;
}

func       YMAKE(_ y: CGFloat) -> CGFloat {
    return y * UIScreen.main.bounds.size.height/667;
}

//极光推送appKey
public let R_UITheme_JPushKey = "356c31a60d81ebcec7c65a0d"

//环信AppKey
public let R_huangXinChatKey = "1163171010178071#ec"

//二维码标识
public let R_Theme_QRCode = "ptn"

//K线图的地址
public let R_Theme_lineGraph = "http://10.0.0.11/dhs-wallet/"

//ptn地址
public let R_Theme_PtnAddressKey = "ThemePtnaddressKey"

//保存地理格式
public let R_Latitude = "mineCurrentLatitude"

public let R_UserInfo = "UserInfo"

//保存入驻的状态
public let R_NeedChefSettledStatus = "is_ChefSettledStatus"

//行情key
public let R_UserDefaults_Market_Key = "UserDefaultsMarketKey"

//行情详情key
public let R_UserDefaults_Market_Details_Key = "UserDefaultsMarketDetailsKey"

//行情编辑key
public let R_UserDefaults_Market_Details_Edit_Key = "UserDefaultsMarketDetailsEditKey"

//七牛的地址
public let R_QiNiuImageUrl = "http://opd74myxl.bkt.clouddn.com/"

//首页详情HTML5
public let R_Theme_Home_Line_Chart = "http://photonchain.vip/line/line.html?"

//请先登录提示
public let R_Theme_LoginPrompt = "请先登录"

//校验是否已被登录
public let R_Theme_isLogin = "isLogin"

//校验是否首次登录
public let R_Theme_isShowStore = "isShowStore"

//校验是否已经选择了语言
public let R_Theme_isChooseLanguage = "isChooseLanguage"

//校验输入中文和英文
public let R_Languages = "Reality_Languages"

//厨师擅长菜式
public let R_ChefGoodAtDishes = "Chef_Good_At_Dishes"

//是否有擅长菜式
public let R_HasChefGoodAtDishes = "Has_Chef_Good_At_Dishes"

//刷新主页
public let R_NotificationHomeReload = "R_Notification_Home_Reload"

//刷新详情页面
public let R_NotificationHomeConvertReload = "R_Notification_Home_Convert_Reload"

//刷新银行卡列表
public let R_NotificationBankListReload = "R_Notification_Bank_List_Reload"

//刷新广告
public let R_NotificationAdvertisingeReload = "R_Notification_Advertising_Reload"

//刷新C2C页面
public let R_NotificationC2CReload = "R_Notification_C2C_Reload"

//刷新C2C订单页面
public let R_NotificationC2COrderReload = "R_Notification_C2C_Order_Reload"

//列表的页码
public let R_ListPageSize = 10

//主题颜色
public let R_UIThemeColor = UIColor.R_UIColorFromRGB(color: 0x009BFD)

//主题蓝色
public let R_UIThemeSkyBlueColor = UIColor.R_UIColorFromRGB(color: 0x009BFD)

//刷新资产信息
public let R_AssetsReloadAssetsMassage = "R_AssetsReloadAssetsMassage"

//头像
public let R_UIThemeAvatarKey = "AvatarKey"

//个人信息保存
public let R_UIThemeUserInfo = "UserInfo"

//转账小数点位数限制
public let R_UIThemeTransferLimit = 6
//发布购买位数限制
public let R_UIThemePostPurchaseLimit = 4
//发布购买单价位数限制
public let R_UIThemePostPurchasePriceLimit = 2

//主题背景颜色
public let R_UIThemeBackgroundColor = UIColor.R_UIColorFromRGB(color: 0x0094EB)

//线条颜色
public let R_UILineColor = UIColor.R_UIColorFromRGB(color: 0xdddddd)

//浅色
public let R_UIFontLightColor = UIColor.R_UIColorFromRGB(color: 0x999999)

//深色
public let R_UIFontDarkColor = UIColor.R_UIColorFromRGB(color: 0x666666)

//更深色
public let R_UIFontMoreDarkColor = UIColor.R_UIColorFromRGB(color: 0x333333)

//导航栏颜色
public let R_UINavigationBarColor = UIColor.R_UIColorFromRGB(color: 0x191619)

//section分割线颜色
public let R_UISectionLineColor = UIColor.R_UIColorFromRGB(color: 0xF1F1F1)

//主题
public let R_UIThemeGoldColor = UIColor.R_UIRGBColor(red: 211, green: 178, blue: 105, alpha: 1)

//菜式颜色
public let R_UIDishRedColor = UIColor.R_UIColorFromRGB(color: 0xFC6949)
public let R_UIDishLightBlueColor = UIColor.R_UIColorFromRGB(color: 0x63B6F3)
public let R_UIDishDeepBlueColor = UIColor.R_UIColorFromRGB(color: 0x6D95F8)
public let R_UIDishLightGrayColor = UIColor.R_UIColorFromRGB(color: 0xE8E8E8)

//zhengyi
public let R_ThemeFontName =  "PingFang SC"
public let R_GrayColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
public let R_ZYGrayColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
public let R_ZYPlaceholderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
public let R_ZYThemeColor = R_UIThemeColor
public let R_ZYBtnBgGrayColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
public let R_ZYTitlFontSize = CGFloat(12)
public let R_ZYBtnFontSize = CGFloat(12)
public let R_ZYMineViewGrayColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
public let R_ZYCellShadowColor = UIColor.R_UIColorFromRGB(color: 0xCFD3D5)
public let R_ZYSelectNormalColor = UIColor.R_UIColorFromRGB(color: 0xBDBDBD)

let        VERTICAL_SCALE = SCREEN_HEIGHT / 667
let        HORIZION_SCALE = SCREEN_WIDTH / 375

let UserCurrency = "UserCurrency"

