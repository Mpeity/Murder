//
//  RoleIntroductionCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let RoleCollectionViewCellId = "RoleCollectionViewCellId"


class RoleIntroductionCell:UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var role: [RoleModel]! = [RoleModel]() {
        didSet {
            guard role != nil else {
                return
            }
            collectionView.reloadData()
        }
        
    }
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal     //滚动方向
        layout.itemSize = CGSize(width: 177, height: 82)
        // 行间距
        layout.minimumLineSpacing = 13
        // 列间距
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 82), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
         setUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return role.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoleCollectionViewCellId, for: indexPath) as! RoleCollectionViewCell
        cell.roleModel = role[indexPath.item]
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         弹出 人物介绍弹框
        let commonView = RoleIntroductionView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.roleModel = role[indexPath.item]
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }

}

extension RoleIntroductionCell {
    private func setUI() {
        self.addSubview(collectionView)
        collectionView.register(UINib(nibName: "RoleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RoleCollectionViewCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension RoleIntroductionCell {
 
}
