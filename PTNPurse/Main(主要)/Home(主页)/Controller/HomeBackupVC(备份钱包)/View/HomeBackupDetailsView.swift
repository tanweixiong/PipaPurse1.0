//
//  HomeBackupDetailsView.swift
//  PTNPurse
//
//  Created by tam on 2018/1/24.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

protocol HomeBackupDetailsViewDelegate {
    func homeBackupDetailsChooseMemorandum(memorandum:String)
}
class HomeBackupDetailsView: UIView {
    fileprivate var memoryWordsArr = NSMutableArray()
    fileprivate var chooseMemoryWordsArr = NSMutableArray()
    var delegate:HomeBackupDetailsViewDelegate?
    fileprivate let itemSpace:CGFloat = 10
    fileprivate let lineSpace:CGFloat = 10
    fileprivate let column:Int = 4
    fileprivate let labelHeight:CGFloat = 40;
    fileprivate var labelWidth:CGFloat = 0
    fileprivate let memoryWordsHeight:CGFloat = 100
    fileprivate var addIndex:Int = 0
    fileprivate var chooseBtn = UIButton()
    fileprivate let chooseBtnArray = NSMutableArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.setUI()
    }
    
    init(frame: CGRect,dataArray:NSArray) {
        super.init(frame: frame)
        self.frame = frame
        self.chooseMemoryWordsArr.addObjects(from: dataArray as! [Any])
        self.setUI()
    }
    
    func setUI(){
        addSubview(scrollView)
        scrollView.addSubview(titlesLabel)
        scrollView.addSubview(memoryWordsVw)
        addSubview(lineView)
        
        labelWidth = (self.frame.size.width - itemSpace * CGFloat(( column + 1)) ) / CGFloat(column)
        self.setChooseMemoryWordBtn()
    }
    
    func setChooseMemoryWordBtn(){
        if chooseMemoryWordsArr.count != 0 {
            for index in 0...chooseMemoryWordsArr.count - 1 {
                let title = self.chooseMemoryWordsArr[index] as! String
                let btn = UIButton(type: .custom)
                btn.frame = self.MYCHANNEL_FRAME(i: index, maxY:0)
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(UIColor.R_UIColorFromRGB(color: 0x828A9E), for: .normal)
                btn.setTitleColor(UIColor.white, for:.selected)
                btn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
                btn.layer.borderWidth = 1
                btn.clipsToBounds = true
                btn.layer.cornerRadius = 5
                btn.tag = index
                btn.addTarget(self, action: #selector(onClick(_:)), for: .touchUpInside)
                chooseMemoryWordsVw.addSubview(btn)
                if title.count > 2 {
                    btn.titleLabel?.adjustsFontSizeToFitWidth = true;
                }
                //最后一项则改变试图高度
                if index == chooseMemoryWordsArr.count - 1 {
                    determineBtn.frame = CGRect(x: 15, y: btn.frame.maxY + 86, width: SCREEN_WIDTH - 30, height: 50)
                    chooseMemoryWordsVw.addSubview(determineBtn)
                    chooseMemoryWordsVw.frame.size.height = determineBtn.frame.maxY
                }
            }
            scrollView.contentSize = CGSize(width: 0, height:  chooseMemoryWordsVw.frame.maxY)
            scrollView.addSubview(chooseMemoryWordsVw)
        }
    }
    
   @objc func onClick(_ sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            addBtn(sender)
            self.setBtnSelectedStyle(sender)
        }else{
            deleteBtn(sender)
            self.setBtnNormalStyle(sender)
        }
    }
    
    @objc func addBtn(_ sender:UIButton){
        let re2 = self.convert(sender.frame.origin, from: chooseMemoryWordsVw)
        let tag = sender.tag
        let title = self.chooseMemoryWordsArr[tag] as! String
        let btn =  self.addCustomBtn(rect: CGRect(x: re2.x, y: re2.y, width: labelWidth, height: labelHeight), name: title, index: tag)
        UIView.animate(withDuration: 0.5, animations: {
            btn.frame = self.MYCHANNEL_FRAME(i:self.addIndex, maxY:-15)
        }) { (finish:Bool) in
            if btn.frame.maxY > self.memoryWordsHeight {
                let maxY = btn.frame.maxY
                self.setChangeView(maxY: maxY)
            }
        }
        let model = HomeBackupDetailsModel(name: title, tag: tag)
        self.chooseBtnArray.add(model)
        self.addIndex = self.addIndex + 1
    }
    
    @objc func deleteBtn(_ sender:UIButton){
        self.addIndex = self.addIndex - 1
        for view in memoryWordsVw.subviews {
            view.removeFromSuperview()
        }
        let newchooseBtnArray = NSMutableArray()
        newchooseBtnArray.addObjects(from: chooseBtnArray as! [Any])
        if chooseBtnArray.count != 0 {
            var btn = UIButton()
            for index in 0...chooseBtnArray.count - 1 {
                let model = chooseBtnArray[index] as! HomeBackupDetailsModel
                if model.tag == sender.tag{
                    newchooseBtnArray.removeObject(at: index)
                }
            }
            chooseBtnArray.removeAllObjects()
            chooseBtnArray.addObjects(from: newchooseBtnArray as! [Any])
            
            if chooseBtnArray.count == 0 {
               return
            }
            
            for index in 0...chooseBtnArray.count - 1 {
                let model = chooseBtnArray[index] as! HomeBackupDetailsModel
                btn = self.addCustomBtn(rect:MYCHANNEL_FRAME(i: index, maxY: -15), name: model.name!, index: index)
            }
    
            if btn.frame.maxY + 50 > memoryWordsHeight {
                let maxY = btn.frame.maxY
                self.setChangeView(maxY: maxY)
            }
        }
    }
    
    func setBtnNormalStyle(_ btn:UIButton){
        btn.backgroundColor = UIColor.clear
        btn.layer.borderColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6).cgColor
    }
    
    func setBtnSelectedStyle(_ btn:UIButton){
        btn.backgroundColor = R_UIThemeColor
        btn.layer.borderColor = UIColor.clear.cgColor
    }
    
    func addCustomBtn(rect:CGRect,name:String,index:NSInteger)->UIButton{
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = R_UIThemeColor
        btn.setTitle(name, for: .normal)
        btn.frame = rect
        btn.tag = index
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        memoryWordsVw.addSubview(btn)
        return btn
    }
    
    func setChangeView(maxY:CGFloat){
        self.memoryWordsVw.frame.size.height = maxY + self.itemSpace
        self.chooseMemoryWordsVw.frame.origin.y = self.memoryWordsVw.frame.maxY
        self.lineView.frame.origin.y = self.memoryWordsVw.frame.maxY - 0.5
        self.scrollView.contentSize = CGSize(width: 0, height: self.chooseMemoryWordsVw.frame.maxY + 50)
    }
    
    lazy var titlesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x828A9E)
        label.font = UIFont.systemFont(ofSize: 12)
        label.frame = CGRect(x: 15, y: 25, width: SCREEN_WIDTH - 30, height: 17)
        label.text = LanguageHelper.getString(key: "homePage_Backup_Wallet_Mnemonic")
        return label
    }()
    
    lazy var memoryWordsVw: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: titlesLabel.frame.maxY + 10, width: SCREEN_WIDTH, height: memoryWordsHeight)
        return view
    }()
    
    lazy var chooseMemoryWordsVw: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: memoryWordsVw.frame.maxY, width: SCREEN_WIDTH, height: 0)
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 15, y:memoryWordsVw.frame.maxY - 0.5 , width: SCREEN_WIDTH - 30, height: 0.5)
        view.backgroundColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
        return view
    }()
    
    lazy var determineBtn: UIButton = {
        let btn  = UIButton(type: .system)
        btn.setTitle(LanguageHelper.getString(key: "homePage_Backup_Wallet_Confirm_Backup"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = R_UIThemeColor
        btn.addTarget(self, action: #selector(backupOnClick), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
    
    @objc func backupOnClick(){
        let backupArray = NSMutableArray()
        if chooseBtnArray.count != 0 {
            for item in 0...chooseBtnArray.count - 1 {
                let model = chooseBtnArray[item] as! HomeBackupDetailsModel
                backupArray.add(model.name!)
            }
        }
        let backupString = backupArray.componentsJoined(by: ",")
        self.delegate?.homeBackupDetailsChooseMemorandum(memorandum: backupString)
    }
    
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.clipsToBounds = false;
        scrollView.bounces = false;
        return scrollView
    }()
    
    func MYCHANNEL_FRAME(i:Int,maxY:CGFloat)->CGRect{
        return CGRect(x: itemSpace + CGFloat((i % column)) * (labelWidth + itemSpace), y: maxY + lineSpace + CGFloat((i / column)) * (labelHeight + lineSpace), width: labelWidth, height: labelHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
