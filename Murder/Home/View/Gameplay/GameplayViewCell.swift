//
//  GameplayViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/3.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class GameplayViewCell: UICollectionViewCell {
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    // 左边样式
    @IBOutlet weak var l_avatarImgView: UIImageView!
    // 举手
    @IBOutlet weak var l_handsUp: UIImageView!
    
    @IBOutlet weak var l_voiceImgView: UIView!
    
    @IBOutlet weak var l_voiceView: UIView!
    
    @IBOutlet weak var l_nameLabel: UILabel!
    
    @IBOutlet weak var l_comImgView: UIImageView!
    // 右边样式
    // 头像
    @IBOutlet weak var r_avatarImgView: UIImageView!
    // 举手
    @IBOutlet weak var r_handsUp: UIImageView!
    
    @IBOutlet weak var r_voiceImgView: UIView!
    
    @IBOutlet weak var r_voiceView: UIView!
    
    @IBOutlet weak var r_nameLabel: UILabel!
    
    
    @IBOutlet weak var r_miLabel: UILabel!
    
    @IBOutlet weak var l_miLabel: UILabel!
    
    @IBOutlet weak var r_comImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }

}


extension GameplayViewCell {
    private func setUI() {
        
        rightView.backgroundColor = UIColor.clear
        leftView.backgroundColor = UIColor.clear
        rightView.isUserInteractionEnabled = true
        leftView.isUserInteractionEnabled = true
        
        l_comImgView.isHidden = true
        r_comImgView.isHidden = true
        
        l_avatarImgView.layer.cornerRadius = 22
        l_avatarImgView.layer.borderColor = UIColor.white.cgColor
        l_avatarImgView.layer.borderWidth = 2
        
        r_avatarImgView.layer.cornerRadius = 22
        r_avatarImgView.layer.borderColor = UIColor.white.cgColor
        r_avatarImgView.layer.borderWidth = 2
        
        l_voiceView.backgroundColor = HexColor(hex: "#000000", alpha: 0.5)
        l_voiceView.layer.cornerRadius = 17
        
        r_voiceView.backgroundColor = HexColor(hex: "#000000", alpha: 0.5)
        r_voiceView.layer.cornerRadius = 17
        
        l_nameLabel.textColor = UIColor.white
        l_nameLabel.font = UIFont.systemFont(ofSize: 10)
        
        r_nameLabel.textColor = UIColor.white
        r_nameLabel.font = UIFont.systemFont(ofSize: 10)
        
        
        r_handsUp.isHidden = true
        l_handsUp.isHidden = true
        
        r_voiceImgView.isHidden = true
        l_voiceImgView.isHidden = true
        
        l_miLabel.layer.cornerRadius = 7.5
        l_miLabel.layer.masksToBounds = true
        l_miLabel.isHidden = true
        
        l_voiceView.isHidden = true
        r_voiceView.isHidden = true

        r_miLabel.layer.cornerRadius = 7.5
        r_miLabel.layer.masksToBounds = true
        r_miLabel.isHidden = true

        
    }
}
