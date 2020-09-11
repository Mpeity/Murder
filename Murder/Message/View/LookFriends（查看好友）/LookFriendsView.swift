
//
//  LookFriendsView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class LookFriendsView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var playerView: UIView!
    // 删除好友
    @IBOutlet weak var deleteBtn: UIButton!
    
    // 头像
    @IBOutlet weak var playerImgView: UIImageView!
    // 名称
    @IBOutlet weak var playerNameLabel: UILabel!
    // 性别
    @IBOutlet weak var sexImgView: UIImageView!
    
    // 等级
    @IBOutlet weak var levelLabel: UILabel!
    
    // id
    @IBOutlet weak var IDLabel: UILabel!
    
    // 取消
    @IBOutlet weak var cancelBtn: UIButton!
    
    var itemModel: MessageListModel? {
        didSet {
            if itemModel != nil {
                refreshUI()
            }
        }
    }
    
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
    
        
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}




// MARK: - setUI
extension LookFriendsView {
    
    
    private func refreshUI() {
        if itemModel?.head != nil {
            let head = itemModel?.head
            playerImgView.setImageWith(URL(string: head!))
        }
        
        if itemModel?.nickname != nil {
            playerNameLabel.text = itemModel?.nickname!
        }
        
        if itemModel?.level != nil {
            levelLabel.text = itemModel?.level!
        }
        
        if itemModel?.userId != nil {
            let user_id = itemModel?.userId!
            IDLabel.text = "ID:\(user_id!)"
        }
        
        if itemModel?.sex != nil {
            let sex = itemModel?.sex!
            switch sex {
            case 1:
                sexImgView.image = UIImage(named: "sex_man")
            case 2:
                sexImgView.image = UIImage(named: "sex_woman")
            default:
                break
            }
        }
        
    }
    
    private func setUI() {

        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        playerImgView.layer.cornerRadius = 30
        playerImgView.layer.masksToBounds = true
        playerNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        levelLabel.layer.cornerRadius = 7.5
        levelLabel.layer.masksToBounds = true
        IDLabel.layer.cornerRadius = 7.5
        IDLabel.layer.masksToBounds = true
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        deleteBtn.createButton(style: .left, spacing: 3, imageName: "message_delete", title: "友達削除", cornerRadius: 0, color: "#FFFFFF")
        deleteBtn.setTitleColor(HexColor(LightDarkGrayColor), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
    }
    

}


extension LookFriendsView {
    @objc private func cancelBtnAction() {
        contentView = nil
        removeFromSuperview()
    }
    
    @objc private func deleteBtnAction() {

        self.isHidden = true
        let commonView = DeleteFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.deleteBtnTapBlcok = {[weak self] () in
            let friend_id = self?.itemModel?.userId
            deleteFriendRequest(friend_id: friend_id!) { (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
//                    let data = resultDic["data"] as! [String : AnyObject]
                    self?.contentView = nil
                    self?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Delete_Friend_Notif), object: nil)
                }
            }
        }
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
    
}


extension LookFriendsView {
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
