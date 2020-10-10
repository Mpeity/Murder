//
//  FriendReportCell.swift
//  Murder
//
//  Created by m.a.c on 2020/9/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class FriendReportCell: UICollectionViewCell {
    
    @IBOutlet weak var choiceBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
        
    }
}

extension FriendReportCell {
    
    private func setUI() {
        choiceBtn.setImage(UIImage(named: "report_selected"), for: .selected)
        choiceBtn.setImage(UIImage(named: "report_unselected"), for: .normal)
        choiceBtn.isSelected = false
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
    }
}
