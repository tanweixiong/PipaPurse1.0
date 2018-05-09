//
//  BusinessSubmissionMessageVW.swift
//  PTNPurse
//
//  Created by tam on 2018/3/26.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class BusinessSubmissionMessageVW: UIView {
    @IBOutlet weak var reasonLab: UILabel! //投诉原因
    @IBOutlet weak var reasonTitleLab: UILabel!
    @IBOutlet weak var explainLab: UILabel!//投诉说明
    @IBOutlet weak var explainTitleLab: UILabel!
    @IBOutlet weak var officialReplyLab: UILabel!//官方回复
    @IBOutlet weak var officialRreplyLab: UILabel!
    @IBOutlet weak var replyVw: UIView!
    @IBOutlet weak var lineVw: UIView!
    @IBOutlet weak var replyNorVw: UIView!
    
    @IBOutlet weak var dataTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        reasonTitleLab.text = LanguageHelper.getString(key: "C2C_transaction_Reason")
        explainTitleLab.text = LanguageHelper.getString(key: "C2C_transaction_Explain")
        officialRreplyLab.text = LanguageHelper.getString(key: "C2C_transaction_Officia_reply")
    }
    
}
