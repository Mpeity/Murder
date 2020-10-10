//
//  RecordDetailViewCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/26.
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
    
    // 添加好友
    @IBOutlet weak var addFriendView: UIImageView!
    
    var itemModel: ScriptLogDetailUserModel? {
        didSet {
            guard let itemModel =  itemModel else {
                return
            }
            if itemModel.userHead != nil {
                avartImgView.setImageWith(URL(string: itemModel.userHead!))
            }
            
            if itemModel.userNickname != nil {
                nicknameLabel.text = itemModel.userNickname!
            }
            
            if itemModel.roleHead != nil {
                headerImgView.setImageWith(URL(string: itemModel.roleHead!))
            }
            
            if itemModel.roleName != nil {
                gameNameLabel.text = itemModel.roleName!
            }
            
            if itemModel.expScore != nil {
                experienceLabel.text = "EXP：\(itemModel.expScore!)"
            }
            
            if itemModel.score != nil {
                scoreLabel.text = "スコア：\(itemModel.score!)"
            }
            
            if itemModel.isFriend == 1 { // 好友
                addFriendView.isHidden = true
            } else {
                addFriendView.isHidden = false
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


extension RecordDetailViewCell {
    private func setUI() {
        self.backgroundColor = HexColor("#F5F5F5")
        nicknameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        gameNameLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        scoreLabel.font = UIFont.systemFont(ofSize: 14)
        scoreLabel.textColor = HexColor(LightOrangeColor)
        
        experienceLabel.textColor = HexColor(MainColor)
        experienceLabel.font = UIFont.systemFont(ofSize: 14)
        
        addFriendView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(addFriendTap))
        addFriendView.addGestureRecognizer(tap)
    }
    
    @objc private func addFriendTap() {
        applyFriendRequest(receive_id: itemModel!.userId!) {(result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                showToastCenter(msg: "友達申し込みを提出しました")
            }
        }
    }
}
