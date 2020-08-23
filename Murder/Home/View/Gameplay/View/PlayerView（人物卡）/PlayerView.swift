//
//  PlayerView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    var itemModel: GPScriptRoleListModel? {
        didSet {
            
            if (itemModel != nil) {
                if (itemModel?.head != nil) {
                    let roleHead = itemModel?.head!
                    roleImgView.setImageWith(URL(string: roleHead!))
                }
                
                if (itemModel?.scriptRoleName != nil) {
                    roleNameLabel.text = itemModel?.scriptRoleName!
                }
                
                if itemModel?.describe != nil {
                    roleIntroduceLabel.text = itemModel?.describe
                }
                
                if itemModel?.user?.head != nil {
                    let head = itemModel?.user?.head!
                    playerImgView.setImageWith(URL(string: head!))
                }
                
                if itemModel?.user?.nickname != nil {
                    playerNameLabel.text = itemModel?.user?.nickname!
                }
                
                var image : UIImage!
                if itemModel?.user?.sex == 1 {
//                    image = UIImage(named: "sexman")
                    image = UIImage(named: "sex_man")
                } else {
//                    image = UIImage(named: "sexwoman")
                    image = UIImage(named: "sex_woman")

                }
                sexImgView.image = image
                
        
                if itemModel?.user?.level != nil {
                    levelLabel.text = itemModel?.user?.level
                }
                
                if itemModel?.user?.userId != nil {
                    let id = itemModel?.user?.userId!
                    IDLabel.text = String(id!)
                }
            }
        }
    }
    
    
    @IBOutlet var contentView: UIView!
    
    // 角色按钮
    @IBOutlet weak var roleBtn: UIButton!
    // 玩家
    @IBOutlet weak var playerBtn: UIButton!
    // 滑动小滑块
    @IBOutlet weak var lineView: UIView!
    
    // 角色
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var roleImgView: UIImageView!
    // 角色姓名
    @IBOutlet weak var roleNameLabel: UILabel!
    // 任务介绍
    @IBOutlet weak var roleIntroduceLabel: UILabel!
    
    // 玩家
    @IBOutlet weak var playerView: UIView!
    // 头像
    @IBOutlet weak var playerImgView: UIImageView!
    // 名称
    @IBOutlet weak var playerNameLabel: UILabel!
    // 性别
    @IBOutlet weak var sexImgView: UIImageView!
    
    // 等级
    @IBOutlet weak var levelLabel: UILabel!
    
    // id
    @IBOutlet weak var IDLabel: UILabel!
    
    // 申请好友
    @IBOutlet weak var applyBtn: UIButton!
    
    
    // 取消按钮
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func roleBtnAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.playerView.isHidden = true
            self.roleView.isHidden = false
            self.lineView.center.x = self.roleBtn.center.x
        }
    }
    
    @IBAction func playerBtnAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.roleView.isHidden = true
            self.playerView.isHidden = false

            self.lineView.center.x = self.playerBtn.center.x
        }
        
    }
    
    
    @IBAction func applyBtnAction(_ sender: Any) {
        
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        contentView = nil
        self.removeFromSuperview()
    }
    
 //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
        
        playerView.isHidden = true
        roleView.isHidden = false
        // 初始化
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
    }
 
}


extension PlayerView {
    private func setUI() {
        // 设置圆角
        playerBtn.corner(byRoundingCorners: .topRight, radii: 15)
        roleBtn.corner(byRoundingCorners: .topLeft, radii: 15)

        roleView.layer.cornerRadius = 15
        playerView.layer.cornerRadius = 15
        
        lineView.layer.cornerRadius = 1.5
        
        // 角色
        roleNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        
        // 玩家
        playerImgView.layer.cornerRadius = 30
        playerNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        levelLabel.layer.cornerRadius = 7.5
        levelLabel.layer.masksToBounds = true
        IDLabel.layer.cornerRadius = 7.5
        IDLabel.layer.masksToBounds = true

        
        applyBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        
    }
}


extension PlayerView {
    //加载xib
     func loadViewFromNib() -> UIView {
         let className = type(of: self)
         let bundle = Bundle(for: className)
         let name = NSStringFromClass(className).components(separatedBy: ".").last
         let nib = UINib(nibName: name!, bundle: bundle)
         let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
         return view
     }
    
     //设置好xib视图约束
     func addConstraints() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView!, attribute: .leading,
                                             relatedBy: .equal, toItem: self, attribute: .leading,
                                             multiplier: 1, constant: 0)
        addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .trailing,
                                         relatedBy: .equal, toItem: self, attribute: .trailing,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal,
                                         toItem: self, attribute: .top, multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .bottom,
                                         relatedBy: .equal, toItem: self, attribute: .bottom,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
     }
}

