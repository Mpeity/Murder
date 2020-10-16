//
//  PlayerView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    var itemModel: GPScriptRoleListModel? {
        didSet {
            
            if (itemModel != nil) {
                if (itemModel?.head != nil) {
                    let roleHead = itemModel?.head!
                    roleImgView.setImageWith(URL(string: roleHead!))
                }
                
                if (itemModel?.scriptRoleName != nil) {
                    roleNameLabel.text = itemModel?.scriptRoleName!
                }
                
                if itemModel?.describe != nil {
                    roleIntroduceLabel.text = itemModel?.describe
                }
                
                if itemModel?.user?.head != nil {
                    let head = itemModel?.user?.head!
                    playerImgView.setImageWith(URL(string: head!))
                }
                
                if itemModel?.user?.nickname != nil {
                    playerNameLabel.text = itemModel?.user?.nickname!
                }
                
                var image : UIImage!
                if itemModel?.user?.sex == 1 {
                    image = UIImage(named: "sex_man")
                } else if itemModel?.user?.sex == 2 {
                    image = UIImage(named: "sex_woman")
                } else {
                    
                }
                sexImgView.image = image

                if itemModel?.user?.level != nil {
                    levelLabel.text = itemModel?.user?.level
                }
                
                if itemModel?.user?.userId != nil {
                    let id = itemModel?.user?.userId!
                    IDLabel.text = "ID:\(String(id!))"
                }
                checkUser()

            }
        }
    }
    
    
    @IBOutlet var contentView: UIView!
    
    // 角色按钮
    @IBOutlet weak var roleBtn: UIButton!
    // 玩家
    @IBOutlet weak var playerBtn: UIButton!
    // 滑动小滑块
    @IBOutlet weak var lineView: UIView!
    
    // 角色
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var roleImgView: UIImageView!
    // 角色姓名
    @IBOutlet weak var roleNameLabel: UILabel!
    // 任务介绍
    @IBOutlet weak var roleIntroduceLabel: UILabel!
    
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
    
    @IBAction func roleBtnAction(_ sender: Any) {
        self.roleBtn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
        self.playerBtn.setTitleColor(HexColor(LightGrayColor), for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.playerView.isHidden = true
            self.roleView.isHidden = false
            self.lineView.center.x = self.roleBtn.center.x
        }
    }
    
    @IBAction func playerBtnAction(_ sender: Any) {
        self.playerBtn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
        self.roleBtn.setTitleColor(HexColor(LightGrayColor), for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.roleView.isHidden = true
            self.playerView.isHidden = false

            self.lineView.center.x = self.playerBtn.center.x
        }
        
    }
    
    
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
        
        playerView.isHidden = true
        roleView.isHidden = false
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


extension PlayerView {
    private func setUI() {
        // 设置圆角
        playerBtn.corner(byRoundingCorners: .topRight, radii: 15)
        roleBtn.corner(byRoundingCorners: .topLeft, radii: 15)

        roleView.layer.cornerRadius = 15
        playerView.layer.cornerRadius = 15
        
        lineView.layer.cornerRadius = 1.5
        
        // 角色
        roleNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        roleImgView.layer.cornerRadius = 30
        // 玩家
        playerImgView.layer.cornerRadius = 30
        playerNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        levelLabel.layer.cornerRadius = 7.5
        levelLabel.layer.masksToBounds = true
        IDLabel.layer.cornerRadius = 7.5
        IDLabel.layer.masksToBounds = true

        applyBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        
        roleBtn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
        playerBtn.setTitleColor(HexColor(LightGrayColor), for: .normal)
    }
    
    private func checkUser() {
        let user_id = itemModel?.user.userId
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


extension PlayerView {
    
//     private func addMgs() {
        
    //        // 添加消息
    //        {
    //        "type":1, //1文字 2 剧本详情 3 剧本邀请
    //        "content":"内容",
    //        "script_id":1,
    //        "script_name":"剧本名字",
    //        "script_cover":"剧本封面",
    //        "script_des":"剧本简介",
    //        "room_id":"房间id",
    //        "send_id":"发送者id",
    //        "target_id":"接受者id",
    //        "time_ms":"1587009745719"//13位时间戳
    //        }
            
            
//        let time = getTime()
//        var dic = [:] as [String : Any?]
//        dic["content"] = nil
//        dic["target_id"] = itemModel?.user.userId
//        dic["send_id"] = UserAccountViewModel.shareInstance.account?.userId
//        dic["time_ms"] = time
//
//        var type = -1
//        if isShareScript { // 剧本分享
//            dic["type"] = 2
//            dic["script_id"] = shareModel?.scriptId
//            dic["script_name"] = shareModel?.name
//            dic["script_cover"] = shareModel?.cover
//            dic["script_des"] = shareModel?.introduction
//            dic["room_id"] = nil
//            type = 2
//        } else { // 剧本邀请
//            type = 1
//            dic["type"] = 3
//            dic["script_id"] = shareModel?.scriptId
//            dic["script_name"] = shareModel?.name
//            dic["script_cover"] = shareModel?.cover
//            dic["script_des"] = shareModel?.introduction
//            dic["room_id"] = shareModel?.roomId
//        }
//
//        let json = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
//        // 消息类型【0text1剧本邀请2剧本3好友申请】
//        addMsgRequest(type: type, receive_id: (friendsModel?.userId)!, content: json) {[weak self] (result, error) in
//            if error != nil {
//                return
//            }
//            // 取到结果
//            guard  let resultDic :[String : AnyObject] = result else { return }
//            if resultDic["code"]!.isEqual(1) {
//                Log(resultDic["msg"])
//            }
//            showToastCenter(msg: resultDic["msg"] as! String)
//            let nav = self?.findNavController()
//            nav?.popViewController(animated: true)
//        }
//    }
    
    // 添加好友
    private func addFriend() {
        let receive_id = itemModel?.user.userId
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

extension PlayerView {
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

