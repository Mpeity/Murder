//
//  VoteCommonCell.swift
//  Murder
//
//  Created by m.a.c on 2020/8/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class VoteCommonCell: UICollectionViewCell {
    @IBOutlet weak var commonView: UIView!
    
    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var contextLabel: UILabel!
    
    var itemModel: TrueUserModel? {
        didSet {
            if itemModel?.head != nil {
                avatarImgView.setImageWith(URL(string: (itemModel?.head)!))
            }
            
            if itemModel?.name != nil {
                contextLabel.text = itemModel?.name!
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImgView.layer.cornerRadius = 22.5
        avatarImgView.layer.masksToBounds = true
    }

}
