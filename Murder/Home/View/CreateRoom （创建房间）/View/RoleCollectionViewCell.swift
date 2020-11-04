//
//  RoleCollectionViewCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/27.
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
    
    var roleModel: RoleModel! {
        didSet {
            guard let roleModel = roleModel else {
                return
            }
            roleImgView.setImageWith(URL(string: roleModel.head), placeholder: UIImage(named: ""))
            nameLabel.text = roleModel.name
            introductionLabel.text = roleModel.describe
        }
    }
    
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
        nameLabel.backgroundColor = UIColor.clear
        introductionLabel.backgroundColor = UIColor.clear
        
        bgView.layoutIfNeeded()
        bgView.backgroundColor = HexColor("F5F5F5")
        bgView.viewWithCorner(byRoundingCorners: [.topRight,.bottomRight], radii: 5)
        
        
    }
}
