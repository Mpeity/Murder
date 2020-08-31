//
//  DeleteFriendsView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

// 删除好友
typealias DeleteBtnTapBlcok = () ->()

class DeleteFriendsView: UIView {
    
    
    var deleteBtnTapBlcok: DeleteBtnTapBlcok?

    @IBOutlet var contentView: UIView!
     
    @IBOutlet weak var tipLabel: UILabel!
     // 取消
    @IBOutlet weak var cancelBtn: UIButton!
     // 确认删除
    @IBOutlet weak var confirmBtn: UIButton!
    
    
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
extension DeleteFriendsView {
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)

        cancelBtn.layer.borderColor = HexColor(MainColor).cgColor
        cancelBtn.layer.borderWidth = 0.5
        cancelBtn.layer.cornerRadius = 22
        
        
        confirmBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        
    }
    
    private func hideView() {
        contentView = nil
        self.removeFromSuperview()
    }
}


extension DeleteFriendsView {
    // 确认
    @objc func confirmBtnAction() {
        if deleteBtnTapBlcok != nil {
            deleteBtnTapBlcok!()
        }
        hideView()
    }
    // 取消
    @objc func cancelBtnAction() {
        hideView()
    }
}

extension DeleteFriendsView {
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

