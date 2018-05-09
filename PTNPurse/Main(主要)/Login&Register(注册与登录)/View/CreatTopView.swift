//
//  CreatTopView.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/18.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

typealias BtnClickCallBack = (_ sender: UIButton) -> Void

class CreatTopView: ILXibView {
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var bgImageview: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var btnCallBack: BtnClickCallBack?
    
    func setButtonCallBack(block: @escaping BtnClickCallBack) {
        self.btnCallBack = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setViewContent(title: String) {
        titleLabel.text = title
    }
    
    @IBAction func backBtnTouched(_ sender: UIButton) {
        
        if btnCallBack != nil {
            btnCallBack!(sender)
        }
        
    }
    
}
