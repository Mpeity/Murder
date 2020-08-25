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
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        choiceLabel.textColor = HexColor(LightGrayColor)
    }

}
