//
//  UIView-Extention.swift
//  Murder
//
//  Created by m.a.c on 2020/7/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

extension UIView {
    

    func setCornersRadius(_ view: UIView!, radius: CGFloat, roundingCorners: UIRectCorner) {
        if view == nil {
            return
        }
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.shouldRasterize = true
        maskLayer.rasterizationScale = UIScreen.main.scale
        
        view.layer.mask = maskLayer
    }
    
    
    // 自定义 游戏页面 按钮
    /**
     * position: 显示在左边还是右边
     * oneself: 是否是玩家自己
     * imageName: 玩家头像图片
     * title: 玩家名字
     * isHandsUp: 是否举手
     * isSpeaking: 是否在说话
     * isCollogue: 是否密谈中
     */
    convenience init(position: Position, oneself: Bool, imageName: String, title: String, handsUp: Bool, isSpeaking: Bool, isCollogue: Bool) {
        self.init()
        let width = 44
        let heigth = 64
        
//        let layer = CAGradientLayer()
//        layer.frame = self.bounds
//
//        // 设置圆角
//        layer.cornerRadius = CGFloat(width/2)
//        self.layer.insertSublayer(layer, at: 0)
        
        let button = UIButton()
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(width)
        }
        button.setImage(UIImage(named: imageName), for: .normal)
        button.layer.cornerRadius = CGFloat(width/2)
        button.layer.borderWidth = 2
        if oneself {
            button.layer.borderColor = HexColor(LightOrangeColor).cgColor
        } else {
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(5)
            make.width.equalTo(width)
            make.height.equalTo(15)
        }
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        
    }
    
    
    
    /** 部分圆角
     * - corners: 需要实现为圆角的角，可传入多个
     * - radii: 圆角半径
     */
    func viewWithCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
