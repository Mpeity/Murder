//
//  MineTableHeaderView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/25.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MineTableHeaderView: UIView {
    
    
    @IBOutlet var contentView: UIView!
    // 背景图
    @IBOutlet weak var bgImgView: UIImageView!
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    // 昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    // 等级
    @IBOutlet weak var levelLabel: UILabel!
    // 标识
    @IBOutlet weak var identifyLabel: UILabel!
    
    var mineModel: MineModel? {
        didSet {
            guard let mineModel = mineModel else {
                return
            }
            
            if mineModel.head != nil {
                avatarImgView.setImageWith(URL(string: mineModel.head!), placeholder: UIImage(named: ""))
            }
            
            if mineModel.nickname != nil {
                nicknameLabel.text = mineModel.nickname!
            }
            
            if mineModel.level != nil {
                levelLabel.text = mineModel.level
            }
            
            if mineModel.headId != nil {
                identifyLabel.text = "ID:\(mineModel.headId!)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        

    }
    
    

}

extension MineTableHeaderView {
    private func setUI() {
        avatarImgView.layer.borderColor = UIColor.white.cgColor
        avatarImgView.layer.borderWidth = 2
        avatarImgView.layer.cornerRadius = 43
        
        nicknameLabel.textColor = UIColor.white
        nicknameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        leftView.layer.borderColor = UIColor.white.cgColor
        leftView.layer.borderWidth = 0.5
        leftView.layer.cornerRadius = 7.5
        
        rightView.layer.borderColor = UIColor.white.cgColor
        rightView.layer.borderWidth = 0.5
        rightView.layer.cornerRadius = 7.5
    }
    
}

extension MineTableHeaderView {
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
