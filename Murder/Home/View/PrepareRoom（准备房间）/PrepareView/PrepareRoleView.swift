//
//  PrepareRoleView.swift
//  Murder
//
//  Created by m.a.c on 2020/10/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PrepareRoleView: UIView {

    var itemModel: ScriptRoleModel? {
        didSet {
            
            if (itemModel != nil) {
                if (itemModel?.head != nil) {
                    let roleHead = itemModel?.head!
                    roleImgView.setImageWith(URL(string: roleHead!))
                }
                
                if (itemModel?.roleName != nil) {
                    roleNameLabel.text = itemModel?.roleName!
                }
                
                if itemModel?.describe != nil {
                    roleIntroduceLabel.text = itemModel?.describe
                }
            }
        }
    }
    
    
    @IBOutlet var contentView: UIView!
    
    // 角色
    @IBOutlet weak var roleView: UIView!
    
    @IBOutlet weak var roleImgView: UIImageView!
    // 角色姓名
    @IBOutlet weak var roleNameLabel: UILabel!
    // 人物介绍
    @IBOutlet weak var roleIntroduceLabel: UILabel!
    
    // 取消按钮
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        contentView = nil
        self.removeFromSuperview()
    }
    
 //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
        
        // 初始化
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
    }
 
}


extension PrepareRoleView {
    private func setUI() {
        // 设置圆角
        roleView.layer.cornerRadius = 15
        // 角色
        roleNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        roleImgView.layer.cornerRadius = 30

    }
}


extension PrepareRoleView {
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
