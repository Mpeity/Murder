//
//  MessageListCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/25.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

// 头像点击手势
typealias AvatarImgTapBlcok = () ->()

class MessageListCell: UITableViewCell {
    
    var avatarImgTapBlcok : AvatarImgTapBlcok?

    
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    // 红色提示点
    @IBOutlet weak var pointView: UIView!
    // 昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    // 消息
    @IBOutlet weak var messageLabel: UILabel!
    // 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    var itemModel: MessageListModel? {
        didSet {
            guard let itemModel = itemModel else {
                return
            }
            
            if itemModel.head != nil {
                avatarImgView.setImageWith(URL(string: itemModel.head!))
            }
            
            if itemModel.nickname != nil {
                nicknameLabel.text = itemModel.nickname!
            }
            
            if itemModel.content != nil {
                messageLabel.text = itemModel.content!
            }
            if itemModel.createTime != nil {
                timeLabel.text = itemModel.createTime!
            }
            
            if itemModel.noReadNum ?? 0 > 0 {
                pointView.isHidden = false
            } else {
                pointView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        nicknameLabel.textColor = HexColor(DarkGrayColor)
        timeLabel.textColor = HexColor(LightGrayColor)
        messageLabel.textColor = HexColor(LightGrayColor)
        
        
        avatarImgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarImgTapAction))
        avatarImgView.addGestureRecognizer(tap)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension MessageListCell {
    @objc func avatarImgTapAction() {
        guard let avatarImgTapBlcok: AvatarImgTapBlcok = avatarImgTapBlcok else { return }
        avatarImgTapBlcok()
    }
}
