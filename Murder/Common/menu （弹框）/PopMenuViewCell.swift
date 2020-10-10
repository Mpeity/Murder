//
//  PopMenuViewCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PopMenuViewCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var point: UIView!
    
    var type : String? = "script"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.isHidden = true
        point.isHidden = true
        point.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if type! == "place" {
            if selected {
                contentLabel.textColor = HexColor(MainColor)
            } else {
                contentLabel.textColor = HexColor("#999999")
            }
        }
        if type! == "script" {
            if selected {
                imgView?.isHidden = false
                contentLabel.textColor = HexColor(MainColor)
            } else {
                imgView?.isHidden = true
                contentLabel.textColor = UIColor.white
            }
        }
        
        if type! == "truth" {
            if selected {
                imgView?.isHidden = false
                contentLabel.textColor = HexColor(MainColor)
            } else {
                imgView?.isHidden = true
                contentLabel.textColor = UIColor.white
            }
        }

    }
    
}
