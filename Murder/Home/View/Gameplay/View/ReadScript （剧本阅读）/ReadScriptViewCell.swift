//
//  ReadScriptViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import YYKit

// 点击textViewBlock回掉
typealias textViewTapBlcok = (Bool) ->()

class ReadScriptViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var titleLabel: YYLabel!
    var textViewSelected: Bool = false
    
    
    var textViewTapBlcok : textViewTapBlcok?
    
    
    var itemModel: GPChapterModel? {
        didSet {
            if itemModel != nil {
                textViewSelected = false
                
                if itemModel?.content != nil {
                    let content = itemModel?.content
                    let myMutableString = try! NSMutableAttributedString(data: (content!.data(using: String.Encoding.unicode))!, options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType:NSMutableAttributedString.DocumentType.html], documentAttributes: nil)
                      let range = NSMakeRange(0, myMutableString.length)
                      myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#666666"), range: range)
                      myMutableString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)], range: range)

                      titleLabel.attributedText = myMutableString
                    
                }
                
            }
        }
    }
    
    var logChapterModel: ScriptLogChapterModel? {
        didSet {
            if logChapterModel != nil {
                // 富文本
                if logChapterModel?.content != nil {
                    let content = logChapterModel?.content
                    
                    let myMutableString = try! NSMutableAttributedString(data: (content!.data(using: String.Encoding.unicode))!, options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType:NSMutableAttributedString.DocumentType.html], documentAttributes: nil)
                        let range = NSMakeRange(0, myMutableString.length)
                        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#666666"), range: range)
                        myMutableString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)], range: range)
  
                       titleLabel.attributedText = myMutableString
                }
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = HexColor("#F5F5F5")
        // contentInset  这个属性设置的是textView到容器之间的距离，这个值设成非零后，四个方向都会有弹簧效果
        
        // 这个属性设置的是容器到文字之间的距离
//        textView.textContainerInset = UIEdgeInsets(top: 22, left: 0, bottom: 15, right: 0)
//
//        textView.backgroundColor = HexColor("#F5F5F5")
//        textView.textColor = HexColor("#666666")
//        textView.font = UIFont.systemFont(ofSize: 15.0)
//        textView.isEditable = false
//        textView.isScrollEnabled = false
//        textView.showsVerticalScrollIndicator = false
//        textView.showsHorizontalScrollIndicator = false
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        textView.addGestureRecognizer(tap)
        
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.textColor = HexColor(LightDarkGrayColor)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        titleLabel.addGestureRecognizer(tap)
        titleLabel.backgroundColor = HexColor("#F5F5F5")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ReadScriptViewCell {
    @objc func tapAction(){
        
        textViewSelected = !textViewSelected
        if textViewSelected {
            print("textViewSelected\(textViewSelected)")
        } else {
            print("no_textViewSelected\(textViewSelected)")
        }
        textViewTapBlcok!(textViewSelected)
    }
}
