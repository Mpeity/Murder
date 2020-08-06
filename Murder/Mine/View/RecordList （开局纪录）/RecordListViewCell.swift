//
//  RecordListViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class RecordListViewCell: UITableViewCell {
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    // 开局时间
    @IBOutlet weak var startTimeLabel: UILabel!
    // 本局时间
    @IBOutlet weak var timeLabel: UILabel!
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


extension RecordListViewCell {
    private func setUI() {
        coverImgView.layer.cornerRadius = 10
        
        
        startTimeLabel.textColor = HexColor(LightDarkGrayColor)
        startTimeLabel.font = UIFont.systemFont(ofSize: 12)
        
        timeLabel.textColor = HexColor(LightDarkGrayColor)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
    }
}
