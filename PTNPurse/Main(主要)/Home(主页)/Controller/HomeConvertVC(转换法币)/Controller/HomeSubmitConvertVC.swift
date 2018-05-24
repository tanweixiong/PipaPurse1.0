//
//  HomeSubmitConvertVC.swift
//  PipaPurse
//
//  Created by tam on 2018/5/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeSubmitConvertVC: MainViewController {
    @IBOutlet weak var convertBtn: UIButton!{
        didSet{
            convertBtn.layer.borderWidth = 1
            convertBtn.layer.borderColor = R_UIThemeColor.cgColor
        }
    }
    @IBOutlet weak var navi: UIView!{
        didSet{
            navi.backgroundColor = R_UIThemeColor
        }
    }
    @IBOutlet weak var convertNumLab: UILabel!{
        didSet{
            convertNumLab.text = LanguageHelper.getString(key: "C2C_publish_order_Number")
        }
    }
    @IBOutlet weak var convertNumTF: UITextField!{
        didSet{
            convertNumTF.text = LanguageHelper.getString(key: "C2C_publish_order_Please_enter_the_number_of_transactions")
        }
    }
    @IBOutlet weak var availableLab: UILabel!
    @IBOutlet weak var freezeLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    lazy var detsilsAssetsView: HomeDetsilsAssetsView = {
        let view = Bundle.main.loadNibNamed("HomeDetsilsAssetsView", owner: nil, options: nil)?.last as! HomeDetsilsAssetsView
        view.frame = CGRect(x: 0, y: Int(MainViewControllerUX.naviNormalHeight + 15), width: Int(SCREEN_WIDTH), height: 35)
        view.backgroundColor = R_UIThemeSkyBlueColor
        view.availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：0"
        view.freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：0"
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return OCTools.existenceDecimal(textField.text, range: range, replacementString: string)
    }
    
    @IBAction func convertOnClick(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeSubmitConvertVC {
    func setupUI(){
         setNormalNaviBar(title:LanguageHelper.getString(key: "Home_Alert_Conver"))
         availableLab.text = LanguageHelper.getString(key: "homepage_Amount_Available") + "：0"
         freezeLab.text = LanguageHelper.getString(key: "homepage_Freeze_Amount") + "：0"
    }
   
}


