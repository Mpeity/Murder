//
//  HomeListViewCell.swift
//  Murder
//
//  Created by m.a.c on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SDWebImage


class HomeListViewCell: UITableViewCell {
    

    
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    // 有料标签 设置button不可点击
    @IBOutlet weak var tagBtn: UIButton!
    
    // 房间人数 剧本人数  剧本名称
    @IBOutlet weak var infoLabel: UILabel!
    // 标签视图
    @IBOutlet weak var tagImgView: UIImageView!
    
    // 房主昵称
    @IBOutlet weak var nicknameLabel: UILabel!
    // 房间id
    @IBOutlet weak var roomIdLabel: UILabel!
    // 时长
    @IBOutlet weak var timeLabel: UILabel!
    // 评分
    @IBOutlet weak var countLabel: UILabel!
    // 评分星星
    @IBOutlet weak var countView: UIView!
    
    var roomNum: String = ""
    var peopleNum : String = ""
    var name: String = ""
    
    
    var roomModel: HomeRoomModel! {
        didSet {
            guard let roomModel = roomModel else {
                return
            }
            
            
            coverImgView.setImageWith(URL(string: roomModel.cover!), placeholder: UIImage(named: ""))
            roomNum = String(roomModel.scriptRoleNum)
            peopleNum = String(roomModel.userNum)
            name = roomModel.scriptName
            
            let string = "\(peopleNum)/\(roomNum)   \(name)"
            let ranStr = "/\(roomNum)"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
            let str = NSString(string: string)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor(DarkGrayColor), range: theRange)
            infoLabel.attributedText = attrstring
            
            if (roomModel.nickname != nil) {
                nicknameLabel.text = "ルームマスター：\(roomModel.nickname!)"
            }
            
            roomIdLabel.text = "ルームID：\(String(roomModel.roomId))"
            timeLabel.text = roomModel.durationText
            
            if roomModel.commentScore != nil {
                let count = "\(roomModel.commentScore!)"
                countLabel.text = count
            }
            
            if roomModel.scriptStar != nil {
                let starView = StarView(count: CGFloat(roomModel.scriptStar!), lineSpace: 0, fullImgName: "home_star_pic_02", halfImgName: "home_star_pic_03", zeroImgName: "home_star_pic_01", sizeWidth: 18.0, sizeHeight: 18.0, frame: CGRect(x: 0, y: 0, width: 90, height: 22))
                countView.addSubview(starView)
            }
            
            
        }
    }
    
    
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
        coverImgView.layer.cornerRadius = 8
        
        infoLabel.textColor = HexColor(LightOrangeColor)
        infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        nicknameLabel.textColor = HexColor(LightDarkGrayColor)
        nicknameLabel.font = UIFont.systemFont(ofSize: 12)
        
        roomIdLabel.textColor = HexColor(LightDarkGrayColor)
        roomIdLabel.font = UIFont.systemFont(ofSize: 12)
        
        timeLabel.textColor = HexColor(LightDarkGrayColor)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        
        tagBtn.isHidden = true
        tagImgView.isHidden = true
        
        countLabel.textColor = HexColor(DarkGrayColor)
        countLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
}
