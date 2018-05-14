//
//  MineViewController.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/19.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper

class MineViewController: UIViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaviStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func onClick(_ sender: UIButton) {
        //挖矿
        if sender.tag == 1 {
            let mineMiningVC = MineMiningVC()
            self.navigationController?.pushViewController(mineMiningVC, animated: true)
        }else if sender.tag == 2 {
            let businessBuyVC = BusinessBuyHistoryVC()
            businessBuyVC.transactionStyle = .buyStyle
            self.navigationController?.pushViewController(businessBuyVC, animated: true)
        }else if sender.tag == 3 {
            let businessaDvertisementVC = BusinessaDvertisementVC()
            self.navigationController?.pushViewController(businessaDvertisementVC, animated: true)
        }else if sender.tag == 4 {
            let businessInviteFriendsVC = BusinessInviteFriendsVC()
            self.navigationController?.pushViewController(businessInviteFriendsVC, animated: true)
        }else if sender.tag == 5 {
            let aboutvc = AboutUsViewController()
            self.navigationController?.pushViewController(aboutvc, animated: true)
        }else if sender.tag == 6 {
            let securitySetViewController = SecuritySetViewController()
            self.navigationController?.pushViewController(securitySetViewController, animated: true)
        }
    }
  
    // MARK: - Private Method
    func setNaviStyle() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.isHidden = true
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

}
