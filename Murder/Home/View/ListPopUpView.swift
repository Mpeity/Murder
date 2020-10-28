//
//  ListPopUpView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

// 点击textViewBlock回掉
typealias EnterBtnTapBlcok = (Any) ->()

class ListPopUpView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    // 剧本名称
    @IBOutlet weak var nameLabel: UILabel!
    // 房间ID
    @IBOutlet weak var roomIdLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!
    // 评分
    @IBOutlet weak var scoreIcon: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    // 时长
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    // 进入房间
    @IBOutlet weak var enterBtn: UIButton!
    
    // 取消按钮
    @IBOutlet weak var cancelBtn: UIButton!
    
    // 进入房间回掉
    var enterBtnTapBlcok : EnterBtnTapBlcok?
    
    var roomModel: HomeRoomModel! {
        didSet {
            guard let roomModel = roomModel else {
                return
            }
            if roomModel.scriptName != nil {
                nameLabel.text = roomModel.scriptName
            }
            
            if roomModel.roomId != nil {
                roomIdLabel.text = "ルームID：\(String(roomModel.roomId))"
            }
            
            if roomModel.durationText != nil {
                timeLabel.text = roomModel.durationText
            }
            
            if roomModel.commentScore != nil {
                let count = "レビュー: \(roomModel.commentScore!)"
                scoreLabel.text = count
            }
            
        }
    }
    
    

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ListPopUpView {
    private func setUI() {
        
        topConstraint.constant = 175 * SCALE_SCREEN
        
        nameLabel.textColor = HexColor(DarkGrayColor)
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        roomIdLabel.textColor = HexColor(LightGrayColor)
        roomIdLabel.font = UIFont.systemFont(ofSize: 11)
        
        scoreView.isHidden = false
        scoreLabel.textColor = HexColor(DarkGrayColor)
        scoreLabel.font = UIFont.systemFont(ofSize: 18)
        scoreIcon.isHidden = false
        
        timeLabel.textColor = HexColor(DarkGrayColor)
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        
//        enterBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        enterBtn.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
        enterBtn.addTarget(self, action: #selector(enterBtnAction), for: .touchUpInside)
        enterBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
    }
}

extension ListPopUpView {
    @objc func enterBtnAction(){
        guard let enterBtnTapBlcok: EnterBtnTapBlcok = enterBtnTapBlcok else { return }
        enterBtnTapBlcok("1234")
    }
    
    @objc func cancelBtnAction(){
        contentView = nil
        self.removeFromSuperview()
    }

}

extension ListPopUpView {
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
