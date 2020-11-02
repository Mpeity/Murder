//
//  CommentsCell.swift
//  Murder
//
//  Created by m.a.c on 2020/10/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//



import UIKit

class CommentsCell: UITableViewCell {
    
    @IBOutlet weak var commonStarView: UIView!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var usedTimeLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    var itemModel: ScriptCommentsItemModel? {
        didSet {
            guard let itemModel = itemModel else {
                return
            }
            
            if itemModel.head != nil {
                let str = itemModel.head!
                avatarImgView.setImageWith(URL(string: str), placeholder: nil)
            }
            
            if itemModel.nickname != nil {
                nameLabel.text = itemModel.nickname!
            }
            
            if itemModel.createTime != nil {
                timeLabel.text = itemModel.createTimeText!
            }
            
            
            
            if itemModel.durationText != nil {
                usedTimeLabel.text = "プレイ時間：\(itemModel.durationText!)"
            }
            
            if itemModel.content != nil {
                commentsLabel.text = itemModel.content!
                var height = commentsLabel.text!.ga_heightForComment(fontSize: 14, width: FULL_SCREEN_WIDTH-30)
                height = height + 90
                if height > 107.0 {
                } else {
                    height = 107
                }
                
                itemModel.cellHeight = height
            }
   
            if itemModel.star != nil {
                if commonStarView.subviews.count > 0 {
                    commonStarView.removeAllSubviews()
                }
                let starView = StarView(count: CGFloat(itemModel.star!), lineSpace: 0, fullImgName: "pinglun_pic_01", halfImgName: "pinglun_pic_03", zeroImgName: "pinglun_pic_02", sizeWidth: 16.0, sizeHeight: 16.0, frame: CGRect(x: 0, y: 0, width: 80, height: 16),isEdit: false)
                
                commonStarView.addSubview(starView)
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
    }
    
    
    
    
    
}

extension CommentsCell {
    private func setUI() {
        avatarImgView.layer.cornerRadius = 20
        avatarImgView.layer.masksToBounds = true
        
        nameLabel.textColor = HexColor(DarkGrayColor)
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        timeLabel.textColor = HexColor(LightGrayColor)
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        
        usedTimeLabel.textColor = HexColor(LightGrayColor)
        usedTimeLabel.font = UIFont.systemFont(ofSize: 10)
        
        commentsLabel.textColor = HexColor(DarkGrayColor)
        commentsLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        commentsLabel.numberOfLines = 0
    }
}
