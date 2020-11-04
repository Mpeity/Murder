//
//  RoleIntroductionView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let RoleIntroductionViewCellId = "RoleIntroductionViewCellId"

class RoleIntroductionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var contentView: UIView!
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal     //滚动方向
        layout.itemSize = CGSize(width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT)
        // 行间距
        layout.minimumLineSpacing = 0
        // 列间距
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        
    }()
    
    var role: [RoleModel]! = [RoleModel]() {
        didSet {
            guard role != nil else {
                return
            }
            collectionView.reloadData()
        }
        
    }
    
    var selectIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            collectionView.selectItem(at: selectIndexPath, animated: false, scrollPosition: .bottom)
            collectionView.reloadData()
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
    
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return role.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoleIntroductionViewCellId, for: indexPath) as! RoleIntroductionViewCell
        cell.roleModel = role[indexPath.item]
        cell.cellCancelBtnBlock = {[weak self] () in
            self?.isHidden = true
        }
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

    
}

extension RoleIntroductionView {
    //MARK:- 设置UI
    private func setUI() {
        self.contentView.addSubview(collectionView)
        collectionView.register(UINib(nibName: "RoleIntroductionViewCell", bundle: nil), forCellWithReuseIdentifier: RoleIntroductionViewCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
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
