//
//  MyLabel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/25.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func drawText(in rect: CGRect) {
        return super.drawText(in: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width - self.font.pointSize*0.5, height: rect.size.height))
    }
    
}


