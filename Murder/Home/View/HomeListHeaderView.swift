//
//  HomeListHeaderView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SDCycleScrollView

class HomeListHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    // 背景图片
    @IBOutlet weak var bgImgView: UIImageView!
    // 头像
    @IBOutlet weak var headImgView: UIImageView!
    // 头像离顶部的距离
    @IBOutlet weak var headImgViewTopConstraint: NSLayoutConstraint!
    // 透明视图
    @IBOutlet weak var infoView: UIView!
    // 昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    // 等级
    @IBOutlet weak var levelLabel: UILabel!
    
    // 轮播图
    @IBOutlet weak var bannerView: UIView!
    
    
    
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

extension HomeListHeaderView {
    //MARK:- 设置UI
    private func setUI() {
        headImgViewTopConstraint.constant = STATUS_BAR_HEIGHT + 16
        
        bgImgView.image = UIImage(named: "home_header_bg")
        
        headImgView.layer.borderColor = UIColor.white.cgColor
        headImgView.layer.borderWidth = 1
        headImgView.layer.cornerRadius = 27.5
        
        infoView.backgroundColor = HexColor(hex: "#000000", alpha: 0.1)
        infoView.viewWithCorner(byRoundingCorners: [.topRight,.bottomRight], radii: 24)
        
        nicknameLabel.backgroundColor = UIColor.clear
        nicknameLabel.textColor = UIColor.white
        nicknameLabel.textAlignment = .left
        nicknameLabel.font = UIFont.systemFont(ofSize: 15)
        
        levelLabel.backgroundColor = HexColor("#FEAD21")
        levelLabel.textColor = UIColor.white
        levelLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        levelLabel.layer.cornerRadius = 9
        levelLabel.layer.masksToBounds = true
        
        
        let arr = ["https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1899402122,4230827200&fm=26&gp=0.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596188930281&di=38b7af383aedc7d7bcc65baf45fae856&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F2018-01-03%2F5a4c4270d8799.jpg","https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596188999127&di=c26d930c5c4ce1455ca7a1140a6376dc&imgtype=0&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D1753371632%2C983488119%26fm%3D214%26gp%3D0.jpg"]
        bannerView.backgroundColor = UIColor.clear
        let scrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: 345*SCALE_SCREEN, height: 150), imageNamesGroup: arr)!
        bannerView.addSubview(scrollView)
        scrollView.layer.cornerRadius = 10
        scrollView.layer.masksToBounds = true
        scrollView.backgroundColor = UIColor.white
    }
}

extension HomeListHeaderView {
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

