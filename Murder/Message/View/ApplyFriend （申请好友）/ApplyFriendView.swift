//
//  ApplyFriendView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ApplyFriendView: UIView {

    @IBOutlet var contentView: UIView!
    
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
    // 取消
    @IBOutlet weak var cancelBtn: UIButton!
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
    
        
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

// MARK: - setUI
extension ApplyFriendView {
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        playerImgView.layer.cornerRadius = 15
        playerNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        levelLabel.layer.cornerRadius = 7.5
        levelLabel.layer.masksToBounds = true
        IDLabel.layer.cornerRadius = 7.5
        IDLabel.layer.masksToBounds = true
        
        
        // 好友申请
        applyBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        applyBtn.setTitleColor(UIColor.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        applyBtn.addTarget(self, action: #selector(applyBtnAction), for: .touchUpInside)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
    }
    

}


extension ApplyFriendView {
    @objc private func cancelBtnAction() {
        contentView = nil
        removeFromSuperview()
    }
    
    //
    @objc private func applyBtnAction() {
        applyBtn.setTitle("友達申し込みは発送しました", for: .normal)
        applyBtn.layer.backgroundColor = UIColor.white.cgColor
        applyBtn.gradientColor(start: "#CACACA", end: "#CACACA", cornerRadius: 22)
        
    }
    
    
}


extension ApplyFriendView {
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

