//
//  SendMessageViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import AgoraRtmKit
import MJRefresh

enum ChatType {
    case peer(String), group(String)
    
    var description: String {
        switch self {
        case .peer:  return "peer"
        case .group: return "channel"
        }
    }
}

private let MessageTextCellId = "MessageTextCellId"

private let MessageScriptCellId = "MessageScriptCellId"

private let MessageScriptInviteCellId = "MessageScriptInviteCell"

class SendMessageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
//    @IBOutlet weak var tableview: UITableView!
    
    private lazy var tableView: UITableView = UITableView()

    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    // 
    private var rightBtn: UIButton = UIButton()
    
    private var page_no = 1
    
    private var page_size = 15
    
    lazy var list = [Message]()
    
    var msgList: [MsgTalkModel]?  = [MsgTalkModel]()
    
    var isFirst : Bool = true
    
    
    var currentMgsTalkModel: MsgTalkModel? = MsgTalkModel(fromDictionary: [:])
    
    var type: ChatType?

    var messageListModel: MessageListModel? {
        didSet {
            if messageListModel != nil {
                let userId = messageListModel?.userId
                type = .peer("\(userId!)")
            }
        }
    }
    
    // 当前是否在最底部
    var currentInsInBottom = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        AgoraRtm.updateKit(delegate: self)
        
        setUI()
        
        getMsgList()
        
//        getHistoryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFriend), name: NSNotification.Name(rawValue: Delete_Friend_Notif), object: nil)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        updateIsReadRequest(receive_id: messageListModel!.userId!) { (result, error) in
            
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if String(describing: touch.view?.classForCoder) == "UITableViewCellContentView" {
            return false
        }
            return true
        }
    }

//MARK:- notifi
extension SendMessageViewController {
    @objc func deleteFriend() {
        navigationController?.popViewController(animated: true)
    }
}

extension SendMessageViewController {
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadMore))
        header?.backgroundColor = UIColor.white
//        header?.setTitle("上拉加载", for: .idle)
//        header?.setTitle("释放更新", for: .pulling)
//        header?.setTitle("加载中...", for: .refreshing)
        
        header?.lastUpdatedTimeLabel.isHidden = true  // 隐藏时间
        header?.stateLabel.isHidden = true // 隐藏文字
        header?.isAutomaticallyChangeAlpha = true //自动更改透明度
        
//        // 设置tableview的header
//        tableView.mj_header = header
//
//        // 进入刷新状态
//        tableView.mj_header.beginRefreshing()
    }
    
    @objc private func loadMore() {
//        page_no += 1
//        getMsgList()
    }
    
    private func getMsgList() {
        msgTalkListRequest(receive_id: messageListModel!.userId!, page_no: page_no, page_size: page_size) {[weak self] (result, error) in
            
            if error != nil {
//                self?.tableView.mj_header.endRefreshing()
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let listData = data["list"] as! Array<Any>
                
                if !listData.isEmpty {
                    
                    
                    for item in listData {
                        let dic = item as! [String : AnyObject]
                        let json = dic["content"]
                        let jsonDic = getDictionaryFromJSONString(jsonString: json! as! String)
                        let model = MsgTalkModel(fromDictionary: jsonDic as! [String : Any])
                        self?.msgList?.append(model)
                    }
                    
                    self?.tableView.reloadData()
                                        
                    let indexPath = IndexPath(row: ((self?.msgList!.count)!)-1, section: 0)
                    
                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
                
//                self?.tableView.mj_header.endRefreshing()

            }
        }
    }
    
    func scrollBottom() {
        if msgList!.count > 0 {
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: (msgList!.count)-1, section: 0), at: .bottom, animated: true)
        }
    }
}




extension SendMessageViewController {
    
    private func setUI() {
        setNavigationBar()
        
        inputTextField.delegate = self
        inputTextField.returnKeyType = .send
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.register(UINib(nibName: "MessageTextCell", bundle: nil), forCellReuseIdentifier: MessageTextCellId)
        
        tableView.register(UINib(nibName: "MessageScriptCell", bundle: nil), forCellReuseIdentifier: MessageScriptCellId)
        
        tableView.register(UINib(nibName: "MessageScriptInviteCell", bundle: nil), forCellReuseIdentifier: MessageScriptInviteCellId)
        
        setupHeaderView()
        
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none
        tableView.backgroundColor = HexColor("F5F5F5")
//        tableView.backgroundColor = UIColor.red
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(NAVIGATION_BAR_HEIGHT)
            make.left.equalTo(0)
            make.width.equalTo(FULL_SCREEN_WIDTH)
            make.bottom.equalTo(bottomView.snp_top)
        }

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        Log(tableView.frame)
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        tableView.keyboardDismissMode = .interactive
    }
    
    
    private func setNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        rightBtn.setImage(UIImage(named: "send_message_r_icon"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = messageListModel?.nickname
        
        navigationItem.titleView = titleLabel
    }
}

