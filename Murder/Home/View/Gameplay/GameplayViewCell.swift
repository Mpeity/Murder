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
    
    
    var l_animation: Bool? {
        didSet {
            if l_animation == true {
                l_voiceView.isHidden = false
                l_voiceImgView.isHidden = false
                l_voiceImgView.layer.add(opacityForeverAnimation(time: 3), forKey: nil)
                l_voiceView.layer.add(opacityForeverAnimation(time: 3), forKey: nil)
            } else {
                l_voiceView.isHidden = true
                l_voiceImgView.isHidden = true
            }
        }
    }
    
    var r_animation: Bool? {
        didSet {
            if r_animation == true {
                r_voiceView.isHidden = false
                r_voiceImgView.isHidden = false
                r_voiceImgView.layer.add(opacityForeverAnimation(time: 3), forKey: nil)
                r_voiceView.layer.add(opacityForeverAnimation(time: 3), forKey: nil)

            } else {
//                pauseAnimation(layer: r_voiceImgView.layer)
                l_voiceView.isHidden = true
                l_voiceImgView.isHidden = true
            }
        }
    }
    
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
        
        l_comImgView.isHidden = false
        r_comImgView.isHidden = false
        
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

extension GameplayViewCell {
    
       // 闪烁动画
    func opacityForeverAnimation(time: Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.0)
        animation.autoreverses = true
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = MAXFLOAT
        animation.repeatCount = 3
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
//        animation.timingFunction = CAMediaTimingFunctionName.easeIn
        return animation
    }
    ///暂停动画
    func pauseAnimation(layer: CALayer) {
        //取出当前时间,转成动画暂停的时间
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        layer.speed = 0.0;
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        layer.timeOffset = pausedTime
    }
    ///恢复动画
    func resumeAnimation(layer: CALayer) {
        //获取暂停的时间差
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
