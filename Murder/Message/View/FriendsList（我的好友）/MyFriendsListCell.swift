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
    
    var itemModel: FriendListModel? {
        didSet {
            guard let itemModel = itemModel else {
                return
            }
            
            if itemModel.head != nil {
                let head = itemModel.head
                avatarImgView.setImageWith(URL(string: head!))
            }
            if itemModel.sexText != nil {
                
            }
            if itemModel.nickname != nil {
                nicknameLabel.text = itemModel.nickname!
            }
            
            if itemModel.sexText != nil {
                let sex = itemModel.sexText!
                switch sex {
                case "男":
                    sexImgView.image = UIImage(named: "sex_man")
                case "女":
                    sexImgView.image = UIImage(named: "sex_woman")
                default:
                    break
                }
            }
            
            if itemModel.gameStatus != nil {
                let status = itemModel.gameStatus
                // 游戏状态【0空闲1准备中2游戏中3离线
                switch status {
                case 0:
                    statusLabel.text = "アイドル中"
                    statusLabel.textColor = HexColor("#9A57FE")
                    break
                case 1:
                    statusLabel.text = "準備中"
                    statusLabel.textColor = HexColor("#FEAD21")

                    break
                case 2:
                    statusLabel.text = "ゲームで"
                    statusLabel.textColor = HexColor("#FE5757")

                    break
                case 3:
                    statusLabel.text = "オフライン"
                    statusLabel.textColor = HexColor("#999999")

                    break
                default:
                    break
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

extension MyFriendsListCell {
    private func setUI() {
        nicknameLabel.textColor = HexColor(DarkGrayColor)
        statusLabel.textColor = HexColor(MainColor)
        statusLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
}

