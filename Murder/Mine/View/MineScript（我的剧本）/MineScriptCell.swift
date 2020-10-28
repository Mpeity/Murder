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
    
    var  itemModel: MineScriptItemModel? {
        didSet {
            guard let itemModel = itemModel else {
                return
            }
            
            if itemModel.cover != nil {
                let str = itemModel.cover!
                scriptImgView.setImageWith(URL(string: str), placeholder: UIImage(named: "default_script"))
            }
            
            if itemModel.scriptName != nil {
                nameLabel.text = itemModel.scriptName!
            }
            
            if itemModel.userScriptText != nil && itemModel.userScriptText != ""  {
                tagLabel.isHidden = false
                tagView.isHidden = false
                tagLabel.text = itemModel.userScriptText!
            }
        }

    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }

}

extension MineScriptCell {
    private func setUI() {
        tagLabel.isHidden = true
        tagView.isHidden = true
        
        scriptImgView.layer.cornerRadius = 5
        scriptImgView.layer.masksToBounds = true
    }
}
