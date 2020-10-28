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
    
    var isEdit: Bool!
    
    var newCount: CGFloat? {
        didSet {
            createSubviews(count: newCount ?? 0)
        }
    }
    
    private var star: CGFloat? = 0
    
    
    
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
    
    /* 展示星星
     * count 分数
     * lineSpace 图片之间的间距
     * fullImgName 图片名称
     * halfImgName 图片名称
     * zeroImgName 图片名称
     * width 宽度
     * height 高度
     * isEdit 是否可以选择
     */
    init(count: CGFloat, lineSpace: CGFloat, fullImgName: String, halfImgName: String, zeroImgName: String, sizeWidth: CGFloat, sizeHeight: CGFloat, frame: CGRect, isEdit: Bool) {
        self.count = count
        self.fullImgName = fullImgName
        self.halfImgName = halfImgName
        self.zeroImgName = zeroImgName
        self.sizeWidth = sizeWidth
        self.sizeHeight = sizeHeight
        self.lineSpace = lineSpace
        self.isEdit = isEdit
        super.init(frame: frame)
        setOtherUI()
    }
}


extension StarView {
    
    private func createSubviews(count: CGFloat) {
        if commonView?.subviews != nil {
            commonView?.removeAllSubviews()
        }

        star = count
        
        if count > 0 {
            let fullCount = Int(count / 2)
            var fullIndex = 0
            while (fullIndex < fullCount) {
                let starBtn = UIButton()
                starBtn.setImage(UIImage(named: fullImgName), for: .normal)
                starBtn.addTarget(self, action: #selector(starBtnAction(button:)), for: .touchUpInside)
                starBtn.tag = fullIndex + 1
                commonView?.addSubview(starBtn)
                let left = (sizeWidth + lineSpace) * CGFloat(fullIndex)
                starBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(left)
                    make.height.equalTo(sizeHeight)
                    make.width.equalTo(sizeWidth)
                    make.centerY.equalToSuperview()
                }
                fullIndex += 1
            }
            
            let halfCount = count - CGFloat(fullCount) * 2.0
            if halfCount > 0 {
                let starBtn = UIButton()
                starBtn.setImage(UIImage(named: halfImgName), for: .normal)
                starBtn.addTarget(self, action: #selector(starBtnAction(button:)), for: .touchUpInside)
                starBtn.tag = fullIndex + 1
                commonView?.addSubview(starBtn)
                let left = (sizeWidth + lineSpace) * CGFloat(fullIndex)
                starBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(left)
                    make.height.equalTo(sizeHeight)
                    make.width.equalTo(sizeWidth)
                    make.centerY.equalToSuperview()
                }
            }
            
            
//            var index = 0
            while (fullIndex < 5) {
                let starBtn = UIButton()
                starBtn.setImage(UIImage(named: zeroImgName), for: .normal)
                starBtn.addTarget(self, action: #selector(starBtnAction(button:)), for: .touchUpInside)
                starBtn.tag = fullIndex + 1
                commonView?.addSubview(starBtn)
                let left = (sizeWidth + lineSpace) * CGFloat(fullIndex)
                starBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(left)
                    make.height.equalTo(sizeHeight)
                    make.width.equalTo(sizeWidth)
                    make.centerY.equalToSuperview()
                }
                fullIndex += 1
            }
        } else {
            var index = 0
            while (index < 5) {
                let starBtn = UIButton()
                starBtn.setImage(UIImage(named: zeroImgName), for: .normal)
                starBtn.tag = index + 1
                starBtn.addTarget(self, action: #selector(starBtnAction(button:)), for: .touchUpInside)
                commonView?.addSubview(starBtn)
                let left = (sizeWidth + lineSpace) * CGFloat(index)
                starBtn.snp.makeConstraints { (make) in
                    make.left.equalTo(left)
                    make.height.equalTo(sizeHeight)
                    make.width.equalTo(sizeWidth)
                    make.centerY.equalToSuperview()
                }
                index += 1
            }
        }
    }
    
    // 可编辑
    private func setOtherUI() {
        if commonView == nil {
            commonView = UIView()
            self.addSubview(commonView!)
            commonView?.frame = self.bounds
        }
        createSubviews(count: self.count)
    }
    
    
    // 展示
    private func setUI() {        
        if commonView == nil {
            commonView = UIView()
            self.addSubview(commonView!)
            commonView?.frame = self.bounds
        }
        commonView?.removeAllSubviews()
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

extension StarView {
    @objc func starBtnAction(button: UIButton) {
        if isEdit {
            let count = button.tag * 2
            createSubviews(count: CGFloat(count))
            star = CGFloat(count)
        } 
    }
    
    func getStar() -> Int {
        if commonView != nil {
            let num = Int(star!)
            return num
        } else {
            return 0
        }
    }
}
