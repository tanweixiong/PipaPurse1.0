//
//  LoginNoteTextView.swift
//  PTNPurse
//
//  Created by zhengyi on 2018/1/19.
//  Copyright © 2018年 Wilkinson. All rights reserved.
//

import UIKit

class LoginNoteTextView: ILXibView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteTextView: NoteTextView!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setViewStyle()
    }
    
    func setViewStyle() {
        
        titleLabel.textColor = R_ZYGrayColor
        titleLabel.font = UIFont.init(name: R_ThemeFontName, size: R_ZYTitlFontSize)
        
        noteTextView.textView.textColor = R_ZYGrayColor
        noteTextView.textView.font = UIFont.init(name: R_ThemeFontName, size: R_ZYTitlFontSize)
        noteTextView.placeholderLabel.textColor = R_ZYPlaceholderColor
        noteTextView.placeholderLabel.font = UIFont.init(name: R_ThemeFontName, size: R_ZYTitlFontSize)
        lineView.backgroundColor = R_ZYGrayColor
        
        lineView.backgroundColor = R_ZYPlaceholderColor
        
    }
    
    func setNoteViewContent(title: String, placeHolder: String) {
        titleLabel.text = title
        noteTextView.setPlaceholder(placeholder: placeHolder, color: R_ZYPlaceholderColor)
    }
    
    
}
