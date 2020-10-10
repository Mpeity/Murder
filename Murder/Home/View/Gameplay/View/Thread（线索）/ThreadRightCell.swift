//
//  ThreadRightCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ThreadRightCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var pointView: UIView!
    
    // 私有 标签
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var clueListModel : ClueListModel? {
        didSet {
            guard let clueListModel = clueListModel else {
                return
            }
            titleLabel.text = clueListModel.scriptClueName
            contentLabel.text = clueListModel.scriptClueDetail
            if clueListModel.isRead == 0 {
                pointView.isHidden = false
            } else {
                pointView.isHidden = true
            }
            if clueListModel.isPrivate == 0 { // 独有
                tagLabel.isHidden = true
            } else {
                tagLabel.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = HexColor("#F5F5F5")
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        tagLabel.layer.cornerRadius = 8.5
        tagLabel.layer.masksToBounds = true
        
        tagLabel.backgroundColor = HexColor(LightOrangeColor)
        contentLabel.textColor = HexColor(LightGrayColor)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


