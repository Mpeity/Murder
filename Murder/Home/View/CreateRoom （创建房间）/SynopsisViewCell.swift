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
    @IBOutlet weak var contentLabel: YYLabel!
    // 箭头
    @IBOutlet weak var boultBtn: UIButton!
    
    var boultBtnBlock : BoultBtnBlock?
    
    
    var content: String! {
        didSet {
            guard let content = content else {
                return
            }
//            contentLabel.text = content
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.white
        
        contentLabel.textColor = HexColor(LightGrayColor)
        boultBtn.addTarget(self, action: #selector(boultBtnAction(button:)), for: .touchUpInside)
        contentLabel.text = "「あの人と出会えることは神様の恩賜だろう。しかしあの人と愛し合うことは腐れ縁だとう。」 あなたの名前はフラ、昔あなたのお爺さんは一応役人だ、でも上司から陥れられ、一族は落ちぶれた。幼いあなたは伶人になって、家族と離れ離れになってしまった、自分の本名も覚えられない。数年後、あなたは伊勢守の上泉家に買われ、家の侍女となった。「あの人と出会えることは神様の恩賜だろう。しかしあの人と愛し合うことは腐れ縁だとう。」 あなたの名前はフラ、昔あなたのお爺さんは一応役人だ、でも上司から陥れられ、一族は落ちぶれた。幼いあなたは伶人になって、家族と離れ離れになってしまった、自分の本名も覚えられない。数年後、あなたは伊勢守の上泉家に買われ、家の侍女となった"
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            boultBtn.isSelected = true
        } else {
            boultBtn.isSelected = false
        }
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