extension SendMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//
//        let size = self?.getSizeWithContent(content: content!)
//        msgModel.cellHeight = size?.height
        
        let msg = msgList![indexPath.row]
        let cellType : CellType = String(msg.sendId!) == AgoraRtm.current ? .right : .left
        msg.cellType = cellType
        msg.head = messageListModel?.head
        
        if indexPath.row == 0 {
            msg.showTime = true
        } else {
            let preMsg = msgList![indexPath.row - 1]
            let timeMs = Double(msg.timeMs!)
            let preTimeMs = Double(preMsg.timeMs!)
            let timeInterval = timeMs! - preTimeMs!
            
            if timeInterval >= 3600 * 1000 { //超过一小时 显示时间
                msg.showTime = true
            } else {
                msg.showTime = false
            }
        }
        
        

        // "type":1, //1文字 2 剧本详情 3 剧本邀请
        let type = msg.type
        if type == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextCellId, for: indexPath) as! MessageTextCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            let size = getSizeWithContent(content: msg.content!)
            msg.cellHeight = size.height
            cell.messageTalkModel = msg
            
            return cell
        } else if type == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageScriptCellId, for: indexPath) as! MessageScriptCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            msg.cellHeight = 120.0
            cell.messageTalkModel = msg
            
            cell.leftViewScriptBlock = {[weak self] () in
                Log(msg)
                self?.didselectCell(msg: msg)
            }

            cell.rightViewScriptBlock = {[weak self] () in
                Log(msg)
                self?.didselectCell(msg: msg)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MessageScriptInviteCellId, for: indexPath) as! MessageScriptInviteCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            msg.cellHeight = 145.0
            cell.messageTalkModel = msg
            cell.leftViewScriptInviteBlock = {[weak self] () in
                Log(msg)
                self?.didselectCell(msg: msg)
            }

            cell.rightViewScriptInviteBlock = {[weak self] () in
                Log(msg)
                self?.didselectCell(msg: msg)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let msg = msgList![indexPath.row]
//        let cellType : CellType = String(msg.sendId!) == AgoraRtm.current ? .right : .left
//        msg.cellType = cellType
//        msg.head = messageListModel?.head
//
//        // "type":1, //1文字 2 剧本详情 3 剧本邀请
//        let type = msg.type
//        if type == 1 {
//
//        } else if type == 2 {
//            let vc = ScriptDetailsViewController()
//            vc.script_id = msg.scriptId
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            joinRoom(room_id: msg.roomId!, room_password: nil, script_id: msg.scriptId!, hasPassword: false)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        let msg = msgList?[indexPath.row]
        
        let type = msg?.type
        if type == 1 {
            if msg?.content != nil {
                let size = self.getSizeWithContent(content: msg!.content!)
                msg?.cellHeight = size.height
            } else {
                msg?.cellHeight = 90
            }
            
        } else if type == 2 {
            msg?.cellHeight = 120.0
        } else {
            msg?.cellHeight = 145.0
        }
        return msg!.cellHeight ?? 90
    }
    
    private func didselectCell(msg: MsgTalkModel) {
        let cellType : CellType = String(msg.sendId!) == AgoraRtm.current ? .right : .left
        msg.cellType = cellType
        msg.head = messageListModel?.head
        
        // "type":1, //1文字 2 剧本详情 3 剧本邀请
        let type = msg.type
        if type == 1 {
            
        } else if type == 2 {
            let vc = ScriptDetailsViewController()
            vc.script_id = msg.scriptId
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            joinRoom(room_id: msg.roomId!, room_password: nil, script_id: msg.scriptId!, hasPassword: false)
        }
    }
    
    
}


