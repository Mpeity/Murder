//
//  RecordDetailViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class RecordDetailViewCell: UITableViewCell {
    // 金牌
    @IBOutlet weak var iconLabel: UILabel!
    // 排名
    @IBOutlet weak var iconImgView: UIImageView!
    
    // 用户昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    
    // 用户头像
    @IBOutlet weak var avartImgView: UIImageView!
    // 箭头图片
    @IBOutlet weak var boultImgView: UIImageView!
    // 游戏头像
    @IBOutlet weak var headerImgView: UIImageView!
    // 游戏名字
    @IBOutlet weak var gameNameLabel: UILabel!
    
    // 得分
    @IBOutlet weak var scoreLabel: UILabel!
    // 经验
    @IBOutlet weak var experienceLabel: UILabel!
    
    
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


extension RecordDetailViewCell {
    private func setUI() {
        self.backgroundColor = HexColor("#F5F5F5")
        nicknameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        gameNameLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        scoreLabel.font = UIFont.systemFont(ofSize: 14)
        scoreLabel.textColor = HexColor(LightOrangeColor)
        
        experienceLabel.textColor = HexColor(MainColor)
        experienceLabel.font = UIFont.systemFont(ofSize: 14)
        

    }
}
