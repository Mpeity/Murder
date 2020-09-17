//
//  ShareScriptCard.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/31.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

import AgoraRtmKit


class ShareScriptCard: UIView, AgoraRtmDelegate {
    
    var isShareScript: Bool = true
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var commonLabel: UILabel!
    // 性别
    @IBOutlet weak var sexImgView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    // 内容
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    
    // 名字顶部约束
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    // id
    @IBOutlet weak var idLabel: UILabel!
    
    
    
    
    // 送信
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    var friendsModel: FriendListModel? {
        didSet {
            
        }
    }

    
    var shareModel: ScriptDetailModel?{
        didSet {
            if shareModel != nil {
                if shareModel?.cover != nil {
                    let cover = shareModel?.cover
                    coverImgView.setImageWith(URL(string: cover!))
                }
                
                if shareModel?.name != nil {
                    nameLabel.text = shareModel?.name!
                }
                

                if isShareScript {
                    // 剧本详情
                    nameTopConstraint.constant = 21.5
                    idLabel.isHidden = true
                    layoutIfNeeded()
                } else {
                    // 剧本邀请
                    nameTopConstraint.constant = 10
                    idLabel.isHidden = false
                    layoutIfNeeded()
                    // 剧本邀请
                    idLabel.isHidden = false
                    if shareModel?.roomId != nil {
                        let roomId = shareModel!.roomId!
                        idLabel.text = "ID:\(roomId)"
                    }
                }
                
                commonLabel.text = UserAccountViewModel.shareInstance.account?.nickname
            }
        }
    }
    
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        AgoraRtm.updateKit(delegate: self)
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: - setUI
extension ShareScriptCard {
    
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        
        coverImgView.layer.cornerRadius = 5
        coverImgView.layer.masksToBounds = true
        
        
        cancelBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        sendBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        sendBtn.setTitle("送る", for: .normal)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        sendBtn.addTarget(self, action: #selector(sendBtnAction), for: .touchUpInside)
        
        commonLabel.textColor = HexColor(DarkGrayColor)
        commonLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        tipLabel.textColor = HexColor(LightGrayColor)
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        
        nameLabel.textColor = HexColor(DarkGrayColor)
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        idLabel.textColor = HexColor(LightGrayColor)
        idLabel.font = UIFont.systemFont(ofSize: 12)
        
        if isShareScript {
            // 剧本详情
            nameTopConstraint.constant = 21.5
            idLabel.isHidden = true
            layoutIfNeeded()
        } else {
            // 剧本邀请
            nameTopConstraint.constant = 10
            idLabel.isHidden = false
            layoutIfNeeded()
        }
        
    }
    

}

extension ShareScriptCard {
    // 发送
    @objc private func sendBtnAction() {
        send(message: nil, type: .peer("\(friendsModel!.userId!)"))
        addMgs()
    }
    
    
    // 取消
    @objc private func hideView() {
        contentView = nil
        self.removeFromSuperview()
    }
    
