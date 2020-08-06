//
//  HomeListViewCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit


class HomeListViewCell: UITableViewCell {
    
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    
    // 房间人数 剧本人数  剧本名称
    @IBOutlet weak var infoLabel: UILabel!
    
    // 房主昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    // 房间id
    @IBOutlet weak var roomIdLabel: UILabel!
    // 时长
    @IBOutlet weak var timeLabel: UILabel!
    
    let roomNum: String = "7"
    let peopleNum : String = "2"
    let name: String = "エレベーターの悪魔"
    
    
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

extension HomeListViewCell {
    private func setUI() {
        coverImgView.layer.cornerRadius = 10
        infoLabel.textColor = HexColor(LightOrangeColor)
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        nicknameLabel.textColor = HexColor(LightDarkGrayColor)
        nicknameLabel.font = UIFont.systemFont(ofSize: 12)
        
        roomIdLabel.textColor = HexColor(LightDarkGrayColor)
        roomIdLabel.font = UIFont.systemFont(ofSize: 12)
        
        timeLabel.textColor = HexColor(LightDarkGrayColor)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        
        

        let string = "\(roomNum)/\(peopleNum)   \(name)"
        let ranStr = "/\(peopleNum)"
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
        let str = NSString(string: string)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor(DarkGrayColor), range: theRange)
        infoLabel.attributedText = attrstring
        
    }
}
