//
//  VoteAnswerCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class VoteAnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var choiceLabel: UILabel!
    
    @IBOutlet weak var choiceBtn: UIButton!
    
    var itemModel : TrueAnswerModel? {
        didSet {
            if itemModel?.answerTitle != nil {
                choiceLabel.text = itemModel?.answerTitle
            }
            if itemModel?.num != nil {
                choiceBtn.setTitle(itemModel?.num!, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choiceBtn.layer.cornerRadius = 12.5
        choiceBtn.layer.borderColor = HexColor(LightGrayColor).cgColor
        choiceBtn.layer.borderWidth = 0.5
        choiceLabel.textColor = HexColor(LightDarkGrayColor)
        choiceLabel.font = UIFont.systemFont(ofSize: 15)
    }

}
