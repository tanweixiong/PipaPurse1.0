//
//  MineMiningVC.swift
//  PTNPurse
//
//  Created by tam on 2018/5/14.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

enum MineMiningStyle{
    case incomeStyle
    case rankingStyle
}

class MineMiningVC: MainViewController {
    fileprivate let viewTag = 10000000
    fileprivate var imgaeSize = 50
    fileprivate let mineMiningCell = "MineMiningCell"
    fileprivate let token = (UserDefaults.standard.getUserInfo().token)!
    fileprivate var style = MineMiningStyle.incomeStyle
    fileprivate lazy var viewModel : MineViewModel = MineViewModel()
    fileprivate lazy var baseVM : BaseViewModel = BaseViewModel()
    fileprivate var pageSize = 1
    fileprivate var lineSize = 10

    var cumulativeIncomeCenter = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
        getListData()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MineMiningCell", bundle: nil),forCellReuseIdentifier: self.mineMiningCell)
        tableView.separatorInset = UIEdgeInsetsMake(0,SCREEN_WIDTH, 0,SCREEN_WIDTH);
        tableView.separatorColor = UIColor.R_UIColorFromRGB(color: 0xF1F1F1)
        tableView.tableHeaderView = self.mineMiningVw
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.getListData()
        })
        return tableView
    }()
    
    lazy var mineMiningVw: MineMiningVw = {
        let view = Bundle.main.loadNibNamed("MineMiningVw", owner: nil, options: nil)?.last as! MineMiningVw
        view.frame = CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height:460)
        view.incomeBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.rankingBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        view.ruleDescriptionBtn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
        return view
    }()
    
    @objc func onClick(_ sender: UIButton) {
        if sender ==  mineMiningVw.incomeBtn || sender == mineMiningVw.rankingBtn{
            if sender ==  mineMiningVw.incomeBtn {
                mineMiningVw.incomeBtn.backgroundColor = R_UIThemeColor
                mineMiningVw.incomeBtn.setTitleColor(UIColor.white, for: .normal)
                mineMiningVw.rankingBtn.backgroundColor = UIColor.clear
                mineMiningVw.rankingBtn.setTitleColor(R_ZYSelectNormalColor, for: .normal)
                style = .incomeStyle
                tableView.mj_footer.resetNoMoreData()
            }else{
                mineMiningVw.rankingBtn.backgroundColor = R_UIThemeColor
                mineMiningVw.rankingBtn.setTitleColor(UIColor.white, for: .normal)
                mineMiningVw.incomeBtn.backgroundColor = UIColor.clear
                mineMiningVw.incomeBtn.setTitleColor(R_ZYSelectNormalColor, for: .normal)
                style = .rankingStyle
                tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            tableView.reloadData()
        }else if sender == mineMiningVw.ruleDescriptionBtn{
            let vc = MineRuleDescriptionVC()
            vc.url = (self.viewModel.balloonModel.remarkUrl)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        //计算中点位置
        let cumulativeX = mineMiningVw.cumulativeIncomeLab.frame.maxX - mineMiningVw.cumulativeIncomeLab.size.width
        let centerX = cumulativeX + CGFloat(imgaeSize) / 2
        self.cumulativeIncomeCenter =  CGPoint(x: centerX, y: mineMiningVw.cumulativeIncomeLab.frame.maxY)
    }
}

extension MineMiningVC{
    func setupUI(){
        view.addSubview(tableView) 
        //创建头部
        setNormalNaviBar(title: "", BackgroundImage: UIImage.creatImageWithColor(color: UIColor.clear, size: CGSize(width:SCREEN_WIDTH,height:SCREEN_HEIGHT), alpha: 1))
    }
    
    func getData(){
        let parameters = ["token":self.token]
        viewModel.loadSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetMineList, parameters: parameters, showIndicator: false) {_ in
            let mineSumNum = self.viewModel.balloonModel.mineSumNum
            self.mineMiningVw.cumulativeIncomeLab.text = LanguageHelper.getString(key: "Mine_Mining_Cumulative") + Tools.setNSDecimalNumber(mineSumNum!)
            self.createBalloon()
        }
    }
    
    func addData(_ index:NSInteger){
        let balloonModel = viewModel.balloonModel.mineDetails![index]
        let parameters = ["id":(balloonModel.id?.stringValue)!,"token":self.token]
        baseVM.loadSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIAddMine, parameters: parameters ,showIndicator: false) { (model:HomeBaseModel) in
            //根据当前收益
            var current = self.viewModel.balloonModel.mineSumNum?.doubleValue
            current = current! + (balloonModel.bonus?.doubleValue)!
            self.mineMiningVw.cumulativeIncomeLab.text = LanguageHelper.getString(key: "Mine_Mining_Cumulative") + Tools.setNSDecimalNumber(NSNumber(value: current!))
        }
    }
    
    func getListData(){
        let parameters = ["token":self.token,"pageSize":"\(self.pageSize)","lineSize":"\(self.lineSize)"]
        viewModel.loadSuccessfullyReturnedData(requestType: .get, URLString: ZYConstAPI.kAPIGetMine, parameters: parameters, showIndicator: false) {(newData:Bool) in
            if newData{
                self.pageSize = self.pageSize + 1
            }else{
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.tableView.reloadData()
        }
        self.tableView.mj_footer.endRefreshing()
    }
    
    func createBalloon(){
        if viewModel.balloonModel.mineDetails?.count != 0 {
            let arr = viewModel.balloonModel.mineDetails
            //冒泡
            for item in 0...(arr?.count)! - 1 {
                let model = arr![item]
                let price = Tools.setNSDecimalNumber(model.bonus!)
                
                let lab = UILabel()
                lab.text = price
                lab.font = UIFont.systemFont(ofSize: 14)
                lab.textColor = UIColor.white
                lab.textAlignment = .center
                let size = lab.getStringSize(text: lab.text!, size: CGSize(width:SCREEN_WIDTH,height:14), font: 14)
                imgaeSize = Int(size.width) + 40
                lab.frame = CGRect(x: 0, y: 0, width: CGFloat(imgaeSize), height: CGFloat(imgaeSize))
                print(imgaeSize)
                
                
                //生成一个X轴的随机数
                let newX = createRandomManFor(start:imgaeSize,end: Int(SCREEN_WIDTH) - imgaeSize)
                //规则说明的部位
                let newY = createRandomManFor(start:imgaeSize,end: Int(mineMiningVw.ruleDescriptionBtn.frame.origin.y) - imgaeSize)
                let bgVw = UIView()
                bgVw.frame = CGRect(x:newX(), y: newY(), width: imgaeSize, height: imgaeSize)
                bgVw.tag = viewTag + item
                mineMiningVw.addSubview(bgVw)
                
                let imgaeView = UIImageView()
                imgaeView.image = UIImage.init(named: "ic_balloon")
                imgaeView.frame = CGRect(x:0, y:0, width: imgaeSize, height: imgaeSize)
                bgVw.addSubview(imgaeView)
                
                bgVw.addSubview(lab)
                
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: 0, y: 0, width: CGFloat(imgaeSize), height: CGFloat(imgaeSize))
                btn.addTarget(self, action: #selector(touchTheBubble(_:)), for: .touchUpInside)
                btn.tag = item
                bgVw.addSubview(btn)
            }
        }
    }
    
    @objc func touchTheBubble(_ sender:UIButton){
        let views = self.view.viewWithTag(self.viewTag + sender.tag)
        UIView.animate(withDuration: 0.5, animations: {
            views?.frame = CGRect(x: self.cumulativeIncomeCenter.x, y: self.cumulativeIncomeCenter.y, width: CGFloat(self.imgaeSize), height:CGFloat(self.imgaeSize))
        }) { (finish) in
            views?.isHidden = true
            views?.removeFromSuperview()
        }
        addData(sender.tag)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return style == .incomeStyle ? viewModel.mineListModel.count : viewModel.rankModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if style == .incomeStyle {
            let cell = Bundle.main.loadNibNamed("MineMiningCell", owner: nil, options: nil)?[0] as! MineMiningCell
            cell.selectionStyle = .none
            cell.model = viewModel.mineListModel[indexPath.row]
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("MineMiningRankingVC", owner: nil, options: nil)?[0] as! MineMiningRankingVC
            cell.selectionStyle = .none
            cell.model = viewModel.rankModel[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

