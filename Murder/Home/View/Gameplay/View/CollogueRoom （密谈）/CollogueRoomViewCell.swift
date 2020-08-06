//
//  CollogueRoomViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class CollogueRoomViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var commonBtn: UIButton!
    
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


extension CollogueRoomViewCell {
    private func setUI() {
        commonBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 15)
//        commonBtn.gradientColor(start: "#FA7373", end: "#FF1515", cornerRadius: 15)
        commonBtn.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)
    }
    
    @objc func commonBtnAction() {
        commonBtn.gradientColor(start: "#FA7373", end: "#FF1515", cornerRadius: 15)
    }
}
