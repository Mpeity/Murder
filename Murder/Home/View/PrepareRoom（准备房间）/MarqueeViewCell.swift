//
//  MarqueeViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/3.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MarqueeViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
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

extension MarqueeViewCell {
    func setUI() {
        statusLabel.textColor = UIColor.white
        statusLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.textColor = HexColor(LightOrangeColor)
        nameLabel.font = UIFont.systemFont(ofSize: 10)
    }
}
