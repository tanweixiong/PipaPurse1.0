//
//  HomeConvertVC.swift
//  PipaPurse
//
//  Created by tam on 2018/5/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeConvertVC: MainViewController {
    fileprivate let homeCoinDetailsCell = "HomeCoinDetailsCell"
    fileprivate lazy var viewModel : HomeListDetsilsVM = HomeListDetsilsVM()
    @IBOutlet weak var navi: UIView!{
        didSet{
            navi.backgroundColor = R_UIThemeColor
        }
    }
    @IBOutlet weak var convertBtn: UIButton!{
        didSet{
            convertBtn.layer.borderWidth = 1
            convertBtn.layer.borderColor = R_UIThemeColor.cgColor
        }
    }
    @IBOutlet weak var availableLab: UILabel!
    @IBOutlet weak var freezeLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var detsilsAssetsView: HomeDetsilsAssetsView = {
        let view = Bundle.main.loadNibNamed("HomeDetsilsAssetsView", owner: nil, options: nil)?.last as! HomeDetsilsAssetsView
        view.frame = CGRect(x: 0, y: Int(MainViewControllerUX.naviNormalHeight + 15), width: 375, height: 35)
        view.backgroundColor = R_UIThemeSkyBlueColor
        view.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：0"
        view.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：0"
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: navi.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - navi.frame.maxY - 50))
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeCoinDetailsCell", bundle: nil),forCellReuseIdentifier: self.homeCoinDetailsCell)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    @IBAction func onClick(_ sender: UIButton) {
        if self.viewModel.model.userWallet != nil {
            let vc = HomeSubmitConvertVC()
            vc.model = self.viewModel.model.userWallet
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeConvertVC {
    func setupUI(){
        setNormalNaviBar(title:LanguageHelper.getString(key: "Home_Alert_Conver"))
        availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：0"
        freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：0"
        view.addSubview(tableView)
    }
    
    func getData(){
        let parameters = ["type":Tools.getPTNcoinNo(),"language":Tools.getLocalLanguage(),"token":(UserDefaults.standard.getUserInfo().token)!]
        viewModel.loadDetailsSuccessfullyReturnedData(requestType: .post, URLString: ZYConstAPI.kAPIGetCoinDetail, parameters: parameters, showIndicator: false) {
            let model = self.viewModel.model.userWallet
            let enableBalance = model?.enableBalance == nil ? "0" : model?.enableBalance
            self.detsilsAssetsView.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available")  + "：" + enableBalance!
            let unableBalance = model?.unableBalance == nil ? "0" : model?.unableBalance
            self.detsilsAssetsView.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") +  "：" + unableBalance!
        }
    }
}

extension HomeConvertVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCoinDetailsCell, for: indexPath) as! HomeCoinDetailsCell
        cell.selectionStyle = .none
        cell.convertModel = HomeConvertModel()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

