//
//  CollogueRoomViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

//typealias AvatarImgTapBlcok = () ->()

typealias CommonBtnActionBlcok = () ->()

typealias LeaveBtnActionBlcok = () ->()



class CollogueRoomViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var commonBtn: UIButton!
    
    @IBOutlet weak var leaveBtn: UIButton!
    
    var commonBtnActionBlcok: CommonBtnActionBlcok?
    
    var leaveBtnActionBlcok: LeaveBtnActionBlcok?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
//        if selected {
//            commonBtn.isHidden = true
//            leaveBtn.isHidden = false
//        } else {
//            commonBtn.isHidden = false
//            leaveBtn.isHidden = true
//        }
        
    }
    
    
    

    
}


extension CollogueRoomViewCell {
    private func setUI() {
        commonBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 15)
        leaveBtn.gradientColor(start: "#FA7373", end: "#FF1515", cornerRadius: 15)
        commonBtn.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)
        leaveBtn.addTarget(self, action: #selector(leaveBtnAction), for: .touchUpInside)
        commonBtn.isHidden = false
        leaveBtn.isHidden = true

    }
    
    @objc func commonBtnAction() {
        commonBtn.isHidden = true
        leaveBtn.isHidden = false
        commonBtnActionBlcok!()
    }
    
    @objc func leaveBtnAction() {
        commonBtn.isHidden = true
        leaveBtn.isHidden = true
        leaveBtnActionBlcok!()
    }
}
