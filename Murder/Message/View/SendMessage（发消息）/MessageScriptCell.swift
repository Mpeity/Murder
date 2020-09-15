//
//  MessageScriptCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/5.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MessageScriptCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    // 时间显示
    @IBOutlet weak var leftTimeLabel: UILabel!

    @IBOutlet weak var leftBgImgView: UIImageView!
    
    @IBOutlet weak var leftCoverImgView: UIImageView!
    
    @IBOutlet weak var leftNameLabel: UILabel!
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    
    @IBOutlet weak var leftAvatarView: UIImageView!
    

    
    
    
    @IBOutlet weak var rightView: UIView!
    
    // 时间显示
    @IBOutlet weak var rightTimeLabel: UILabel!
    
    @IBOutlet weak var rightBgImgView: UIImageView!
       
    @IBOutlet weak var rightCoverImgView: UIImageView!
   
    @IBOutlet weak var rightNameLabel: UILabel!
   
    @IBOutlet weak var rightTitleLabel: UILabel!
    
    @IBOutlet weak var rightAvatarView: UIImageView!
    
    

    
     var messageTalkModel: MsgTalkModel? {
        didSet {
            if messageTalkModel != nil {
                
                let rightHidden = messageTalkModel?.cellType == .left ? true : false
                rightView.isHidden = rightHidden
                leftView.isHidden = !rightHidden
                
                let timeStr = getDateStr(timeStamp: (messageTalkModel?.timeMs!)!)
                leftTimeLabel.text = timeStr
                rightTimeLabel.text = timeStr

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
                    
                    leftTitleLabel.attributedText = setMutableString(content: (messageTalkModel?.scriptDes!)!, HexColor(LightGrayColor), fontSize: 12)
                    rightTitleLabel.attributedText = setMutableString(content: (messageTalkModel?.scriptDes!)!, HexColor(LightGrayColor), fontSize: 12)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        rightNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
