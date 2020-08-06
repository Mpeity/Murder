//
//  ThreadCardView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ThreadCardView: UIView {

    @IBOutlet var contentView: UIView!
    
    // 图片
    @IBOutlet weak var imgView: UIImageView!
    // 公开
    @IBOutlet weak var publicBtn: UIButton!
    // 可深入
    @IBOutlet weak var deepBtn: UIButton!
    // 关闭
    @IBOutlet weak var cancelBtn: UIButton!
    
    // 深入按钮
    @IBAction func deepBtnAction(_ sender: Any) {
        
    }
    
    // 公开按钮
    @IBAction func publicBtnAction(_ sender: Any) {
        
        
    }
    
    // 关闭按钮
    @IBAction func cancelBtnAction(_ sender: Any) {
        contentView = nil
        removeFromSuperview()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ThreadCardView {
    //MARK:- 设置UI
    private func setUI() {
        self.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        
        publicBtn.layer.cornerRadius = 22
        publicBtn.layer.borderColor = HexColor(MainColor).cgColor
        publicBtn.layer.borderWidth = 0.5
        publicBtn.setTitleColor(HexColor(MainColor), for: .normal)
        
        deepBtn.layer.cornerRadius = 22
        deepBtn.setTitleColor(UIColor.white, for: .normal)
        deepBtn.backgroundColor = HexColor(MainColor)
    }
}

extension ThreadCardView {
    
}

extension ThreadCardView {
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


