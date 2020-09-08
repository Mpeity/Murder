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
            contentLabel.text = content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.white
        
        contentLabel.textColor = HexColor(LightGrayColor)
        boultBtn.addTarget(self, action: #selector(boultBtnAction(button:)), for: .touchUpInside)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            boultBtn.isSelected = true
            boultBtn.setImage(UIImage(named: "jiantou_up"), for: .normal)
        } else {
            boultBtn.isSelected = false
            boultBtn.setImage(UIImage(named: "jiantou_down"), for: .normal)
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
