//
//  ThreadLeftCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ThreadLeftCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var pointView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        pointView.isHidden = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            titleLabel.textColor = UIColor.white
            self.backgroundColor = HexColor(MainColor)
        } else {
            titleLabel.textColor = HexColor(DarkGrayColor)
            self.backgroundColor = UIColor.white
        }
    }
    
}
