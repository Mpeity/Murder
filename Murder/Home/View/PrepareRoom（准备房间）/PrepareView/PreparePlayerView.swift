//
//  PreparePlayerView.swift
//  Murder
//
//  Created by m.a.c on 2020/10/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PreparePlayerView: UIView {

    var itemModel: RoomUserModel? {
        didSet {
            
            if (itemModel != nil) {

                if itemModel?.head != nil {
                    let head = itemModel?.head!
                    playerImgView.setImageWith(URL(string: head!))
                }
                
                if itemModel?.nickname != nil {
                    playerNameLabel.text = itemModel?.nickname!
                }
                
                var image : UIImage!
                if itemModel?.sex == 1 {
                    image = UIImage(named: "sex_man")
                } else if itemModel?.sex == 2 {
                    image = UIImage(named: "sex_woman")
                } else {
                    
                }
                sexImgView.image = image

                if itemModel?.level != nil {
                    levelLabel.text = itemModel?.level
                }
                
                if itemModel?.userId != nil {
                    let id = itemModel?.userId!
                    IDLabel.text = "ID:\(String(id!))"
                }
                checkUser()

            }
        }
    }
    
    
    @IBOutlet var contentView: UIView!
    // 玩家
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
    
    
    // 取消按钮
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    @IBAction func applyBtnAction(_ sender: Any) {
        addFriend()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        contentView = nil
        self.removeFromSuperview()
    }
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
        // 初始化
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
    }
 
}


extension PreparePlayerView {
    private func setUI() {
        // 设置圆角

        playerView.layer.cornerRadius = 15

        // 玩家
        playerImgView.layer.cornerRadius = 30
        playerNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        levelLabel.layer.cornerRadius = 7.5
        levelLabel.layer.masksToBounds = true
        IDLabel.layer.cornerRadius = 7.5
        IDLabel.layer.masksToBounds = true
        applyBtn.isHidden  = true
        applyBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
    }
    
    private func checkUser() {
        let user_id = itemModel?.userId
        if user_id != nil {
            userFindRequest(user_id: user_id!) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
                    let data = resultDic["data"] as! [String : AnyObject]
                    let resultData = data["result"] as! [String : AnyObject]
                    let userFindModel = UserFindModel(fromDictionary: resultData)
                    // 是否是朋友 1是 0否
                    if (userFindModel.userId == UserAccountViewModel.shareInstance.account?.userId) || (userFindModel.isFriend != nil &&  userFindModel.isFriend == 1) {
                        self?.applyBtn.isHidden = true
                    } else {
                        self?.applyBtn.isHidden = false
                        
                        if userFindModel.isApply == 1 { // 已申请
                            self!.applyBtn.gradientClearLayerColor(cornerRadius: 22)
                            self!.applyBtn.backgroundColor = HexColor("#CACACA")
                            self!.applyBtn.layer.cornerRadius = 22
                            self!.applyBtn.setTitleColor(UIColor.white, for: .normal)
                            self!.applyBtn.setTitle("友達申し込みは発送しました", for: .normal)
                            self!.applyBtn.isUserInteractionEnabled = false
                        }
                    }
                }
            }
        }
    }
}


extension PreparePlayerView {
    // 添加好友
    private func addFriend() {
        let receive_id = itemModel?.userId
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
}

extension PreparePlayerView {
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

