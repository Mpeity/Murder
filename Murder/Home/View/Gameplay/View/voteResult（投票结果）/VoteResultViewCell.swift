//
//  VoteResultViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class VoteResultViewCell: UITableViewCell {
    // 题目
    @IBOutlet weak var subjectLabel: UILabel!
    // 单选/多选
    @IBOutlet weak var propertyLabel: UILabel!
    // 正答
    @IBOutlet weak var tipOneLabel: UILabel!
    
    // 答案
    @IBOutlet weak var answerView: UIView!
    // 
    @IBOutlet weak var tipTwoLabel: UILabel!
    @IBOutlet weak var commonView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension VoteResultViewCell {
    private func setUI() {
        subjectLabel.textColor = HexColor(DarkGrayColor)
        subjectLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        tipOneLabel.textColor = HexColor(DarkGrayColor)
        tipOneLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        tipTwoLabel.textColor = HexColor(DarkGrayColor)
        tipTwoLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        answerView.backgroundColor = UIColor.clear
        commonView.backgroundColor = UIColor.clear
        
//        let answer = AnswerView(frame: CGRect(x: 0, y: 0, width: answerView.bounds.size.width, height: 25))
//        answerView.addSubview(answer)
//
//
//        let common = VoteCommonView(frame: CGRect(x: 0, y: 0, width: commonView.bounds.size.width, height: 65))
//        commonView.addSubview(common)

    }
}
