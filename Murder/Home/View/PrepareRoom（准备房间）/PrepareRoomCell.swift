//
//  PrepareRoomCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PrepareRoomCell: UITableViewCell {
    
    // 背景视图
    @IBOutlet weak var bgView: UIView!
    // 游戏头像
    @IBOutlet weak var roleImgView: UIImageView!
    // 游戏名称
    @IBOutlet weak var roleNameLabel: UILabel!
    // 准备按钮
    @IBOutlet weak var prepareBtn: UIButton!
    // 进度显示
    @IBOutlet weak var progressLabel: UILabel!
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    // 房主
    @IBOutlet weak var ownerLabel: UILabel!
    // 
    // 说话 绿点显示
    @IBOutlet weak var pointView: UIView!
    
    var animation: Bool? {
        didSet {
            if animation == true {
                pointView.isHidden = false
                pointView.layer.add(opacityForeverAnimation(time: 3), forKey: nil)
            } else {
                pointView.isHidden = true
            }
        }
    }
    
    
    var scriptRoleModel: ScriptRoleModel? {
        didSet {
            if (scriptRoleModel != nil) {
                if (scriptRoleModel?.head != nil) {
                    let head = scriptRoleModel?.head!
                    roleImgView.setImageWith(URL(string: head!))
                }
                
                if (scriptRoleModel?.roleName != nil) {
                    roleNameLabel.text = scriptRoleModel?.roleName!
                }
            }
            
            
        }
    }
    
    var roomUserModel: RoomUserModel? {
        didSet {
            if (roomUserModel != nil) {
                if (roomUserModel?.head != nil) {
                    let head = roomUserModel?.head!
                    avatarImgView.setImageWith(URL(string:head!))
//                    avatarImgView.setImageWith(URL(string:head!), placeholder: UIImage(named: "unselected_icon"))
                }
                
                if (roomUserModel?.nickname != nil) {
                    nameLabel.text = roomUserModel?.nickname!
                }
                
                if roomUserModel?.isHomeowner != nil {
                    if roomUserModel?.isHomeowner == 1 {
                        ownerLabel.isHidden = false
                    } else {
                        ownerLabel.isHidden = true
                    }
                }
                if roomUserModel?.status != nil {
                    // 状态【0未开始1已准备2游戏中3已结束】
                    if roomUserModel?.status == 1 {
                        prepareBtn.isHidden = false
                        progressLabel.isHidden = true
                    } else {
                        prepareBtn.isHidden = true
                        progressLabel.isHidden = false

                    }
                }
            } else {
                avatarImgView.setImageWith(URL(string:""), placeholder: UIImage(named: "unselected_icon"))
                nameLabel.text = "サクラ"
                ownerLabel.isHidden = true
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

extension PrepareRoomCell {
    func setUI() {
        
        roleImgView.image = nil
        roleNameLabel.text = nil
        progressLabel.text = nil
        
        
        roleImgView.viewWithCorner(byRoundingCorners: [.bottomLeft,.topLeft], radii: 10)
        
        bgView.backgroundColor = HexColor("#20014D")
        bgView.layer.cornerRadius = 10
        bgView.layer.borderColor = HexColor("#3E1180").cgColor
        bgView.layer.borderWidth = 1
        bgView.isUserInteractionEnabled = true
        
        roleNameLabel.textColor = UIColor.white
        roleNameLabel.font = UIFont.systemFont(ofSize: 15)
        
        progressLabel.textColor = HexColor("#FC3859")
        progressLabel.isHidden = true
        progressLabel.backgroundColor = UIColor.clear
        prepareBtn.layer.cornerRadius = 7.5
        
        
        avatarImgView.layer.cornerRadius = 20
        ownerLabel.textColor = HexColor("#230254")
        ownerLabel.backgroundColor = HexColor(LightOrangeColor)
        ownerLabel.layer.cornerRadius = 5
        ownerLabel.layer.masksToBounds = true
        ownerLabel.isHidden = true
        
        pointView.isHidden = true
        
    
        prepareBtn.addTarget(self, action: #selector(prepareBtnAction), for: .touchUpInside)
        prepareBtn.isHidden = true
        
        
    }
}

extension PrepareRoomCell {
    @objc func prepareBtnAction() {
        Log(1222222)
    }
}

extension PrepareRoomCell {
    
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
