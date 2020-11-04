//
//  RoleIntroductionViewCell.swift
//  Murder
//
//  Created by m.a.c on 2020/11/3.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

typealias CellCancelBtnBlock = () ->()


class RoleIntroductionViewCell: UICollectionViewCell {
    
    var cellCancelBtnBlock: CellCancelBtnBlock?
    
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    // 人物介绍
    @IBOutlet weak var introduceLabel: UILabel!
    // 取消
    @IBOutlet weak var cancelBtn: UIButton!
    
    var roleModel: RoleModel! {
        didSet {
            guard let roleModel = roleModel else {
                return
            }
            
            if roleModel.head != nil {
                avatarImgView.setImageWith(URL(string: roleModel.head), placeholder: UIImage(named: ""))
            }
            
            if roleModel.name != nil {
                nameLabel.text = roleModel.name
            }
            
            if roleModel.describe != nil {
                introduceLabel.text = roleModel.describe
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 设置UI
        setUI()
    }

}

extension RoleIntroductionViewCell {
    //MARK:- 设置UI
    private func setUI() {
        nameLabel.textColor = HexColor(DarkGrayColor)
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        introduceLabel.textColor = HexColor(LightDarkGrayColor)
        introduceLabel.font = UIFont.systemFont(ofSize: 12)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        
    }
}


extension RoleIntroductionViewCell {
    @objc func cancelBtnAction() {
        if cellCancelBtnBlock != nil {
            cellCancelBtnBlock!()
        }
    }
}

