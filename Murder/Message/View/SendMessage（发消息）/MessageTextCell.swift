//
//  MessageTextCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/5.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import YYKit

class MessageTextCell: UITableViewCell {
    
    
    // 时间显示
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var leftAvatarView: UIImageView!
    
    @IBOutlet weak var leftTextView: UIView!
    
    @IBOutlet weak var leftTextLabel: UILabel!
    
    
    
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var rightAvatarView: UIImageView!
    
    @IBOutlet weak var rightTextView: UIView!
    
    @IBOutlet weak var rightTextLabel: UILabel!
    
    var cellHeight: CGFloat?
    
    var messageModel: Message? {
        didSet {
            if messageModel != nil {
                
                let rightHidden = messageModel?.type == .left ? true : false
                rightView.isHidden = rightHidden
                leftView.isHidden = !rightHidden
                
                let user = messageModel?.userId
                leftAvatarView.setImageWith(URL(string: user!))
                rightAvatarView.setImageWith(URL(string: user!))
                
                let content = messageModel?.text
                
                var width = labelWidth(text: content!, height: 15, fontSize: 15)
                var height: CGFloat = 90
                if width >= FULL_SCREEN_WIDTH - 170 {
                    width = FULL_SCREEN_WIDTH - 170
                    height = content!.ga_heightForComment(fontSize: 15, width: width)
                }
                cellHeight = height
                leftTextLabel.text = content
                rightTextLabel.text = content
                
                Log("height===\(height ?? 0)")
                
            }
        }
    }
    
    
    var isLeft: Bool = true {
        didSet {
            setUI()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        rightView.isHidden = true
        leftView.isHidden = true
        leftTextLabel.textColor = HexColor(DarkGrayColor)
        rightTextLabel.textColor = UIColor.white
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension MessageTextCell {
    private func setUI() {
        if isLeft { // 左边
            rightView.isHidden = true
            leftView.isHidden = false
            
            var width = labelWidth(text: leftTextLabel.text!, height: 15, fontSize: 15)
            if width >= FULL_SCREEN_WIDTH - 170 {
                width = FULL_SCREEN_WIDTH - 170
            }
            cellHeight = 90

        } else { // 右边
            rightView.isHidden = false
            leftView.isHidden = true

            var width = labelWidth(text: rightTextLabel.text!, height: 15, fontSize: 15)
            if width >= FULL_SCREEN_WIDTH - 170 {
                width = FULL_SCREEN_WIDTH - 170
            }
            let height = rightTextLabel.text?.ga_heightForComment(fontSize: 15, width: width)
            
            cellHeight = height
            
            Log("height===\(height ?? 0)")
        }
    }
}
