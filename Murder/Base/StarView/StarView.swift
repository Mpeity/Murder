//
//  StarView.swift
//  Murder
//
//  Created by m.a.c on 2020/10/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class StarView: UIView {
    
    var fullImgName: String!
    var halfImgName: String!
    var zeroImgName: String!
    var count: CGFloat!
    var sizeHeight: CGFloat!
    var sizeWidth: CGFloat!
    var lineSpace: CGFloat!
    
    
    
    var commonView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* 展示星星
     * count 分数
     * lineSpace 图片之间的间距
     * fullImgName 图片名称
     * halfImgName 图片名称
     * zeroImgName 图片名称
     * width 宽度
     * height 高度
     */
    init(count: CGFloat, lineSpace: CGFloat, fullImgName: String, halfImgName: String, zeroImgName: String, sizeWidth: CGFloat, sizeHeight: CGFloat, frame: CGRect) {
        self.count = count
        self.fullImgName = fullImgName
        self.halfImgName = halfImgName
        self.zeroImgName = zeroImgName
        self.sizeWidth = sizeWidth
        self.sizeHeight = sizeHeight
        self.lineSpace = lineSpace
        super.init(frame: frame)
        setUI()
    }
}


extension StarView {
    private func setUI() {        
        if commonView == nil {
            commonView = UIView()
            self.addSubview(commonView!)
            commonView?.frame = self.bounds
        }
        
        var index = 0
        while (index < 5) {
            let iconImgView = UIImageView(frame: CGRect.zero)
            iconImgView.image = UIImage(named: zeroImgName)
            commonView?.addSubview(iconImgView)
            let left = (sizeWidth + lineSpace) * CGFloat(index)
            iconImgView.snp.makeConstraints { (make) in
                make.left.equalTo(left)
                make.height.equalTo(sizeHeight)
                make.width.equalTo(sizeWidth)
                make.centerY.equalToSuperview()
            }
            index += 1
        }
        
        if count > 0 {
            let fullCount = Int(count / 2)
            var fullIndex = 0
            while (fullIndex < fullCount) {
                let iconImgView = UIImageView(frame: CGRect.zero)
                iconImgView.image = UIImage(named: fullImgName)
                commonView?.addSubview(iconImgView)
                let left = (sizeWidth + lineSpace) * CGFloat(fullIndex)
                iconImgView.snp.makeConstraints { (make) in
                    make.left.equalTo(left)
                    make.height.equalTo(sizeHeight)
                    make.width.equalTo(sizeWidth)
                    make.centerY.equalToSuperview()
                }
                fullIndex += 1
            }
            
            let halfCount = count - CGFloat(fullCount) * 2.0
            if halfCount > 0 {
                let iconImgView = UIImageView(frame: CGRect.zero)
                iconImgView.image = UIImage(named: halfImgName)
                commonView?.addSubview(iconImgView)
                let left = (sizeWidth + lineSpace) * CGFloat(fullIndex)
                iconImgView.snp.makeConstraints { (make) in
                    make.left.equalTo(left)
                    make.height.equalTo(sizeHeight)
                    make.width.equalTo(sizeWidth)
                    make.centerY.equalToSuperview()
                }
            }
        }
    }
}
