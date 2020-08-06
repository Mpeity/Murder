//
//  PrepareRoomShareView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/3.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

// 点击textViewBlock回掉
typealias BtnTapBlcok = (Any) ->()

class PrepareRoomShareView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    // 昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    
    // 性别
    @IBOutlet weak var sexImgView: UIImageView!
    
    // 等级
    @IBOutlet weak var levelLabel: UILabel!

    
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    // 房间号
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var roomIdLabel: UILabel!
    
    @IBOutlet weak var commonBtn: UIButton!
    
    // 进入房间回掉
//    var enterBtnTapBlcok : EnterBtnTapBlcok?

    
    
    
    
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


extension PrepareRoomShareView {
    private func setUI() {
        
        avatarImgView.layer.cornerRadius = 30
        avatarImgView.layer.borderColor = UIColor.white.cgColor
        avatarImgView.layer.borderWidth = 2
        
        nicknameLabel.textColor = UIColor.white
        nicknameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        levelLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        levelLabel.textColor = UIColor.white
        levelLabel.layer.cornerRadius = 7.5
        levelLabel.layer.masksToBounds = true
        
        coverImgView.layer.cornerRadius = 5
        coverImgView.layer.borderWidth = 2
        coverImgView.layer.borderColor = UIColor.white.cgColor
        
        
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        roomView.layer.cornerRadius = 5
        roomView.layer.borderWidth = 0.5
        roomView.layer.borderColor = UIColor.white.cgColor
        roomIdLabel.textColor = UIColor.white
        roomIdLabel.font = UIFont.systemFont(ofSize: 12)
  
        commonBtn.backgroundColor = HexColor(LightOrangeColor)
        commonBtn.layer.cornerRadius = 25
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        commonBtn.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)
    }
}

extension PrepareRoomShareView {
    @objc func commonBtnAction(){
        
    }
    

    
    
}

extension PrepareRoomShareView {
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
