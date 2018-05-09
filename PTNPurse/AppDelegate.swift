//
//  AppDelegate.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window?.backgroundColor = UIColor.white
        SVProgressHUD.setForegroundColor(R_UIThemeColor)
        setLanguage()
        setMainVC()
        OCTools.registerShareSDK()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    
    }
    
    func setLanguage(){
        LanguageHelper.shareInstance.initUserLanguage()
        if (UserDefaults.standard.object(forKey: UserLanguage) != nil) {
            let language = UserDefaults.standard.object(forKey: UserLanguage)
            LanguageHelper.shareInstance.setLanguage(langeuage: language as! String)
        }
        
        if (UserDefaults.standard.object(forKey: UserCurrency) == nil) {
            UserDefaults.standard.setValue("CNY", forKey: UserCurrency)
        }
    }
    
    func setMainVC() {
        self.setLoginStatus()
        if UserDefaults.standard.bool(forKey: "hadLogin") {
            //添加全局单例
            SingleTon.getUserInfoData()
            let mainvc = MainTabBarController()
            window?.rootViewController = mainvc
        }else{
            let loginNav = FMNavigationController.init(rootViewController: LoginController())
            window?.rootViewController = loginNav
        }
    }
    
    func setLoginStatus() {
        let login = UserDefaults.standard.value(forKey: "hadLogin") as? Bool
        if login == nil {
            UserDefaults.standard.setValue(false, forKey: "hadLogin")
        }
        UserDefaults.standard.synchronize()
    }
}



