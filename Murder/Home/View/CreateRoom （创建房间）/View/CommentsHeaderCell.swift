//
//  CommentsHeaderCell.swift
//  Murder
//
//  Created by m.a.c on 2020/10/28.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class CommentsHeaderCell: UITableViewCell {
    @IBOutlet weak var headerView: UIView!
    // 评分
    @IBOutlet weak var countLabel: UILabel!
    
    // 星星
    @IBOutlet weak var commonStarView: UIView!
    //
    @IBOutlet weak var contentLabel: UILabel!
    // 头部离底部距离
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    // 是否显示剧透
    @IBOutlet weak var commonLabel: UILabel!
    
    var userScriptStatus: Int? {
        didSet {
            if userScriptStatus != nil {
                if userScriptStatus != 3 {
                    bottomContraint.constant = 45
                    commonLabel.isHidden = false
                } else {
                    bottomContraint.constant = 5
                    commonLabel.isHidden = true
                }
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CommentsHeaderCell {
    private func setUI() {
        headerView.layer.cornerRadius = 5
        headerView.layer.masksToBounds = true
        
        countLabel.textColor = HexColor(LightOrangeColor)
        countLabel.textAlignment = .center
        countLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        
        commonStarView.backgroundColor = UIColor.clear
        
        contentLabel.textColor = HexColor(LightDarkGrayColor)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.backgroundColor = UIColor.clear
        
        
        commonLabel.isHidden = true
        commonLabel.text = "ネタバレのあるコメントは公開していません"
        commonLabel.textAlignment = .center
        commonLabel.backgroundColor = HexColor(hex: MainColor, alpha: 0.1)
        commonLabel.layer.cornerRadius = 5
        commonLabel.layer.masksToBounds = true
        commonLabel.textColor = HexColor(MainColor)
        commonLabel.font = UIFont.systemFont(ofSize: 12)
    }
}
