//
//  ApplyFriendsListCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/30.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

// 拒绝申请
typealias RefuseBtnTapBlcok = () ->()
// 通过申请
typealias PassBtnTapBlcok = () ->()


class ApplyFriendsListCell: UITableViewCell {
    
    var refuseBtnTapBlcok: RefuseBtnTapBlcok?
    
    var passBtnTapBlcok : PassBtnTapBlcok?
    
    // 头像
    @IBOutlet weak var avatarImgView: UIImageView!
    // 性别
    @IBOutlet weak var sexImgView: UIImageView!
    // 昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    // 状态
    @IBOutlet weak var statusLabel: UILabel!
    // 拒绝
    @IBOutlet weak var refuseBtn: UIButton!
    // 通过
    @IBOutlet weak var passBtn: UIButton!
    
    var itemModel: FriendsApplyListModel? {
        didSet {
            if itemModel != nil {
                refreshUI()
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

extension ApplyFriendsListCell {
    
    private func refreshUI() {
        if itemModel?.head != nil {
            let head = itemModel?.head!
            avatarImgView.setImageWith(URL(string: head!))
        }
        
        if itemModel?.nickname != nil {
            nicknameLabel.text = itemModel?.nickname!
        }
        
        if itemModel?.sex != nil {
            let sex = itemModel?.sex!
            switch sex {
            case 1:
                sexImgView.image = UIImage(named: "sex_man")
            case 2:
                sexImgView.image = UIImage(named: "sex_woman")
            default:
                break
            }
            
        }
        
        // 状态【0申请1通过2拒绝】
        if itemModel?.status != nil {
            let status = itemModel?.status!
            switch status {
            case 0:
                statusLabel.isHidden = true
                passBtn.isHidden = false
                refuseBtn.isHidden = false
            case 1:
                statusLabel.isHidden = false
                passBtn.isHidden = true
                refuseBtn.isHidden = true
                statusLabel.text = "認めた"
                statusLabel.textColor = HexColor(MainColor)
            case 2:
                statusLabel.isHidden = false
                passBtn.isHidden = true
                refuseBtn.isHidden = true
                statusLabel.text = "断った"
                statusLabel.textColor = HexColor(LightGrayColor)

            default:
                break
            }
        }
        
        
    }
    
    private func setUI() {
        statusLabel.textColor = HexColor(MainColor)
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        refuseBtn.gradientColor(start: "#FA7373", end: "#FF1515", cornerRadius: 5)
        refuseBtn.setTitleColor(UIColor.white, for: .normal)
        passBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 5)
        passBtn.setTitleColor(UIColor.white, for: .normal)
        
        refuseBtn.addTarget(self, action: #selector(refuseBtnAction), for: .touchUpInside)
        passBtn.addTarget(self, action: #selector(passBtnAction), for: .touchUpInside)
        
        refuseBtn.isHidden = true
        passBtn.isHidden = true
        statusLabel.isHidden = false
        statusLabel.text = ""
        
        

    }
}

extension ApplyFriendsListCell {
    @objc private func refuseBtnAction() {
        if refuseBtnTapBlcok != nil {
            refuseBtnTapBlcok!()
        }
    }
    
    @objc private func passBtnAction() {
        if passBtnTapBlcok != nil {
            passBtnTapBlcok!()
        }
    }
}
