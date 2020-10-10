//
//  ApplyFriendView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ApplyFriendView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var playerView: UIView!
    
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
    // 申请好友
    @IBOutlet weak var applyBtn: GradienButton!
    // 取消
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var userFindModel: UserFindModel? {
        didSet {
            if userFindModel != nil {
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
extension ApplyFriendView {
    
    private func refreshUI() {
        if userFindModel?.head != nil {
            let head = userFindModel?.head
            playerImgView.setImageWith(URL(string: head!))
        }
        
        if userFindModel?.nickname != nil {
            playerNameLabel.text = userFindModel?.nickname!
        }
        
        if userFindModel?.level != nil {
            levelLabel.text = userFindModel?.level!
        }
        
        if userFindModel?.userId != nil {
            let user_id = userFindModel?.userId
            IDLabel.text = "ID:\(user_id!)"
        }
        
        if userFindModel?.sex != nil {
            let sex = userFindModel?.sex!
            switch sex {
            case 1:
                sexImgView.image = UIImage(named: "sex_man")
            case 2:
                sexImgView.image = UIImage(named: "sex_woman")
            default:
                break
            }
            
        }
        // 是否已申请 1是 0否
        if userFindModel?.isApply != nil {
            applyBtn.isHidden = false
            deleteBtn.isHidden = true
            let isApply = userFindModel?.isApply!
            switch isApply {
            case 0:
                applyBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
                applyBtn.isUserInteractionEnabled = true
            case 1:
                applyBtn.gradientClearLayerColor(cornerRadius: 22)
                applyBtn.backgroundColor = HexColor("#CACACA")
                applyBtn.layer.cornerRadius = 22
                applyBtn.setTitleColor(UIColor.white, for: .normal)
                applyBtn.setTitle("友達申し込みは発送しました", for: .normal)
                applyBtn.isUserInteractionEnabled = false
            default:
                break
            }
        }
        
//        // 是否是朋友 1是 0否
//        if userFindModel?.isFriend != nil, userFindModel?.isFriend == 1 {
//            deleteBtn.isHidden = false
//            applyBtn.isHidden = true
//        }
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
        
        
        // 好友申请
        applyBtn.setTitleColor(UIColor.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        applyBtn.addTarget(self, action: #selector(applyBtnAction), for: .touchUpInside)
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        
        // 删除好友
        deleteBtn.createButton(style: .left, spacing: 3, imageName: "message_delete", title: "友達削除", cornerRadius: 0, color: "#FFFFFF")
        deleteBtn.setTitleColor(HexColor(LightDarkGrayColor), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        deleteBtn.isHidden = true
    }
    

}


extension ApplyFriendView {
    @objc private func cancelBtnAction() {
        contentView = nil
        removeFromSuperview()
    }
    
    //
    @objc private func applyBtnAction() {
        let receive_id = userFindModel?.userId
        applyFriendRequest(receive_id: receive_id!) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                self!.applyBtn.gradientClearLayerColor(cornerRadius: 22)
                self!.applyBtn.backgroundColor = HexColor("#CACACA")
                self!.applyBtn.layer.cornerRadius = 22
                self!.applyBtn.setTitleColor(UIColor.white, for: .normal)
                self!.applyBtn.setTitle("友達申し込みは発送しました", for: .normal)
                self!.applyBtn.isUserInteractionEnabled = false
            }
        }
        
    }
    
    //MARK:- 删除好友
    @objc private func deleteBtnAction() {
        contentView = nil
        removeFromSuperview()
        let commonView = DeleteFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.deleteBtnTapBlcok = {[weak self] () in
            let friend_id = self?.userFindModel!.userId
            deleteFriendRequest(friend_id: friend_id!) { (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
    //                    let data = resultDic["data"] as! [String : AnyObject]
                    
                }
            }
        }
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
    
}


extension ApplyFriendView {
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

