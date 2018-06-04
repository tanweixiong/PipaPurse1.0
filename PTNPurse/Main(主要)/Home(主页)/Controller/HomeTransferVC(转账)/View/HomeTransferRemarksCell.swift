//
//  HomeTransferRemarksCell.swift
//  PTNPurse
//
//  Created by tam on 2018/1/17.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit
import YYText

class HomeTransferRemarksCell: UITableViewCell,YYTextViewDelegate {
    var HomeTransferRemarksBlock:(()->())?;
    @IBOutlet weak var remarkLabel: UILabel!
    fileprivate let textViewHeight:CGFloat = 50
    fileprivate let footViewHeight:CGFloat = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(){
        contentView.addSubview(textView!)
        contentView.addSubview(lineView)
        contentView.addSubview(footView)
        
        textView?.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(remarkLabel.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.height.equalTo(textViewHeight)
        })
        
        lineView.snp.makeConstraints({ (make) in
            make.top.equalTo((textView?.snp.bottom)!).offset(10)
            make.left.equalTo(contentView.snp.left).offset(15)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.height.equalTo(0.5)
        })
        
        footView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.top.equalTo(lineView.snp.bottom).offset(60)
            make.width.equalTo(footView.frame.size.width)
            make.height.equalTo(footViewHeight)
        }
        
        remarkLabel.text = LanguageHelper.getString(key: "homePage_Finish_Details_Transaction_Remarks")
    }
    
    
    func setReleaseMethodLayer(){
        contentView.addSubview(textView!)
        textView?.snp.makeConstraints({ (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.top.equalTo(remarkLabel.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.height.equalTo(129)
        })
    }
    
    lazy var textView:YYTextView? = {
        let view = YYTextView.init(frame: CGRect.init(x: 0, y: 0, width:0, height: 0))
        view.placeholderText = LanguageHelper.getString(key: "homePage_Leave_Message")
        view.placeholderFont = UIFont.systemFont(ofSize: 14)
        view.placeholderTextColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 14)
        view.delegate = self
        view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: self.textViewHeight)
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var footView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: footViewHeight))
        view.addSubview(submitBtn)
        return view
    }()
    
    lazy var submitBtn:UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: 0, width: SCREEN_WIDTH - 40, height: 50))
        button.setTitle(LanguageHelper.getString(key: "homePage_Confirm_Transfer"), for: .normal)
        button.backgroundColor = R_UIThemeColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(HomeTransferRemarksCell.transferOnClick), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var lineView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
        return view
    }()
    
    func textViewDidChange(_ textView: YYTextView) {
        //截取200个字
        let textContent = textView.text
        let textNum = textContent?.count
        if textNum! > 20 {
            let index = textContent?.index((textContent?.startIndex)!, offsetBy: 20)
            let str = textContent?.substring(to: index!)
            textView.text = str
        }
    }
    
    @objc func transferOnClick(){
        if HomeTransferRemarksBlock != nil {
            HomeTransferRemarksBlock!()
        }
    }
    
}
