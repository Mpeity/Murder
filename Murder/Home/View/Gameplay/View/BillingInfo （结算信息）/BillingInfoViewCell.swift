//
//  BillingInfoViewCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class BillingInfoViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImgView: UIImageView!
    
    @IBOutlet weak var iconLabel: UILabel!
    
    @IBOutlet weak var avartImgView: UIImageView!
    
    @IBOutlet weak var boultImgView: UIImageView!
    
    @IBOutlet weak var headerImgView: UIImageView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var experenceLabel: UILabel!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var itemModel : SettlementModel? {
        didSet {
            if itemModel != nil {
                
                if itemModel?.userHead != nil {
                    avartImgView.setImageWith(URL(string: (itemModel?.userHead!)!))
                }
                
                if itemModel?.userNickname != nil {
                    nicknameLabel.text = itemModel?.userNickname!
                }
                
                if itemModel?.roleHead != nil {
                    
                    headerImgView.setImageWith(URL(string: (itemModel?.roleHead!)!))
                }
                
                if itemModel?.roleName != nil {
                    nameLabel.text = itemModel?.roleName!
                }
                
                let expScore = itemModel?.expScore!
                experenceLabel.text = "EXP：" +  String(expScore!)
                let score = itemModel?.score!
                scoreLabel.text = "スコア：" +  String(score!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BillingInfoViewCell {
    private func setUI() {
        
        headerImgView.layer.cornerRadius = 19
        headerImgView.layer.masksToBounds = true
        
        avartImgView.layer.cornerRadius = 25
        avartImgView.layer.masksToBounds = true
        
        scoreLabel.layer.borderColor = HexColor(LightOrangeColor).cgColor
        scoreLabel.layer.borderWidth = 0.5
        scoreLabel.layer.cornerRadius = 15
        
        experenceLabel.layer.borderColor = HexColor(MainColor).cgColor
        experenceLabel.layer.borderWidth = 0.5
        experenceLabel.layer.cornerRadius = 15
    }
}
