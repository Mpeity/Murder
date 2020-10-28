//
//  RecordDetailHeaderView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class RecordDetailHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    // 作者
    @IBOutlet weak var authorLabel: UILabel!
    //  房间id
    @IBOutlet weak var roomIdLabel: UILabel!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commonStarView: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    // 评分
    @IBOutlet weak var countLabel: UILabel!
    // 单位
    @IBOutlet weak var unitLabel: UILabel!
    
    var scriptLogDetail :ScriptLogDetail? {
        didSet {
            guard scriptLogDetail != nil else {
                return
            }
            refreshUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}



extension RecordDetailHeaderView {
    private func setUI() {
        coverImgView.layer.borderColor = UIColor.white.cgColor
        coverImgView.layer.borderWidth = 2
        coverImgView.layer.cornerRadius = 5
        
        unitLabel.textColor = HexColor(LightOrangeColor)
        unitLabel.text = "点"
        unitLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        countLabel.textColor = HexColor(LightOrangeColor)
        countLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        contentLabel.textColor = UIColor.white
        contentLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
    private func refreshUI() {
        if scriptLogDetail?.cover != nil  {
            coverImgView.setImageWith(URL(string: scriptLogDetail!.cover!))
        }
        if scriptLogDetail?.scriptName != nil {
            nameLabel.text = scriptLogDetail?.scriptName!
        }
        if scriptLogDetail?.author != nil {
            authorLabel.text = "作者：\(scriptLogDetail!.author!)"
        }
        if scriptLogDetail?.roomId != nil {
            roomIdLabel.text = "ルームID：\(scriptLogDetail!.roomId!)"
        }
        
        if scriptLogDetail?.commentPeopleText != nil {
            contentLabel.text = scriptLogDetail!.commentPeopleText!
        }
        
        if scriptLogDetail?.commentScore != nil {
            let count = "\(scriptLogDetail!.commentScore!)"
            countLabel.text = count
        }
        
        if scriptLogDetail?.scriptStar != nil {
            let starView = StarView(count: CGFloat((scriptLogDetail?.scriptStar!)!), lineSpace: 0, fullImgName: "pinglun_pic_01", halfImgName: "pinglun_pic_03", zeroImgName: "pinglun_pic_02", sizeWidth: 16.0, sizeHeight: 16.0, frame: CGRect(x: 0, y: 0, width: 80, height: 16))
            commonStarView.addSubview(starView)
        }
    }
}

extension RecordDetailHeaderView {
    //加载xib
     func loadViewFromNib() -> UIView {
         let className = type(of: self)
         let bundle = Bundle(for: className)
         let name = NSStringFromClass(className).components(separatedBy: ".").last
         let nib = UINib(nibName: name!, bundle: bundle)
         let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
         return view
     }
    
     //设置好xib视图约束
     func addConstraints() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView!, attribute: .leading,
                                             relatedBy: .equal, toItem: self, attribute: .leading,
                                             multiplier: 1, constant: 0)
        addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .trailing,
                                         relatedBy: .equal, toItem: self, attribute: .trailing,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal,
                                         toItem: self, attribute: .top, multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .bottom,
                                         relatedBy: .equal, toItem: self, attribute: .bottom,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
     }
}
