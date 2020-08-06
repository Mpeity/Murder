//
//  ScriptTableViewCell.swift
//  Murder
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ScriptTableViewCell: UITableViewCell {
    
    /// 剧本封面
    @IBOutlet weak var coverImgView: UIImageView!
    /// 剧本名字
    @IBOutlet weak var nameLabel: UILabel!
    /// 展示标签 
    @IBOutlet weak var tagLabel: UILabel!
    /// 剧本人数
    @IBOutlet weak var numberLabel: UILabel!
    /// 剧本题材
    @IBOutlet weak var themeLabel: UILabel!
    /// 剧本难度
    @IBOutlet weak var difficultyLabel: UILabel!
    
    /// 剧本时长
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - UI
extension ScriptTableViewCell {
    func setUI() {
        // 封面
        coverImgView.layer.cornerRadius = 5
        // 名字
        nameLabel.textColor = HexColor(DarkGrayColor)
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.textAlignment = NSTextAlignment.left
        // 标签
        tagLabel.backgroundColor = ColorWithRGB(r: 255, g: 241, b: 217)
        tagLabel.layer.cornerRadius = 2.5
        tagLabel.textColor = HexColor(LightOrangeColor)
        tagLabel.textAlignment = NSTextAlignment.center
        // 人数
        numberLabel.layer.cornerRadius = 8.5
        numberLabel.layer.borderWidth = 0.5
        numberLabel.layer.borderColor = HexColor(MainColor).cgColor
        numberLabel.textColor = HexColor(MainColor)
        // 题材
        themeLabel.layer.cornerRadius = 8.5
        themeLabel.layer.borderWidth = 0.5
        themeLabel.layer.borderColor = HexColor(MainColor).cgColor
        themeLabel.textColor = HexColor(MainColor)
        
        // 难度
        difficultyLabel.layer.cornerRadius = 8.5
        difficultyLabel.layer.borderWidth = 0.5
        difficultyLabel.layer.borderColor = HexColor(MainColor).cgColor
        difficultyLabel.textColor = HexColor(MainColor)
        
        // 时长
        timeLabel.textColor = HexColor(LightDarkGrayColor)
        
    }
}
