//
//  MessageTextCell.swift
//  Murder
//
//  Created by m.a.c on 2020/8/5.
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
    
    // 上一条消息的时间
//    var presentTime: String
    
    
    var cellHeight: CGFloat?
    
    var messageTalkModel: MsgTalkModel? {
        didSet {
            if messageTalkModel != nil {
                
                let rightHidden = messageTalkModel?.cellType == .left ? true : false
                rightView.isHidden = rightHidden
                leftView.isHidden = !rightHidden
                
                
                if messageTalkModel?.timeMs != nil , messageTalkModel?.showTime! == true {
                    let timeStr = getDateStr(timeStamp: (messageTalkModel?.timeMs!)!)
                    timeLabel.text = timeStr
                    timeLabel.isHidden = false

                } else {
                    timeLabel.isHidden = true

                }
                
                
                if messageTalkModel?.head != nil {
                    let head = messageTalkModel?.head
                    leftAvatarView.setImageWith(URL(string: head!))
                }
                
                let mine = UserAccountViewModel.shareInstance.account?.head
                rightAvatarView.setImageWith(URL(string: mine!))
                                
//                //通过富文本来设置行间距
//                let paraph = NSMutableParagraphStyle()
//                //将行间距设置为28
//                paraph.lineSpacing = 20
//                //样式属性集合
//                let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
//                                  NSAttributedString.Key.paragraphStyle: paraph]
//
                leftTextLabel.numberOfLines = 0
                rightTextLabel.numberOfLines = 0
                
                
                
                leftTextLabel.lineBreakMode = .byWordWrapping
                rightTextLabel.lineBreakMode = .byWordWrapping

                
                if messageTalkModel?.content != nil {
                    let content = messageTalkModel?.content
                    leftTextLabel.text = content!
                    rightTextLabel.text = content!
                }
            }
        }
    }
    
    
    
    var messageModel: Message? {
        didSet {
            if messageModel != nil {
                
                let rightHidden = messageModel?.typeStr == .left ? true : false
                rightView.isHidden = rightHidden
                leftView.isHidden = !rightHidden
                
                let head = messageModel?.head
                leftAvatarView.setImageWith(URL(string: head!))
                
                let mine = UserAccountViewModel.shareInstance.account?.head
                rightAvatarView.setImageWith(URL(string: mine!))
                
                
                
                let content = messageModel?.text
//                //通过富文本来设置行间距
//                let paraph = NSMutableParagraphStyle()
//                //将行间距设置为28
//                paraph.lineSpacing = 20
//                //样式属性集合
//                let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),
//                                  NSAttributedString.Key.paragraphStyle: paraph]
//
                leftTextLabel.numberOfLines = 0
                rightTextLabel.numberOfLines = 0
                leftTextLabel.lineBreakMode = .byWordWrapping
                rightTextLabel.lineBreakMode = .byWordWrapping
//
//                leftTextLabel.attributedText = NSAttributedString(string: content!, attributes: attributes)
//
//                rightTextLabel.attributedText = NSAttributedString(string: content!, attributes: attributes)
                
                leftTextLabel.text = content!
                rightTextLabel.text = content!
                
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
        leftAvatarView.layer.cornerRadius = 22.5
        rightAvatarView.layer.cornerRadius = 22.5
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
//            let height = rightTextLabel.text?.ga_heightForComment(fontSize: 15, width: width)
            
            let font = UIFont.systemFont(ofSize: 15)
            let height = stringSingleHeightWithWidth(text: rightTextLabel.text!, width: width, font: font)
            cellHeight = height
            
            Log("height===\(height ?? 0)")
        }
    }
    
}
