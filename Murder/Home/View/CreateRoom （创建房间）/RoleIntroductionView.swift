//
//  RoleIntroductionView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class RoleIntroductionView: UIView {
    @IBOutlet var contentView: UIView!
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    // 人物介绍
    @IBOutlet weak var introduceLabel: UILabel!
    // 取消
    @IBOutlet weak var cancelBtn: UIButton!
    
    var roleModel: RoleModel! {
        didSet {
            guard let roleModel = roleModel else {
                return
            }
            avatarImgView.setImageWith(URL(string: roleModel.head), placeholder: UIImage(named: ""))
            nameLabel.text = roleModel.name
            introduceLabel.text = roleModel.describe
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addSubview(contentView)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RoleIntroductionView {
    //MARK:- 设置UI
    private func setUI() {
        nameLabel.textColor = HexColor(DarkGrayColor)
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    
        introduceLabel.textColor = HexColor(LightDarkGrayColor)
        introduceLabel.font = UIFont.systemFont(ofSize: 12)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        
    }
}


extension RoleIntroductionView {
    @objc func cancelBtnAction() {
        contentView = nil
        removeFromSuperview()
    }
}

extension RoleIntroductionView {
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
