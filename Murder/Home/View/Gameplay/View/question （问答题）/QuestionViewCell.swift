//
//  QuestionViewCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class QuestionViewCell: UITableViewCell {
    
    @IBOutlet weak var choiceBtn: UIButton!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var itemModel : ScriptAnswerModel? {
        didSet {
            guard itemModel != nil else {
                return
            }
            
            if itemModel?.answerTitle != nil {
                contentLabel.text = itemModel?.answerTitle!
            }
            
            if itemModel?.num != nil {
                choiceBtn.setTitle(itemModel?.num, for: .normal)
            }
            
            if itemModel?.isCheck == true {
                choiceBtn.setTitleColor(UIColor.white, for: .normal)
                choiceBtn.backgroundColor = HexColor(MainColor)
                choiceBtn.layer.borderColor = HexColor(MainColor).cgColor
                contentLabel.textColor = HexColor(MainColor)
            } else {
                choiceBtn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
                choiceBtn.backgroundColor = HexColor("#F5F5F5")
//                choiceBtn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
                choiceBtn.layer.borderColor = HexColor(LightGrayColor).cgColor
                contentLabel.textColor = HexColor(DarkGrayColor)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choiceBtn.isUserInteractionEnabled = false
        choiceBtn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
        choiceBtn.layer.borderWidth = 0.5
        choiceBtn.layer.cornerRadius = choiceBtn.bounds.size.width*0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
//        choiceBtn.isSelected = selected
//        if selected {
//            choiceBtn.setTitleColor(UIColor.white, for: .normal)
//            choiceBtn.backgroundColor = HexColor(MainColor)
//            choiceBtn.layer.borderColor = HexColor(MainColor).cgColor
//            contentLabel.textColor = HexColor(MainColor)
//        } else {
//            choiceBtn.backgroundColor = HexColor("#F5F5F5")
//            choiceBtn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
//            choiceBtn.layer.borderColor = HexColor(LightGrayColor).cgColor
//            contentLabel.textColor = HexColor(DarkGrayColor)
//        }
        
    }
    
    
    
}
