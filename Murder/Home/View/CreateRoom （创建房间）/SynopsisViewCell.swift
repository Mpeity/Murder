//
//  SynopsisViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import YYKit

typealias BoultBtnBlock = (Bool) -> ()


class SynopsisViewCell: UITableViewCell {
    // 内容
    @IBOutlet weak var contentLabel: UILabel!
    // 箭头
    @IBOutlet weak var boultBtn: UIButton!
    
    var boultBtnBlock : BoultBtnBlock?
    
    
    var content: String! {
        didSet {
            guard let content = content else {
                return
            }
            

//            let myMutableString = try! NSMutableAttributedString(data: (content.data(using: String.Encoding.unicode))!, options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType:NSMutableAttributedString.DocumentType.html], documentAttributes: nil)
//            let range = NSMakeRange(0, myMutableString.length)
//            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#666666"), range: range)
//            myMutableString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)], range: range)
            
            guard let news = content.removingPercentEncoding,let data = news.data(using: .unicode) else{return}
            let att = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html]
            guard let attStr = try? NSMutableAttributedString(data: data, options: att, documentAttributes: nil) else{return}
            let range = NSMakeRange(0, attStr.length)
//            attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)], range: range)
            
            
            
            
            contentLabel.attributedText = attStr

            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.white

        contentLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentLabel.textColor = HexColor(LightDarkGrayColor)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        boultBtn.addTarget(self, action: #selector(boultBtnAction(button:)), for: .touchUpInside)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
//        if selected {
//            boultBtn.isSelected = true
//            boultBtn.setImage(UIImage(named: "jiantou_up"), for: .normal)
//        } else {
//            boultBtn.isSelected = false
//            boultBtn.setImage(UIImage(named: "jiantou_down"), for: .normal)
//        }
    }
    
}

extension SynopsisViewCell {
    @objc func boultBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
        if boultBtnBlock != nil {
            boultBtnBlock!(button.isSelected)
        }
    }
}
