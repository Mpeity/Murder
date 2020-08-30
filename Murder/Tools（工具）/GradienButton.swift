//
//  GradienButton.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class GradienButton: UIButton {
    
    var gradienLayer = CAGradientLayer()
   // 设置按钮渐变色
    func setGradienButtonColor(start: String, end: String, cornerRadius: Float)  {
        if (gradienLayer.superlayer != nil) {
            gradienLayer.removeFromSuperlayer()
        }
        gradienLayer.frame = self.bounds
        // 开始
        gradienLayer.startPoint = CGPoint(x: 0, y: 0)
        // 结束,主要是控制渐变方向
        gradienLayer.startPoint = CGPoint(x: 1, y: 1)
        
        let startColor = HexColor(start)
        
        let endColor = HexColor(end)
        gradienLayer.colors = [startColor.cgColor, endColor.cgColor]
        // 颜色的分界点
        gradienLayer.locations = [0.0,1.0]
        // 设置圆角
        gradienLayer.cornerRadius = CGFloat(cornerRadius)
        self.layer.insertSublayer(gradienLayer, at: 0)
    }
    
    
    // 去掉渐变色
    func gradientClearLayerColor(cornerRadius: Float) {
        if (gradienLayer.superlayer != nil) {
            gradienLayer.removeFromSuperlayer()
        }
    }

}
