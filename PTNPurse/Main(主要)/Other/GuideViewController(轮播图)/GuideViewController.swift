//
//  GuideViewController.swift
//  GuideViewExample
//
//  Created by ChuGuimin on 16/1/20.
//  Copyright © 2016年 cgm. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {
    
    fileprivate var scrollView: UIScrollView!
    
    fileprivate let numOfPages = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = self.view.bounds
        
        scrollView = UIScrollView(frame: frame)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPoint.zero
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages), height: frame.size.height)
        
        scrollView.delegate = self
        
        for index  in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "GuideImage\(index + 1)"))
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            scrollView.addSubview(imageView)
            if index == numOfPages - 1 {
                restartButton.frame.origin.x = frame.size.width * CGFloat(index) + XMAKE(130)
                scrollView.addSubview(restartButton)
            }
        }
        
        self.view.insertSubview(scrollView, at: 0)
    }
    
    lazy var restartButton:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.frame = CGRect(x: 0, y: 0, width: 90, height: 20)
        btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: YMAKE(340), width: XMAKE(240), height: YMAKE(80))
        return btn
    }()
    
    @objc func onClick(_ sender:UIButton){
        UserDefaults.standard.set(true, forKey: R_Theme_isShowStore)
        let navi = MainTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = navi
    }
    
    // 隐藏状态栏
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

// MARK: - UIScrollViewDelegate
extension GuideViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
//        pageControl.currentPage = Int(offset.x / view.bounds.width)
//
//        // 因为currentPage是从0开始，所以numOfPages减1
//        if pageControl.currentPage == numOfPages - 1 {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.startButton.alpha = 1.0
//            })
//        } else {
//            UIView.animate(withDuration: 0.2, animations: {
//                self.startButton.alpha = 0.0
//            })
//        }
//    }
}
