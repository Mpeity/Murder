//
//  MineListCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/25.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MineListCell: UITableViewCell {
 
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = HexColor("#323232")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
