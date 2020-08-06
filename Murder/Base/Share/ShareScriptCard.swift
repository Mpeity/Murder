//
//  ShareScriptCard.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/31.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ShareScriptCard: UIView {
    
    var isShareScript: Bool = true
    
    @IBOutlet var contentView: UIView!
    // 性别
    @IBOutlet weak var commonLabel: UILabel!
    
    @IBOutlet weak var sexImgView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    // 内容
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    
    // 名字顶部约束
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    // id
    @IBOutlet weak var idLabel: UILabel!
    
    
    
    
    // 送信
    @IBOutlet weak var sendBtn: UIButton!
    
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
extension ShareScriptCard {
    
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        cancelBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        sendBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        sendBtn.setTitle("送信", for: .normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        commonLabel.textColor = HexColor(DarkGrayColor)
        commonLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        tipLabel.textColor = HexColor(LightGrayColor)
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        
        nameLabel.textColor = HexColor(DarkGrayColor)
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        idLabel.textColor = HexColor(LightGrayColor)
        idLabel.font = UIFont.systemFont(ofSize: 12)
        
        if isShareScript {
            nameTopConstraint.constant = 21.5
            idLabel.isHidden = true
            layoutIfNeeded()
        } else {
            nameTopConstraint.constant = 10
            idLabel.isHidden = false
            layoutIfNeeded()
        }
        
    }
    

}

extension ShareScriptCard {
    // 取消
    @objc private func hideView() {
        contentView = nil
        self.removeFromSuperview()
    }
}



extension ShareScriptCard {
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

