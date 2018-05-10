//
//  HomeTransferCell.swift
//  PTNPurse
//
//  Created by tam on 2018/1/16.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class HomeTransferCell: UITableViewCell,RegisterCellFromNib {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var scanCodeBtn: UIButton!
    @IBOutlet weak var textfield: UITextField!

    @IBOutlet weak var lineVw: UIView!
    
    @IBOutlet weak var centersY: NSLayoutConstraint!
    @IBOutlet weak var unitLab: UILabel!
    @IBOutlet weak var triangularBtn: UIButton!
    
    @IBOutlet weak var sccondBlueBackgroundVw: UIButton!
    @IBOutlet weak var firstBluebBackgroundVw: UIView!
    @IBOutlet weak var tfBackGroundDistance: NSLayoutConstraint!
    
    var sliderMin = NSNumber()
    var sliderMax = NSNumber()
    let progressArray = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSlider(){
        contentView.addSubview(sliderView)
        contentView.addSubview(valueLabel)
        
        sliderView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(15)
            make.top.equalTo(headingLabel.snp.bottom).offset(19)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.top.equalTo(sliderView.snp.top).offset(0)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
    }

    lazy var sliderView: PTNSlider = {
        let slider = PTNSlider()
        slider.minimumTrackTintColor = R_UIThemeColor
        slider.maximumTrackTintColor = UIColor.R_UIColorFromRGB(color: 0xCED7E6)
        slider.addTarget(self, action: #selector(changed(slider:)), for: UIControlEvents.valueChanged)
        slider.minimumValue = 0
        return slider
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.textColor = UIColor.R_UIColorFromRGB(color: 0x545B71)
        label.textAlignment = .right
        return label
    }()
    
    @objc func changed(slider:UISlider){
        let progressInt = Int(slider.value)
        if self.progressArray.count != 0 {
            let text = self.progressArray[progressInt]
            if self.progressArray.count == 1 {
                let text = self.progressArray.firstObject
                valueLabel.text = "\(text!)"
            }else{
                let str = text as! String
                let newStr = OCTools.decimalNumber(with: Double(OCTools.formatFloat(Float(str)!))!)
                valueLabel.text = newStr
            }
            slider.setValue(slider.value, animated: false)
        }
    }
    
    func setSliderValue(){
        self.progressArray.removeAllObjects()
        let minFee = self.stringToFloat(str: Tools.setNSDecimalNumber(sliderMin))
        let maxFee = self.stringToFloat(str: Tools.setNSDecimalNumber(sliderMax))
        var currentFee = self.stringToFloat(str: Tools.setNSDecimalNumber(sliderMin))
        
        let minDecimalsCon = "\(sliderMin)"
        var minDecimals = OCTools.getDecimalsNum(Float(minFee))
        if minDecimalsCon.contains(".") == false {
            minDecimals = 1
        }
        
        let maxDecimalsCon = "\(sliderMax)"
        if maxDecimalsCon.contains(".") && minDecimalsCon.contains(".") == false {
           minDecimals = OCTools.getDecimalsNum(Float(maxFee))
           currentFee = maxFee
        }
        
        let sliderMaxs = (maxFee - minFee) * OCTools.getDecimalsOfPlaces(Float(currentFee))
        sliderView.maximumValue = Float(sliderMaxs)
        let count = Int(sliderMaxs)
        var sumNum:CGFloat = 0
        for index in 0...count {
            if index != 0 {
               sumNum = minDecimals + sumNum
            }else{
               sumNum = minFee
            }
            self.progressArray.add(OCTools.decimalNumber(with: Double(sumNum)))
        }
        valueLabel.text = OCTools.formatFloat(Float(minFee))
    }
    
    func stringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
