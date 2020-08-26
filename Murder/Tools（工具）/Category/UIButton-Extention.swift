//
//  UIButton-Extention.swift
//  Swift_WB
//
//  Created by mac on 2020/6/30.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

//var gradienLayer:CAGradientLayer?  = CAGradientLayer()

enum Position {
    case left
    case right
}

enum ButtonImagePosition {
        case top          //图片在上，文字在下，垂直居中对齐
        case bottom       //图片在下，文字在上，垂直居中对齐
        case left         //图片在左，文字在右，水平居中对齐
        case right        //图片在右，文字在左，水平居中对齐
}

extension UIButton {
    
    /** 部分圆角
     * - corners: 需要实现为圆角的角，可传入多个
     * - radii: 圆角半径
     */
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /** 部分圆角
     * - corners: 需要实现为圆角的角，可传入多个
     * - radii: 圆角半径
     * 边框
     * 边框宽度
     * 边框颜色
     */
    func cornerAll(byRoundingCorners corners: UIRectCorner, radii: CGFloat, borderWidth: CGFloat, borderColor: String) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.borderWidth = borderWidth
        maskLayer.borderColor = HexColor(borderColor).cgColor
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    // 设置按钮渐变色
    func gradientColor(start: String, end: String, cornerRadius: Float)  {
//        if (gradienLayer?.superlayer != nil) {
//            gradienLayer?.removeFromSuperlayer()
//        }
//        if gradienLayer == nil {
//            gradienLayer = CAGradientLayer()
//
//        }
        
        let gradienLayer = CAGradientLayer()
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
    func clearGradientColor(cornerRadius: Float) {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        // 开始
        layer.startPoint = CGPoint(x: 0, y: 0)
        // 结束,主要是控制渐变方向
        layer.startPoint = CGPoint(x: 1, y: 1)
        layer.colors = [UIColor.white.cgColor]
        // 颜色的分界点
        layer.locations = [0.0,1.0]
        // 设置圆角
        layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.insertSublayer(layer, at: 0)
    }
    
    // 设置按钮渐变色
    func setGradientColor(start: String, end: String, cornerRadius: Float)  {
          let layer = CAGradientLayer()
          layer.frame = self.bounds
          // 开始
          layer.startPoint = CGPoint(x: 0, y: 0)
          // 结束,主要是控制渐变方向
          layer.startPoint = CGPoint(x: 1, y: 1)
          
          let startColor = HexColor(start)
          
          let endColor = HexColor(end)
          layer.colors = [startColor.cgColor, endColor.cgColor]
          // 颜色的分界点
          layer.locations = [0.0,1.0]
          // 设置圆角
          layer.cornerRadius = CGFloat(cornerRadius)
          self.layer.addSublayer(layer)
      }
    
    
    // swift中类方法是以class开头的方法， 类似于OC中 + 号 开头的方法
    class func createButton(imageName: String, bgImageName: String) -> UIButton {
        let composeBtn = UIButton()
        
        composeBtn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        composeBtn.setImage(UIImage(named: imageName), for: .normal)
        composeBtn.setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        composeBtn.sizeToFit()
        return composeBtn
    }
    
    // convenience 遍历，使用convenience修饰的构造函数叫做遍历构造函数
    // 遍历构造函数通常在对系统的类进行构造函数的扩充时使用
    
    // 特点：
    // 遍历构造函数通常都是写在extention里面
    // 在遍历构造函数中需要明确调用self.init
    // 遍历构造函数中需要加载convenience
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named:imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(imageName: String, title: String, cornerRadius: Float) {
        self.init()
        
        let layer = CAGradientLayer()
        layer.frame = self.bounds

           // 设置圆角
        layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.insertSublayer(layer, at: 0)
        
        setImage(UIImage(named: imageName), for: .normal)
        setTitle(title, for: .normal)
        
        imageView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
        titleLabel?.frame = CGRect(x: 0, y: self.frame.width, width: self.frame.width, height: self.frame.height - self.frame.width)

    }
    
    
    /** 设置按钮的样式、圆角、背景颜色
     * Parameters:
     * style: 图片位置
     * spacing: 按钮图片与文字之间的间隔
     * imageName: 图片
     * title: 文字
     * cornerRadius: 圆角
     * color: 背景颜色
     */
    func createButton(style: ButtonImagePosition, spacing: CGFloat, imageName: String, title: String, cornerRadius: Float, color: String?) {
        
        
        let img = UIImage(named: imageName)
        setImage(img, for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        if color != nil {
            self.backgroundColor = HexColor(color!)
        }
        
        //得到imageView和titleLabel的宽高
        let imageWidth = imageView?.frame.size.width
        let imageHeight = imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = titleLabel?.intrinsicContentSize.width
        labelHeight = titleLabel?.intrinsicContentSize.height
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)
            break;
            
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break;
            
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)
            break;
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.masksToBounds = true
    }

}




