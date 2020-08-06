//
//  PrepareRoomCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PrepareRoomCell: UITableViewCell {
    // 背景视图
    @IBOutlet weak var bgView: UIView!
    // 游戏头像
    @IBOutlet weak var roleImgView: UIImageView!
    // 游戏名称
    @IBOutlet weak var roleNameLabel: UILabel!
    // 准备按钮
    @IBOutlet weak var prepareBtn: UIButton!
    // 进度显示
    @IBOutlet weak var progressLabel: UILabel!
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    
    // 房主
    @IBOutlet weak var ownerLabel: UILabel!
    // 
    @IBOutlet weak var commonLabel: NSLayoutConstraint!
    // 说话 绿点显示
    @IBOutlet weak var pointView: UIView!
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

extension PrepareRoomCell {
    func setUI() {
        
        bgView.backgroundColor = HexColor("#20014D")
        bgView.layer.cornerRadius = 10
        bgView.layer.borderColor = HexColor("#3E1180").cgColor
        bgView.layer.borderWidth = 1
        
        roleNameLabel.textColor = UIColor.white
        roleNameLabel.font = UIFont.systemFont(ofSize: 15)
        
        progressLabel.textColor = HexColor("#FC3859")
        progressLabel.isHidden = true
        progressLabel.backgroundColor = UIColor.clear
        prepareBtn.layer.cornerRadius = 7.5
        
        
        avatarImgView.layer.cornerRadius = 20
        ownerLabel.textColor = HexColor("#230254")
        ownerLabel.backgroundColor = HexColor(LightOrangeColor)
        ownerLabel.layer.cornerRadius = 5
        ownerLabel.layer.masksToBounds = true
        
        
        
    
        
        
        
    }
}
