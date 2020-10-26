//
//  MineScriptCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/10/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MineScriptCell: UICollectionViewCell {

    // 封面
    @IBOutlet weak var scriptImgView: UIImageView!
    // 剧本名称
    @IBOutlet weak var nameLabel: UILabel!
    
    // 顶部标签
    @IBOutlet weak var tagView: UIView!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