    private func msgContent() -> String {
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
        
        
        let time = getTime()
        var dic = [:] as [String : Any?]
        dic["content"] = nil
        dic["target_id"] = friendsModel?.userId
        dic["send_id"] = UserAccountViewModel.shareInstance.account?.userId
        dic["time_ms"] = time
        
        if isShareScript { // 剧本分享
            dic["type"] = 2
            dic["script_id"] = shareModel?.scriptId
            dic["script_name"] = shareModel?.name
            dic["script_cover"] = shareModel?.cover
            dic["script_des"] = shareModel?.introduction
            dic["room_id"] = nil
        } else { // 剧本邀请
            dic["type"] = 3
            dic["script_id"] = shareModel?.scriptId
            dic["script_name"] = shareModel?.name
            dic["script_cover"] = shareModel?.cover
            dic["script_des"] = shareModel?.introduction
            dic["room_id"] = shareModel?.roomId
        }
        
        let json = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
        return json
    }
    
    
    private func addMgs() {
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
        
        
        let time = getTime()
        var dic = [:] as [String : Any?]
        dic["content"] = nil
        dic["target_id"] = friendsModel?.userId
        dic["send_id"] = UserAccountViewModel.shareInstance.account?.userId
        dic["time_ms"] = time
        var type = -1
        if isShareScript { // 剧本分享
            dic["type"] = 2
            dic["script_id"] = shareModel?.scriptId
            dic["script_name"] = shareModel?.name
            dic["script_cover"] = shareModel?.cover
            dic["script_des"] = shareModel?.introduction
            dic["room_id"] = nil
            type = 2
        } else { // 剧本邀请
            type = 1
            dic["type"] = 3
            dic["script_id"] = shareModel?.scriptId
            dic["script_name"] = shareModel?.name
            dic["script_cover"] = shareModel?.cover
            dic["script_des"] = shareModel?.introduction
            dic["script_des"] = shareModel?.introduction
            dic["room_id"] = shareModel?.roomId
        }
        
        let json = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
        // 消息类型【0text1剧本邀请2剧本3好友申请】
        addMsgRequest(type: type, receive_id: (friendsModel?.userId)!, content: json) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                Log(resultDic["msg"])
            }
            showToastCenter(msg: resultDic["msg"] as! String)
            let nav = self?.findNavController()
            nav?.popViewController(animated: true)
        }
    }
    //查找视图对象的响应者链条中的导航视图控制器
    private func findNavController() -> UINavigationController? {
        
        //遍历响应者链条
        var next = self.next
        //开始遍历
        while next != nil {
           //判断next 是否是导航视图控制器
           if let nextobj = next as? UINavigationController {
               return nextobj
           }
           //如果不是导航视图控制器 就继续获取下一个响应者的下一个响应者
           next = next?.next
        }
       return nil
    }
}


// MARK: Send Message
private extension ShareScriptCard {
    
    func send(rtmMessage: AgoraRtmMessage, type: ChatType, name: String, option: AgoraRtmSendMessageOptions) {
        
        let content = msgContent()
        rtmMessage.text = content
        
        let sent = { [weak self] (state: Int) in
            guard let `self` = self else {
                return
            }
            
            guard (state == 0 || state == 4) else {
                showToastCenter(msg: "send \(type.description) message error: \(state)")
                Log("send \(type.description) message error: \(state)")
                return
            }
            
            guard let current = AgoraRtm.current else {
                return
            }
            
//            if(rtmMessage.type == .text){
//                self.appendMessage(user: current, content: content, mediaId: nil, thumbnail: nil)
//            } else if(rtmMessage.type == .image){
//                if let imageMessage = rtmMessage as? AgoraRtmImageMessage {
//                    self.appendMessage(user: current, content: nil, mediaId: imageMessage.mediaId, thumbnail: imageMessage.thumbnail)
//                }
//            }
            
        }
        
        AgoraRtm.kit?.send(rtmMessage, toPeer: String(name), sendMessageOptions: option, completion: { (error) in
           sent(error.rawValue)
        })
    }
    
    func send(message: String?, type: ChatType) {
        
        switch type {
        case .peer(let name):
            let option = AgoraRtmSendMessageOptions()
            
            
            AgoraRtm.kit?.queryPeersOnlineStatus([name], completion: {[weak self] (peerOnlineStatus, peersOnlineErrorCode) in
                guard peersOnlineErrorCode == .ok else {
                    showToastCenter(msg: "send-AgoraRtm login error: \(peersOnlineErrorCode.rawValue)")
                    return
                }
                Log(peerOnlineStatus)
                
                option.enableHistoricalMessaging = true
                option.enableOfflineMessaging = true
                
                let rtmMessage = AgoraRtmMessage(text: "type")
                self!.send(rtmMessage: rtmMessage, type: type, name: name, option: option)
                
            })
        case .group(_):
            break
        }
    }
}



extension ShareScriptCard {
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

