//
//  MineTableHeaderView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/25.
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
    
    @IBOutlet weak var allView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    // 等级
    @IBOutlet weak var levelLabel: UILabel!
    // 标识
    @IBOutlet weak var identifyLabel: UILabel!
    
    // 等级标记
    var tapView: UIView!
    
    var tapCommonView: UIView!
    
    let tapImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 132, height: 42))
    
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 132, height: 42))
    
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
                identifyLabel.text = "ID:\(mineModel.userId!)"
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
        
        levelLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showLevelView))
        levelLabel.addGestureRecognizer(tap)
    }
    
}

extension MineTableHeaderView {
    @objc func showLevelView() {
        allView.layoutIfNeeded()

        if tapCommonView == nil {
            tapCommonView = UIView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            tapCommonView.backgroundColor = UIColor.clear
            UIApplication.shared.keyWindow?.addSubview(tapCommonView)
            tapCommonView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(hideLevelView))
            tapCommonView.addGestureRecognizer(tap)
        }
        
        tapCommonView.isHidden = false

        if tapView == nil {
            let leftSpace = allView.frame.origin.x - levelLabel.frame.width * 0.5
            let y = 170 + STATUS_BAR_HEIGHT
            tapView = UIView(frame: CGRect(x: leftSpace, y: y, width: 132, height: 42))
            tapCommonView.addSubview(tapView)
            tapImgView.image = UIImage(named: "mine_level_bg")
            tapView.addSubview(tapImgView)
            titleLabel.textColor = HexColor(MainColor)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            tapView.addSubview(titleLabel)
        }
        if mineModel?.expScore != nil {
            titleLabel.text = mineModel?.expScore!
        }
    }
    
    @objc func hideLevelView() {
        tapCommonView.isHidden = true
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
