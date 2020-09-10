//
//  InputTextView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/30.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

protocol InputTextViewDelegate {
    func commonBtnClick()
}

class InputTextView: UIView {
    
    var delegate:InputTextViewDelegate?
    
    // 底部约束
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var hideTapView: UIView!
    // 输入框
    @IBOutlet weak var myInputView: UIView!
    // 背景图片
    @IBOutlet weak var bgImgView: UIImageView!
    //
    @IBOutlet weak var titleLabel: UILabel!
    // 检索
    @IBOutlet weak var commonBtn: UIButton!
    
    // 输入框
    @IBOutlet weak var textFieldView: UITextField!

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
extension InputTextView {
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        myInputView.backgroundColor = UIColor.clear
        hideTapView.backgroundColor = UIColor.clear
        
        hideTapView.isUserInteractionEnabled = true
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideTapAction))
        hideTapView.addGestureRecognizer(hideTap)
        
        
        titleLabel.textColor = HexColor(MainColor)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        
        commonBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 5)
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        commonBtn.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)

    }
    

}


extension InputTextView {
    
    @objc func commonBtnAction() {
//        contentView = nil
//        removeFromSuperview()
//        let commonView = ApplyFriendView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
//        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
//        UIApplication.shared.keyWindow?.addSubview(commonView)
        
        if  let delegate = delegate {
            delegate.commonBtnClick()
        }
    }
    
    @objc func hideTapAction() {
        textFieldView.text = ""
        textFieldView.resignFirstResponder()
        contentView = nil
        removeFromSuperview()
    }
    

    
    
}


extension InputTextView {
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
