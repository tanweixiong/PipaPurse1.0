//
//  MineMiningVC.swift
//  PTNPurse
//
//  Created by tam on 2018/5/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SDWebImage

enum MineMiningStyle{
    case incomeStyle
    case rankingStyle
}

class MineMiningVC: UIViewController {
    fileprivate let mineMiningCell = "MineMiningCell"
    fileprivate var style = MineMiningStyle.incomeStyle
    @IBOutlet weak var personImgeVw: YLImageView!
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var rankingBtn: UIButton!
    @IBOutlet weak var miningBag: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: incomeBtn.frame.maxY + 10, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - incomeBtn.frame.maxY))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MineMiningCell", bundle: nil),forCellReuseIdentifier: self.mineMiningCell)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.separatorColor = UIColor.R_UIColorFromRGB(color: 0xF1F1F1)
        return tableView
    }()
    
    @IBAction func onClick(_ sender: UIButton) {
        if sender ==  incomeBtn{
            incomeBtn.backgroundColor = R_UIThemeColor
            incomeBtn.setTitleColor(UIColor.white, for: .normal)
            rankingBtn.backgroundColor = UIColor.clear
            rankingBtn.setTitleColor(R_ZYSelectNormalColor, for: .normal)
            style = .incomeStyle
        }else if sender == rankingBtn {
            rankingBtn.backgroundColor = R_UIThemeColor
            rankingBtn.setTitleColor(UIColor.white, for: .normal)
            incomeBtn.backgroundColor = UIColor.clear
            incomeBtn.setTitleColor(R_ZYSelectNormalColor, for: .normal)
            style = .rankingStyle
        }else if sender == backBtn {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MineMiningVC{
    func setupUI(){
        view.addSubview(tableView)
        
        let path = Bundle.main.url(forResource: "ic_mining_person", withExtension: "gif")
        let data = NSData(contentsOf: path!)
        self.personImgeVw.image = YLGIFImage(data: data! as Data)
        
        let imgaeSize = 50
        for _ in 0...4 {
            //生成一个X轴的随机数
            let newX = createRandomManFor(start:imgaeSize,end: Int(SCREEN_WIDTH) - imgaeSize)
            let newY = createRandomManFor(start:imgaeSize,end: Int(miningBag.frame.maxY) - imgaeSize)
            let imgaeView = UIImageView()
            imgaeView.image = UIImage.init(named: "ic_balloon")
            imgaeView.frame = CGRect(x:newX(), y: newY(), width: imgaeSize, height: imgaeSize)
            view.addSubview(imgaeView)
            
            let lab = UILabel()
            lab.text = "+1"
            lab.font = UIFont.systemFont(ofSize: 14)
            lab.textColor = UIColor.white
            lab.frame = CGRect(x: imgaeView.frame.origin.x, y: imgaeView.frame.origin.y, width: CGFloat(imgaeSize), height: CGFloat(imgaeSize))
            imgaeView.addSubview(lab)
        }
    }
    
    //生成随机数
    func createRandomManFor(start: Int, end: Int) ->() ->Int! {
        //根据参数初始化可选值数组
        var nums = [Int]();
        for i in start...end{
            nums.append(i)
        }
        func randomMan() -> Int! {
            if !nums.isEmpty {
                //随机返回一个数，同时从数组里删除
                let index = Int(arc4random_uniform(UInt32(nums.count)))
                return nums.remove(at: index)
            }else {
                //所有值都随机完则返回nil
                return nil
            }
        }
        return randomMan
    }
}

extension MineMiningVC:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if style == .incomeStyle {
            let cell = Bundle.main.loadNibNamed("MineMiningCell", owner: nil, options: nil)?[0] as! MineMiningCell
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("MineMiningRankingVC", owner: nil, options: nil)?[0] as! MineMiningRankingVC
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
