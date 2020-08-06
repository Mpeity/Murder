//
//  MessageScriptInviteCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/5.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MessageScriptInviteCell: UITableViewCell {

    @IBOutlet weak var bgImgView: UIImageView!
    
    @IBOutlet weak var coverImgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
