//
//  MessageScriptInviteCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/5.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MessageScriptInviteCell: UITableViewCell {
    

    
    @IBOutlet weak var leftView: UIView!
     // 时间显示
    @IBOutlet weak var leftTimeLabel: UILabel!

    @IBOutlet weak var leftBgImgView: UIImageView!
     
    @IBOutlet weak var leftCoverImgView: UIImageView!
     
    @IBOutlet weak var leftNameLabel: UILabel!
     
    @IBOutlet weak var leftTitleLabel: UILabel!
     
    @IBOutlet weak var leftAvatarView: UIImageView!
     
    @IBOutlet weak var leftTipLabel: UILabel!

     
     
     
    @IBOutlet weak var rightView: UIView!
     
    // 时间显示
    @IBOutlet weak var rightTimeLabel: UILabel!
     
    @IBOutlet weak var rightBgImgView: UIImageView!
        
    @IBOutlet weak var rightCoverImgView: UIImageView!
    
    @IBOutlet weak var rightNameLabel: UILabel!
    
    @IBOutlet weak var rightTitleLabel: UILabel!
     
    @IBOutlet weak var rightAvatarView: UIImageView!
    
    @IBOutlet weak var rightTipLabel: UILabel!
    
    

    var messageTalkModel: MsgTalkModel? {
        
        didSet {
            if messageTalkModel != nil {
                
               let rightHidden = messageTalkModel?.cellType == .left ? true : false
               rightView.isHidden = rightHidden
               leftView.isHidden = !rightHidden
               
//               let timeStr = getDateStr(timeStamp: (messageTalkModel?.timeMs!)!)
//               leftTimeLabel.text = timeStr
//               rightTimeLabel.text = timeStr
                
                if messageTalkModel?.timeMs != nil , messageTalkModel?.showTime! == true {
                    
                    let timeStr = getDateStr(timeStamp: (messageTalkModel?.timeMs!)!)
                    leftTimeLabel.text = timeStr
                    leftTimeLabel.isHidden = false
                    rightTimeLabel.text = timeStr
                    rightTimeLabel.isHidden = false

                } else {
                    
                    rightTimeLabel.isHidden = true
                    leftTimeLabel.isHidden = true


                }

               if messageTalkModel?.head != nil {
                   let head = messageTalkModel?.head
                   leftAvatarView.setImageWith(URL(string: head!))
               }
               if UserAccountViewModel.shareInstance.account?.head != nil {
                   let mine = UserAccountViewModel.shareInstance.account?.head
                   rightAvatarView.setImageWith(URL(string: mine!))
               }
               
               if messageTalkModel?.scriptCover != nil {
                   leftCoverImgView.setImageWith(URL(string: (messageTalkModel?.scriptCover!)!))
                   rightCoverImgView.setImageWith(URL(string: (messageTalkModel?.scriptCover!)!))
               }
               
               if messageTalkModel?.scriptName != nil {
                   leftNameLabel.text = messageTalkModel?.scriptName!
                   rightNameLabel.text = messageTalkModel?.scriptName!
               }
               
               if messageTalkModel?.scriptDes != nil {
//                   leftTitleLabel.text = messageTalkModel?.scriptDes!
//                   rightTitleLabel.text = messageTalkModel?.scriptDes!
                leftTitleLabel.attributedText = setMutableString(content: (messageTalkModel?.scriptDes!)!, HexColor(LightGrayColor), fontSize: 12)
                leftTimeLabel.lineBreakMode = .byTruncatingTail
                rightTitleLabel.attributedText = setMutableString(content: (messageTalkModel?.scriptDes!)!, HexColor(LightGrayColor), fontSize: 12)
                rightTitleLabel.lineBreakMode = .byTruncatingTail
               }
                
                if messageTalkModel?.roomId != nil {
                    
                    leftTitleLabel.text = "ルームID：\(messageTalkModel!.roomId!)"
                    
                    rightTitleLabel.text = "ルームID：\(messageTalkModel!.roomId!)"
                }
           }
       }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        rightNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        rightCoverImgView.layer.cornerRadius = 5
        rightCoverImgView.layer.masksToBounds = true
        
        
        leftCoverImgView.layer.cornerRadius = 5
        leftCoverImgView.layer.masksToBounds = true
        
        leftAvatarView.layer.cornerRadius = 22.5
        leftAvatarView.layer.masksToBounds = true
        
        
        rightAvatarView.layer.cornerRadius = 22.5
        rightAvatarView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
