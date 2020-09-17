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
    
    var scrollView: SDCycleScrollView!
    
    var bannerArr: [HomeBannerModel] = [HomeBannerModel]()
    
    var userModel: HomeUserModel!
    
    var bannerList: [HomeBannerModel] = [HomeBannerModel]()
    
    var homeViewModel: HomeViewModel! {
        didSet {
            guard let homeViewModel = homeViewModel else {
                return
            }
            
            if homeViewModel.userModel != nil {
                let userModel = homeViewModel.userModel
                headImgView.setImageWith(URL(string: userModel!.head), placeholder: UIImage(named: ""))
                
                if userModel!.nickname != nil {
                    nicknameLabel.text = userModel!.nickname
                }
                
                if userModel!.level != nil {
                    levelLabel.text = userModel!.level
                }
            }
            
            infoView.layoutIfNeeded()
            
            infoView.backgroundColor = HexColor(hex: "#000000", alpha: 0.1)
            infoView.viewWithCorner(byRoundingCorners: [.topRight,.bottomRight], radii: 24)
            
            var arr = Array<Any>()
            for item in homeViewModel.bannerModelArr! {
                let model = item
                arr.append(model.img as Any)
            }
            
            scrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: 345*SCALE_SCREEN, height: 150), imageNamesGroup: arr)!
            scrollView.autoScrollTimeInterval = 5.0
            bannerView.addSubview(scrollView)
            scrollView.layer.cornerRadius = 10
            scrollView.layer.masksToBounds = true
            scrollView.backgroundColor = UIColor.white
            
            scrollView.clickItemOperationBlock = { [weak self] (currentIndex) in
                let bannerModel = homeViewModel.bannerModelArr![currentIndex]
                let vc = BannerWebViewController()
                vc.bannerModel = bannerModel
//                vc.urlString = bannerModel.datas!
                let nav = self?.findNavController()
                nav?.pushViewController(vc, animated: true)
            }
                    
        }
        
        
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
        
        bannerView.backgroundColor = UIColor.clear
//        scrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: 345*SCALE_SCREEN, height: 150), imageNamesGroup: arr)!
//        bannerView.addSubview(scrollView)
//        scrollView.layer.cornerRadius = 10
//        scrollView.layer.masksToBounds = true
//        scrollView.backgroundColor = UIColor.white
    }
    
    //查找视图对象的响应者链条中的导航视图控制器
    private func findNavController() -> UINavigationController? {
         
         //遍历响应者链条
         var next = self.next
         //开始遍历
         while next != nil {
            //判断next 是否是导航视图控制器
            if let nextobj = next as? UINavigationController {
                return nextobj
            }
            //如果不是导航视图控制器 就继续获取下一个响应者的下一个响应者
            next = next?.next
         }
        return nil
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