extension SendMessageViewController {
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - 右侧按钮
    @objc func rightBtnAction() {
        inputTextField.resignFirstResponder()
        let commonView = LookFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.delegate = self
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.itemModel  = messageListModel
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
    func joinRoom(room_id: Int, room_password: String?, script_id: Int, hasPassword: Bool) {
            joinRoomRequest(room_id: room_id, room_password: room_password, hasPassword: hasPassword) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    let vc = PrepareRoomViewController()
                    vc.room_id = room_id
                    vc.script_id = script_id
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    showToastCenter(msg: "暗証番号が正しくありません")
                }
            }
        }
}

extension SendMessageViewController: LookFriendsViewDelegate {
    func editBtnActionFunc() {
        let commonView = EidtFirendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.receive_id = messageListModel?.userId
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
    func DeleteFriends() {
        navigationController?.popViewController(animated: true)
    }
 
}

extension SendMessageViewController: EidtFirendsViewDelegate {
    func deleteFriends() {
        navigationController?.popViewController(animated: true)
    }
    
    func blackFriends() {
        navigationController?.popViewController(animated: true)
    }
    
    func reportFriends() {
        let vc = FriendReportViewController()
        vc.receive_id = messageListModel?.userId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension SendMessageViewController: UITextFieldDelegate {

    func ifLoadOfflineMessages() {
        switch type {
        case .peer(let name):
            guard let messages = AgoraRtm.getOfflineMessages(from: name) else {
                return
            }
            
            for item in messages {
                if(item.type == .text){
                    appendMessage(user: name, content: item.text, mediaId: nil, thumbnail: nil)
                } else if(item.type == .image){
                    if let imageMessage = item as? AgoraRtmImageMessage {
                        appendMessage(user: name, content: nil, mediaId: imageMessage.mediaId, thumbnail: imageMessage.thumbnail)
                    }
                }
            }
            
            AgoraRtm.removeOfflineMessages(from: name)
        default:
            break
        }
    }
    
    func pressedReturnToSendText(_ text: String?) -> Bool {
        guard let text = text, text.count > 0 else {
            return false
        }
        send(message: text, type: type!)
        return true
    }
    
    func appendMessage(user: String, content: String?, mediaId: String?, thumbnail: Data?) {
        DispatchQueue.main.async { [weak self] in

//            let size = self?.getSizeWithContent(content: content!)
//
//            self?.currentMgsTalkModel = MsgTalkModel(fromDictionary: [:])
//            self?.currentMgsTalkModel?.content = content
//            self?.currentMgsTalkModel?.cellHeight = size?.height
//            self?.currentMgsTalkModel?.sendId = UserAccountViewModel.shareInstance.account?.userId
//            self?.currentMgsTalkModel?.type = 1
//            self?.currentMgsTalkModel?.timeMs = getTime()
//            self?.currentMgsTalkModel?.targetId = self?.messageListModel?.userId
//            self?.currentMgsTalkModel = nil

            
            
            let contentDic = getDictionaryFromJSONString(jsonString: content!)
            let msgModel = MsgTalkModel(fromDictionary: contentDic as! [String : Any])
            
            let type = msgModel.type
            if type == 1 {
                let size = self?.getSizeWithContent(content: msgModel.content!)
                msgModel.cellHeight = size?.height
            } else if type == 2 {
                msgModel.cellHeight = 120.0
            } else {
                msgModel.cellHeight = 145.0
            }
            
            self!.msgList!.append(msgModel)

            self!.tableView.reloadData()
            let end = IndexPath(row: self!.msgList!.count - 1, section: 0)
            self!.tableView.scrollToRow(at: end, at: .bottom, animated: true)
        }
    }
    
    // 获取文字的长度和宽度
    private func getSizeWithContent(content: String) -> CGSize {
        var width = labelWidth(text: content, height: 15, fontSize: 15)
        var height: CGFloat = 95
        if width >= FULL_SCREEN_WIDTH - 170 {
            width = FULL_SCREEN_WIDTH - 170
//            height = content.ga_heightForComment(fontSize: 15, width: width)
            let font = UIFont.systemFont(ofSize: 15)
            height = stringSingleHeightWithWidth(text: content, width: width, font: font)
            height += 80
        }
        
        return CGSize(width: width, height: height)
    }
    
    @objc func keyboardWillChangeFrame(notif: Notification) {
        // 获取动画执行的时间
        let duration = notif.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 获取键盘最终Y值
        let endFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 计算工具栏距离底部的间距
        var margin = FULL_SCREEN_HEIGHT - y - HOME_INDICATOR_HEIGHT
        
        if margin < 0 {
            margin = 0
        }
        bottomConstraint.constant = margin
//        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height -  _heighh +20  );
        if margin > 0 {
            tableView.contentOffset = CGPoint(x: 0, y: tableView.contentSize.height - margin)
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pressedReturnToSendText(textField.text) {
            textField.text = nil
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tableView.isScrollEnabled = true
//        tableView.scrollToRow(at: IndexPath(row: (msgList!.count)-1, section: 0), at: .bottom, animated: false)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        inputTextField.resignFirstResponder()
    }
    
  
}

// MARK: Send Message
private extension SendMessageViewController {
    
    func send(rtmMessage: AgoraRtmMessage, type: ChatType, name: String, option: AgoraRtmSendMessageOptions) {
        
        let content = msgContent(text: rtmMessage.text)
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
            
            if(rtmMessage.type == .text){
                self.appendMessage(user: current, content: content, mediaId: nil, thumbnail: nil)
            } else if(rtmMessage.type == .image){
                if let imageMessage = rtmMessage as? AgoraRtmImageMessage {
                    self.appendMessage(user: current, content: nil, mediaId: imageMessage.mediaId, thumbnail: imageMessage.thumbnail)
                }
            }
            self.addMgs(text: content)
        }
        
        AgoraRtm.kit?.send(rtmMessage, toPeer: String(name), sendMessageOptions: option, completion: { (error) in
           sent(error.rawValue)
        })
    }
    
    func send(message: String, type: ChatType) {
        
        switch type {
        case .peer(let name):
            let option = AgoraRtmSendMessageOptions()
            
            
            AgoraRtm.kit?.queryPeersOnlineStatus([name], completion: {[weak self] (peerOnlineStatus, peersOnlineErrorCode) in
                guard peersOnlineErrorCode == .ok else {
//                    showToastCenter(msg: "send-AgoraRtm login error: \(peersOnlineErrorCode.rawValue)")

                    
                    UIApplication.shared.keyWindow?.rootViewController =  BaseNavigationViewController(rootViewController: LoginViewController())
                    userLogout()
                    AgoraRtmLogout()
                    return
                }
                Log(peerOnlineStatus)
                
                option.enableHistoricalMessaging = true
                option.enableOfflineMessaging = true
                
                let rtmMessage = AgoraRtmMessage(text: message)
                self!.send(rtmMessage: rtmMessage, type: type, name: name, option: option)
                
            })
        case .group(_):
            break
        }
    }
}

// MARK: AgoraRtmDelegate
extension SendMessageViewController: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        
//        showAlert("connection state changed: \(state.rawValue)") { [weak self] (_) in
//            if reason == .remoteLogin, let strongSelf = self {
//                strongSelf.navigationController?.popToRootViewController(animated: true)
//            }
//        }
        
        
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        Log(Int(peerId))
        Log(messageListModel?.userId!)
        Log(message.text)
        if Int(peerId) == messageListModel?.userId! {
            appendMessage(user: peerId, content: message.text, mediaId: nil, thumbnail: nil)
        } else {
           Log("不是你")
        }
    }
    
    func rtmKit(_ kit: AgoraRtmKit, imageMessageReceived message: AgoraRtmImageMessage, fromPeer peerId: String) {
        appendMessage(user: peerId, content: nil, mediaId: message.mediaId, thumbnail: message.thumbnail)
    }
    
    

    
    private func msgContent(text: String) -> String {
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
        
        dic["type"] = 1
        dic["content"] = text
        dic["send_id"] = UserAccountViewModel.shareInstance.account?.userId
        dic["target_id"] = messageListModel!.userId
        dic["time_ms"] = time
            
        dic["script_id"] = nil
        dic["script_name"] = nil
        dic["script_cover"] = nil
        dic["script_des"] = nil
        dic["room_id"] = nil
        
        let json = getJSONStringFromDictionary(dictionary: dic as NSDictionary)
        return json
    }
    
    private func addMgs(text: String) {
//        // 添加消息
//        let json = msgContent(text: text)
        
        addMsgRequest(type: 0, receive_id: messageListModel!.userId!, content: text) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                Log(resultDic["msg"])
            }
        }
    }

    
    @objc func tapAction() {
        inputTextField.resignFirstResponder()
    }
    
    
}




