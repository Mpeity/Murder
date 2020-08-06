//
//  RoleCollectionViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class RoleCollectionViewCell: UICollectionViewCell {

    // 头像
    @IBOutlet weak var roleImgView: UIImageView!
    
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // 人物介绍
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }

}

extension RoleCollectionViewCell {
    @objc func setUI() {
        roleImgView.layoutIfNeeded()
        roleImgView.viewWithCorner(byRoundingCorners: [UIRectCorner.bottomLeft,UIRectCorner.topLeft], radii: 5)
        
        bgView.layoutIfNeeded()
        bgView.viewWithCorner(byRoundingCorners: [UIRectCorner.bottomRight,UIRectCorner.topRight], radii: 5)
        bgView.backgroundColor = HexColor("F5F5F5")
    }
}
