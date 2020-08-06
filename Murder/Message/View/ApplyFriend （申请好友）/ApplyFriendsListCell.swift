//
//  ApplyFriendsListCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/30.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ApplyFriendsListCell: UITableViewCell {
    
    // 头像
   
    @IBOutlet weak var avatarImgView: UIImageView!
    // 性别
    @IBOutlet weak var sexImgView: UIImageView!
    // 昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    // 状态
    @IBOutlet weak var statusLabel: UILabel!
    // 拒绝
    @IBOutlet weak var refuseBtn: UIButton!
    // 通过
    @IBOutlet weak var passBtn: UIButton!
    
    
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

extension ApplyFriendsListCell {
    func setUI() {
        statusLabel.textColor = HexColor(MainColor)
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        refuseBtn.gradientColor(start: "#FA7373", end: "#FF1515", cornerRadius: 5)
        refuseBtn.setTitleColor(UIColor.white, for: .normal)
        passBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 5)
        passBtn.setTitleColor(UIColor.white, for: .normal)
        
        refuseBtn.isHidden = true
        passBtn.isHidden = true
        statusLabel.isHidden = false
        statusLabel.text = "認めた"

    }
}
