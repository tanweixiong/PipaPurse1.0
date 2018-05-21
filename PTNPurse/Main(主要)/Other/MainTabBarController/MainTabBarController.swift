//
//  MainTabBarController.swift
//  DouYuTVMutate
//
//  Created by ZeroJ on 16/7/13.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 设置子控制器
        setupChildVcs()
        /// 设置item的字体颜色
        setTabBarItemColor()
    }
    
    func setTabBarItemColor() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: R_UIThemeSkyBlueColor], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], for: UIControlState())
    }
    
    func setupChildVcs() {
        let homeVc = addChildVc(HomeController(), title: LanguageHelper.getString(key: "tab_Home"), imageName: "ic_tab_home_n", selectedImageName: "ic_tab_home_s")
        let quotesVC = addChildVc(QuotesVC(), title: LanguageHelper.getString(key: "quotes_tab"), imageName: "ic_tab_C2C_n", selectedImageName: "ic_tab_C2C_s")
        let businessVC = addChildVc(BusinessVC(), title: LanguageHelper.getString(key: "tab_C2C"), imageName: "ic_tab_C2C_n", selectedImageName: "ic_tab_C2C_s")
        let informationVC = addChildVc(InformationVC(), title: LanguageHelper.getString(key: "tab_Information"), imageName: "ic_tabBar_information_n", selectedImageName: "ic_tabBar_information_s")
        let mineVc = addChildVc(MineViewController(), title: LanguageHelper.getString(key: "tab_Individual"), imageName: "ic_tab_mine_n", selectedImageName: "ic_tab_mine_s")
        viewControllers = [homeVc,quotesVC,businessVC,informationVC,mineVc]
        self.selectedIndex = 2
    }
    
    func addChildVc(_ childVc: UIViewController, title: String, imageName: String, selectedImageName: String) -> UINavigationController {
        let navi = FMNavigationController(rootViewController: childVc)
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navi.tabBarItem = tabBarItem
        return navi
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

