//
//  MyFriendsListCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MyFriendsListCell: UITableViewCell {
    
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    
    // 性别
    @IBOutlet weak var sexImgView: UIImageView!
    // 昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    // 状态
    @IBOutlet weak var statusLabel: UILabel!
    
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

extension MyFriendsListCell {
    private func setUI() {
        nicknameLabel.textColor = HexColor(DarkGrayColor)
        statusLabel.textColor = HexColor(MainColor)
        statusLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
}

