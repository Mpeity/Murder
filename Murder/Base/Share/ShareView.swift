//
//  ShareView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

protocol ShareViewDelegate {
    func shareFriendsBtnClick()
    func shareLineBtnClick()
    func shareCopyBtnClick()
}

class ShareView: UIView {
    
    var delegate: ShareViewDelegate!

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var shareFriendsBtn: UIView!
    
    @IBOutlet weak var shareLineBtn: UIView!
    
    @IBOutlet weak var shareCopyBtn: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
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
extension ShareView {
    
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        cancelBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        shareFriendsBtn.isUserInteractionEnabled = true
        let shareFriendsBtnTap = UITapGestureRecognizer(target: self, action: #selector(shareFriendsBtnAction))
        shareFriendsBtn.addGestureRecognizer(shareFriendsBtnTap)
        
        shareCopyBtn.isUserInteractionEnabled = true
        let shareCopyBtnTap = UITapGestureRecognizer(target: self, action: #selector(shareCopyBtnAction))
        shareCopyBtn.addGestureRecognizer(shareCopyBtnTap)

        shareLineBtn.isUserInteractionEnabled = true
        let shareLineBtnTap = UITapGestureRecognizer(target: self, action: #selector(shareLineBtnAction))
        shareLineBtn.addGestureRecognizer(shareLineBtnTap)


    }
    

}

extension ShareView {
    // 取消分享
    @objc private func hideView() {
        contentView = nil
        self.removeFromSuperview()
    }
    
    // 分享好友
    @objc private func shareFriendsBtnAction() {
        contentView = nil
        self.removeFromSuperview()
        if delegate != nil {
            delegate.shareFriendsBtnClick()
        }
    }
    
    // 分享line
    @objc private func shareLineBtnAction() {
        contentView = nil
        self.removeFromSuperview()
    }
    
    // 分享拷贝
    @objc private func shareCopyBtnAction() {
        contentView = nil
        self.removeFromSuperview()
    }
    
}


extension ShareView {
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


