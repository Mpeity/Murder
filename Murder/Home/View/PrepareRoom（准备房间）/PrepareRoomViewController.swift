//
//  PrepareRoomViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Starscream
import SVProgressHUD

let PrepareRoomCellId = "PrepareRoomCellId"


class PrepareRoomViewController: UIViewController, UITextFieldDelegate {

    var script_id: Int!{
        didSet {
            Log("PrepareRoomViewController---\(script_id)")
        }
    }
    
    var room_id: Int!
    
    // client_id
    private var current_client_id: String!
    
    // 顶部视图
    private var headerBgView: UIView = UIView()
    
    // 退出房间按钮
    private var exitBtn: UIButton = UIButton()
    // 游戏名称展示
    private var gameNameLabel: UILabel = UILabel()
    // 房间标签
    private var statusImgView:UIImageView = UIImageView()
    // 锁
    private var lockBtn: UIButton = UIButton()
    // 消息按钮
    private var messageBtn: UIButton = UIButton()
    // wifi信号
    private var wifiImgView: UIImageView = UIImageView()
    // 电量
    private var electricityView: UIView = UIView()
    
    // 当前房间号
    private var currentLabel: UILabel = UILabel()
    // 说明
    private var stateBtn: UIButton = UIButton()
    // 说明弹框配置
    private var preference:FEPreferences = FEPreferences()
    // 说明弹框
//    private var tipView: FETipView!
    
    private var popCommentView: UIView!
    
    private var popTipView: PopTipView!
    
    
    // AgoraRtcEngineKit 入口类
    private var agoraKit: AgoraRtcEngineKit!
    
    private var agoraStatus = AgoraStatus.sharedStatus()
    
    

    
    
    // 阶段说明
    private var stateTipView: UIView = UIView()
    private var stateTipLabel: UILabel = UILabel()
    
    // 选择角色
    private var choiceLabel: UILabel = UILabel()
    
    // 邀请按钮
    private var inviteBtn: UIButton = UIButton()
    
    
    
    
    private var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 600))
    
    // 底部视图
    private var bottomView: UIView = UIView()
    // 跑马灯
    private var marqueeView: MarqueeView = MarqueeView()
    // 准备按钮
    private var prepareBtn: GradienButton = GradienButton()
    // 声音按钮
    private var voiceBtn: UIButton = UIButton()
    
    // 设置密码弹框
    private lazy var textInputView : InputTextView! = {
        let commonView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.titleLabel.text = "暗証番号を設置"
        commonView.commonBtn.setTitle("確認", for: .normal)
        commonView.delegate = self
        commonView.textFieldView.delegate = self
        commonView.textFieldView.placeholder = ""
        commonView.textFieldView.keyboardType = .numberPad
        return commonView
    }()
    
    var isStatusBarHidden = false {
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    private var readyRoomModel: ReadyRoomModel?
    
    // 是否是房主
    var isOwner: Int!
    // 是否站起状态
    var isStandUp: Bool! = false
    // 状态【0加密必须传密码1解密不传密码】
    var lockStatus: Int = -1
    
    // 角色总数
    private var roleCount = 0
    // 玩家总数
    private var playerCount = 0
    // 跑马灯数据
    private var notifArr = [[String: AnyObject]]()
    // 剧本数据
    private var scriptSourceModel : ScriptSourceModel?
    
    
    private var progressArr = [AnyObject]()
    
    // 本地是否有图片数据
    private var loadAllImages: Bool = false
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        
        initAgoraKit()
        
        initWebSocketSingle()
        
        setUI()
        
        
//        DispatchQueue.main.async { [weak self] in
//            self?.loadData()
//        }
        
        self.loadData()

    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !SingletonSocket.sharedInstance.socket.isConnected {
            reConnectTime = 0
            socketReconnect()
        }
        
        navigationController?.navigationBar.isHidden = true
        
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self)
    }
    

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
       
}

//MARK: - 数据请求
extension PrepareRoomViewController {
    
    //MARK:- 检测本地是否有当前剧本数据
    func checkLocalScriptWith() {
        if (script_id != nil){
            scriptSourceRequest(script_id: script_id) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    let data = resultDic["data"] as! [String : AnyObject]
                    self?.scriptSourceModel = ScriptSourceModel(fromDictionary: data)
                    
                    if (UserDefaults.standard.value(forKey: String(self!.script_id)) != nil) {
                        
                        let localData = ScriptLocalData.shareInstance.getNormalDefult(key: String(self!.script_id))
                        let dic = localData as! Dictionary<String, AnyObject>
                        
                        let arr = self?.scriptSourceModel?.scriptNodeMapList!

                        for item in arr! {
                            if (!dic.keys.contains(item.attachmentId) || dic[item.attachmentId] == nil) {
                                // 下载当前图片
                                self!.loadAllImages = false
                                self?.scriptSourceModel = ScriptSourceModel(fromDictionary: data)
                                Thread.detachNewThreadSelector(#selector(self!.loadProgress), toTarget: self!, with: nil)
                                break
                            }
                            
                            Log("break")
                        }
                        DispatchQueue.main.async { [weak self] in
                            // 本地有剧本数据
                            self?.refreshUI()
                        }
                        
                    } else {
                        self?.scriptSourceModel = ScriptSourceModel(fromDictionary: data)
                        Thread.detachNewThreadSelector(#selector(self!.loadProgress), toTarget: self!, with: nil)
                    }
                }
            }
        }
    }

    
    //MARK:- 设置密码
    func setPassword(password: String?) {
        roomPasswordRequest(room_id: room_id, status: lockStatus, room_password: password) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                
            } else {
                
            }
        }
    }
    
    //MARK: - 选择角色/取消选择角色
    func choiceRole(script_role_id: Int) {
        choiceRoleRequest(room_id: room_id, script_role_id: script_role_id) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                
            } else {
                
            }
        }
    }
    
    //MARK: - 准备 / 取消准备
    func gameStart(status: Int) {
        gameStartRequest(room_id: room_id, status: status) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
//                let data = resultDic["data"] as! [String : AnyObject]
//                let resultData = data["is_ok"] as! [String : AnyObject]
                
            } else {
                
            }
        }
    }

    @objc func loadProgress() {
        let arr = self.scriptSourceModel?.scriptNodeMapList!
        
        // 任务1
        let arrCount = arr?.count
        let queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1

        for (index,viewModel) in arr!.enumerated() {
            let operation = BlockOperation { () -> Void in
                ImageDownloader.shareInstance.loadImageProgress(currentIndex: index, script: (self.scriptSourceModel?.script!)!, scriptNodeMapModel: viewModel) { (progress, response, error) in
                    

                    let new = progress
                    let scale = 1.0/Double(arrCount!)
                    let newIndex = Double(index)+1.0
                    var newProgress = new! * newIndex * scale * 100
                    
                    if response != nil {
                        self.progressArr.append(response as AnyObject)
                        if self.progressArr.count == arr?.count {
                            self.loadAllImages = true
                            newProgress = 1.0 * 100
                            DispatchQueue.main.async { [weak self] in
                                self?.refreshUI()
                            }
                        }
                    }


                    let s = String(format:"%.2f",newProgress)
                    let p = Float(s)!
                    print("当前进度:\(index):\(p)")

                    let progressData = ["type":"script_download" ,"scene": "1", "user_id": UserAccountViewModel.shareInstance.account?.userId! ?? 0, "group_id" : self.room_id!, "datas": p] as [String: AnyObject]
                    let progressStr = getJSONStringFromDictionary(dictionary: progressData as NSDictionary)
                    SingletonSocket.sharedInstance.socket.write(string: progressStr)

                }
            }

            queue.addOperation(operation)
        }
    }
    
    

    //MARK: -  准备游戏
    func loadData() {
        
        roomReadyRequest(room_id: room_id) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["result"] as! [String : AnyObject]
                
                self?.readyRoomModel = ReadyRoomModel(fromDictionary: resultData)
                if self?.readyRoomModel != nil {
                    DispatchQueue.main.async { [weak self] in
                        self?.loadDataRefreshUI()
                    }
                    
                    self?.checkLocalScriptWith()
                }
            } else {
                
            }
        }
    }
}


extension PrepareRoomViewController {
    
    private func loadDataRefreshUI() {
        tableView.reloadData()
        
        if readyRoomModel?.scriptName != nil {
            gameNameLabel.text = readyRoomModel?.scriptName
        } else {
           gameNameLabel.text = ""
        }
        
        if readyRoomModel?.isLock != nil {
            if readyRoomModel?.isLock! == 1 {
                lockBtn.setImage(UIImage(named: "createroom_locked"), for: .normal)

            } else {
                lockBtn.setImage(UIImage(named: "createroom_lock"), for: .normal)
            }
        }
        
        if readyRoomModel?.introduction != nil {
//            let message = readyRoomModel?.introduction
//            let height = message?.ga_heightForComment(fontSize: 12, width: 300*SCALE_SCREEN)
//            preference.drawing.message =  message!
//            preference.drawing.maxHeight = height!
            
            addPopTipView()

        }
        
        if readyRoomModel?.roomId != nil {
            currentLabel.text = "ルームID：\(readyRoomModel?.roomId! ?? 0)"
        }
        roleCount = readyRoomModel?.scriptRoleList?.count as! Int
        playerCount = readyRoomModel?.roomUserList?.count as! Int
        
        choiceLabel.text = "キャラクターを選択（\(playerCount)/\(roleCount)）"
        let userList = readyRoomModel?.roomUserList
        for itemModel in userList! {
            if (itemModel.userId == UserAccountViewModel.shareInstance.account?.userId) {
                if itemModel.status == 1 { // 准备
                    prepareBtn.setTitle("準備取り消し", for: . normal)
                    prepareBtn.gradientClearLayerColor(cornerRadius: 20)
                    prepareBtn.layer.borderColor = HexColor(MainColor).cgColor
                    prepareBtn.layer.cornerRadius = 20
                    prepareBtn.layer.borderWidth = 1
                    prepareBtn.setTitleColor(HexColor(MainColor), for: .normal)
                    prepareBtn.isSelected = true
                } else { // 取消准备
                    prepareBtn.setTitle("準備", for: .normal)
                    prepareBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 20)
                    prepareBtn.setTitleColor(UIColor.white, for: .normal)
                    prepareBtn.layer.borderWidth = 0
                    prepareBtn.isSelected = false
                }
            }
        }
    }
    
    private func refreshUI() {
        
        
        if readyRoomModel?.scriptName != nil {
            gameNameLabel.text = readyRoomModel?.scriptName
        } else {
           gameNameLabel.text = ""
        }
        
        addPopTipView()
        
        if readyRoomModel?.isLock != nil {
            if readyRoomModel?.isLock! == 1 {
                lockBtn.setImage(UIImage(named: "createroom_locked"), for: .normal)
            } else {
                lockBtn.setImage(UIImage(named: "createroom_lock"), for: .normal)
            }
        }
        
        if readyRoomModel?.introduction != nil {
            let message = readyRoomModel?.introduction
            preference.drawing.message =  message!
        }
        
        if readyRoomModel?.roomId != nil {
            currentLabel.text = "ルームID：\(readyRoomModel?.roomId! ?? 0)"
        }
        roleCount = readyRoomModel?.scriptRoleList!.count as! Int
        
//        playerCount = readyRoomModel?.roomUserList!.count as! Int
        var playerNum = 0
        for item in readyRoomModel!.roomUserList! {
            if item.scriptRoleId != 0 {
                playerNum += 1
            }
        }
        
        playerCount = playerNum
        
        choiceLabel.text = "キャラクターを選択（\(playerCount)/\(roleCount)）"
        let userList = readyRoomModel?.roomUserList
        for itemModel in userList! {
            if (itemModel.userId == UserAccountViewModel.shareInstance.account?.userId) {
                if itemModel.status == 1 { // 准备
                    prepareBtn.setTitle("準備取り消し", for: . normal)
                    prepareBtn.gradientClearLayerColor(cornerRadius: 20)
                    prepareBtn.layer.borderColor = HexColor(MainColor).cgColor
                    prepareBtn.layer.cornerRadius = 20
                    prepareBtn.layer.borderWidth = 1
                    prepareBtn.setTitleColor(HexColor(MainColor), for: .normal)
                    prepareBtn.isSelected = true
                } else { // 取消准备
                    prepareBtn.setTitle("準備", for: .normal)
                    prepareBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 20)
                    prepareBtn.setTitleColor(UIColor.white, for: .normal)
                    prepareBtn.layer.borderWidth = 0
                    prepareBtn.isSelected = false
                }
            }
        }
    
        // 房间准备完毕标识【1全部准备完毕0未全部准备完毕】
        let type = readyRoomModel?.readyOk!
        if type == 1 {
            let vc = GameplayViewController()
            vc.script_node_id = readyRoomModel!.firstScriptNodeId!
            vc.room_id = readyRoomModel?.roomId
            vc.script_id = script_id
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        // status【0正常1已开局2已结束3已解散】
        let status = readyRoomModel?.status!
        switch status {
        case 0:
            
            break
        case 1:
            
            break
        case 2:
            
            break
        case 3: // 解散
            userLogout()
            self.navigationController?.popToRootViewController(animated: true)
            break
        default:
            break
        }
        
        tableView.reloadData()

        
    }
    
    private func setUI() {
        self.view.backgroundColor = HexColor("#27025E")
        setHeaderView()
        

    }
    
    //MARK:- 说明
    private func addPopTipView() {
        
        
        
        let message = readyRoomModel?.introduction
        let size = getHeight(string: message!, width: FULL_SCREEN_WIDTH-40)
        var width = size.width
        var height = size.height
        height = height + 36
        if width <= FULL_SCREEN_WIDTH - 40 - 30 {
          
        } else {
           width = FULL_SCREEN_WIDTH - 40
        }
        
        if height >= FULL_SCREEN_HEIGHT - 150 {
            height = FULL_SCREEN_HEIGHT - 150
        }
      
        let leftSpace = FULL_SCREEN_WIDTH - width - 25
        
        if popCommentView == nil {
            popCommentView = UIView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            popCommentView.backgroundColor = UIColor.clear
            popCommentView.isUserInteractionEnabled = true
            self.view.addSubview(popCommentView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopTipView))
            popCommentView.addGestureRecognizer(tap)
        }
        popCommentView.isHidden = true

     
        if popTipView == nil {
            popTipView = PopTipView(frame: CGRect(x: leftSpace, y: stateBtn.frame.maxY+10, width: width, height: height))
            popTipView.backgroundColor = UIColor.clear
            popCommentView.addSubview(popTipView)
        }
        popTipView.content = readyRoomModel?.introduction!
    }
    

    // MARK: - 头部视图
    private func setHeaderView() {
        
        let bgView = UIView()
        self.view.addSubview(bgView)
        headerBgView = bgView
        bgView.layer.cornerRadius = 10
        bgView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(7)
            } else {
                make.top.equalToSuperview().offset(7)
            }
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(70)
        }
        bgView.backgroundColor = HexColor(hex: "#20014D", alpha: 0.8)
        bgView.isUserInteractionEnabled = true
        
        // 退出房间按钮
        bgView.addSubview(exitBtn)
        exitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(9)
            make.top.equalToSuperview().offset(9.5)
            make.size.equalTo(18)
        }
        exitBtn.setImage(UIImage(named: "gameplay_back"), for: .normal)
        exitBtn.addTarget(self, action: #selector(exitBtnAction(button:)), for: .touchUpInside)
        
        // 游戏名称展示
        bgView.addSubview(gameNameLabel)
        gameNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(exitBtn.snp.right).offset(7.5)
            make.top.equalToSuperview().offset(9.5)
            make.height.equalTo(18)
            make.width.equalTo(180)
        }
        gameNameLabel.text = "平凡な宿"
        gameNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        gameNameLabel.textColor = UIColor.white
        gameNameLabel.textAlignment = .left
        // 房间标签
        bgView.addSubview(statusImgView)
        statusImgView.image = UIImage(named: "status_one")
        statusImgView.snp.makeConstraints { (make) in
            make.left.equalTo(gameNameLabel.snp_right).offset(13.5)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(73)
            make.height.equalTo(13)
        }
        statusImgView.isHidden = true
        
        // 锁按钮
        bgView.addSubview(lockBtn)
        lockBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-99)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(12)
        }
        lockBtn.setImage(UIImage(named: "createroom_lock"), for: .normal)
        lockBtn.addTarget(self, action: #selector(lockBtnAction(button:)), for: .touchUpInside)
        
        
        let lineOneImgView = UIImageView()
        lineOneImgView.image = UIImage(named: "createroom_line")
        bgView.addSubview(lineOneImgView)
        lineOneImgView.snp.makeConstraints { (make) in
            make.left.equalTo(lockBtn.snp_right).offset(6)
            make.width.equalTo(0.5)
            make.height.equalTo(10)
            make.top.equalToSuperview().offset(11.5)
        }
    
        // 消息按钮
        bgView.addSubview(messageBtn)
        messageBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-73)
            make.top.equalToSuperview().offset(10.5)
            make.size.equalTo(12)
        }
        messageBtn.setImage(UIImage(named: "gameplay_message"), for: .normal)
        messageBtn.addTarget(self, action: #selector(messageBtnAction(button:)), for: .touchUpInside)
        
        let lineTwoImgView = UIImageView()
        lineTwoImgView.image = UIImage(named: "createroom_line")
        bgView.addSubview(lineTwoImgView)
        lineTwoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(messageBtn.snp_right).offset(6)
            make.width.equalTo(0.5)
            make.height.equalTo(10)
            make.top.equalToSuperview().offset(11.5)
        }
        
        // 信号显示
        bgView.addSubview(wifiImgView)
        wifiImgView.image = UIImage(named: "wifi_icon")
        wifiImgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-45)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(12.5)
            make.height.equalTo(9)
        }
        
//        currentNetworkType()
        AlamofiremonitorNet()
        // 电量
        bgView.addSubview(electricityView)
        electricityView.backgroundColor = HexColor("#20014D")
        electricityView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12.5)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(25)
            make.height.equalTo(10)
        }
        
        batterState(commonView: electricityView, x: 0, y: 0, width: 25, height: 10, cornerRadius: 0.5, lineWidth: 1, strokeColor: UIColor.white)
        
        // 当前房间号
        bgView.addSubview(currentLabel)
        currentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11.5)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(16)
            make.width.equalTo(100)
        }
        currentLabel.text = "ルームID：52845698"
        currentLabel.font = UIFont.systemFont(ofSize: 13.0)
        currentLabel.textColor = UIColor.white
        currentLabel.textAlignment = .left

        
        // 阶段说明
         bgView.addSubview(stateBtn)
         stateBtn.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(15)
//            make.width.equalTo(75)
         }
        stateBtn.isSelected = false
        stateBtn.setTitle("物語背景", for: .normal)
        stateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        stateBtn.backgroundColor = UIColor.clear
        stateBtn.addTarget(self, action: #selector(stateBtnAction(button:)), for: .touchUpInside)
        
        // 选择角色
        self.view.addSubview(choiceLabel)
        choiceLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(bgView.snp_bottom)
        }
        choiceLabel.textColor = UIColor.white
        choiceLabel.font = UIFont.systemFont(ofSize: 10)
        
        // 邀请按钮
        self.view.addSubview(inviteBtn)
        inviteBtn.setImage(UIImage(named: "createroom_invite"), for: .normal)
        inviteBtn.snp.makeConstraints { (make) in
            make.width.equalTo(66)
            make.height.equalTo(26)
            make.top.equalTo(bgView.snp_bottom).offset(12)
            make.right.equalToSuperview().offset(-15)
        }
        inviteBtn.addTarget(self, action: #selector(inviteBtnAction(button:)), for: .touchUpInside)
        
        // 底部视图
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.clear
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
            make.left.equalTo(0)
            make.width.equalTo(FULL_SCREEN_WIDTH)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview()
            }
        }
        
        // 跑马灯
        bottomView.addSubview(marqueeView)
        marqueeView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(70)
        }
        
        // 声音按钮
        bottomView.addSubview(voiceBtn)
        voiceBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-9)
        }
        voiceBtn.isSelected = true
        voiceBtn.setImage(UIImage(named: "createroom_voice"), for: .selected)
        voiceBtn.setImage(UIImage(named: "createroom_no_voice"), for: .normal)
        voiceBtn.addTarget(self, action: #selector(voiceBtnAction(button:)), for: .touchUpInside)
        
        // 准备按钮
        bottomView.addSubview(prepareBtn)
        prepareBtn.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(voiceBtn.snp_right).offset(20)
            make.right.equalToSuperview().offset(-15)
            
            make.bottom.equalToSuperview().offset(-14)
        }
        prepareBtn.layoutIfNeeded()
        prepareBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 20)
        prepareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        prepareBtn.setTitle("準備", for: .normal)
        prepareBtn.setTitleColor(UIColor.white, for: .normal)
        prepareBtn.addTarget(self, action: #selector(prepareBtnAction(button:)), for: .touchUpInside)
        
        
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PrepareRoomCell", bundle: nil), forCellReuseIdentifier: PrepareRoomCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 80
        tableView.backgroundColor = HexColor("#27025E")
        tableView.isScrollEnabled = true
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(choiceLabel.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp_top).offset(-15)
            make.centerX.equalToSuperview()
        }
        
    }
    

    
    
    
}


extension PrepareRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readyRoomModel?.scriptRoleList!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareRoomCell = tableView.dequeueReusableCell(withIdentifier: PrepareRoomCellId, for: indexPath) as! PrepareRoomCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = HexColor("#27025E")
        let scriptRoleModel = readyRoomModel?.scriptRoleList?[indexPath.row]
        cell.scriptRoleModel = scriptRoleModel
        cell.roomUserModel = nil
        // 匹配人物选择
        if (readyRoomModel?.roomUserList?.count ?? 0 > 0) {
            let arr: [RoomUserModel] = (readyRoomModel?.roomUserList)!
            for item in arr {
                let user_id = UserAccountViewModel.shareInstance.account?.userId
                if item.userId == user_id {
                    isOwner = item.isHomeowner
                }
                let roleId1 = item.scriptRoleId!
                let roleId2 = scriptRoleModel?.scriptRoleId!

                if roleId1 == roleId2 {
                    cell.scriptRoleModel?.hasPlayer = true
                    cell.roomUserModel = item
                }
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scriptRoleModel = readyRoomModel?.scriptRoleList?[indexPath.row]
        if scriptRoleModel?.hasPlayer ?? false { //已有玩家选择
            Log("已有玩家选择\(scriptRoleModel?.hasPlayer)")
        } else { // 可选择角色
            choiceRole(script_role_id: scriptRoleModel?.scriptRoleId! ?? 0)
            scriptRoleModel?.hasPlayer = true
            Log("可选择角色\(scriptRoleModel?.hasPlayer)")
        }
    }
    
    
      
}


extension PrepareRoomViewController {
    
    //MARK: 解散房间是 退出声网/断开socekt
    private func userLogout() {
        // 退出当前剧本，离开群聊频道
        agoraStatus.muteAllRemote = false
        agoraStatus.muteLocalAudio = false
        agoraKit.leaveChannel(nil)
        
        SingletonSocket.sharedInstance.socket.disconnect()
    }
    
    //MARK:- 退出房间按钮
    @objc func exitBtnAction(button: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        
        let commonView = OutOfRoomView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        if isOwner == 1 { // 房主
            commonView.standUpBtn.isHidden = true
        } else {
            commonView.standUpBtn.isHidden = false
        }
        self.view.addSubview(commonView)

        // 退出房间 确认按钮
        commonView.confirmBtnTapBlcok = {[weak self]() in
            // 退出当前剧本，离开群聊频道
            self?.agoraKit.leaveChannel(nil)
            self?.agoraStatus.muteAllRemote = false
            self?.agoraStatus.muteLocalAudio = false
            outRoomRequest(room_id: self!.room_id) { (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                }
                
            }
            commonView.removeFromSuperview()
//            self?.navigationController?.popViewController(animated: true)
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        // 站起
        commonView.standUpBtnTapBlcok = { [weak self] () in
            // 取消选择角色
            self?.isStandUp = true
            self?.choiceRole(script_role_id: 0)
            self?.prepareBtn.setTitle("準備", for: . normal)
            self?.prepareBtn.isSelected = false
            commonView.removeFromSuperview()
        }
    }
    
    //MARK: - 设置密码
    @objc func lockBtnAction(button: UIButton) {
        if isOwner == 1 { // 房主
            button.isUserInteractionEnabled = true
            if readyRoomModel?.isLock! == 1 {
                lockStatus = 1
                setPassword(password: nil)
                return
            } else {
                lockStatus = 0
            }
            textInputView.becomeFirstResponder()
            self.view.addSubview(textInputView)
            
        } else {
            button.isUserInteractionEnabled = false
        }
        
//        button.isUserInteractionEnabled = true
//        self.view.addSubview(textInputView)
//        textInputView.becomeFirstResponder()
    }
    
    
    //MARK:- 邀请按钮
    @objc func inviteBtnAction(button: UIButton) {
//        let commonView = PrepareRoomShareView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
//        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
//        self.view.addSubview(commonView)
        
        let commonView = ShareView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.delegate = self
        commonView.leftSpace = (FULL_SCREEN_WIDTH - 125 * 2) / 3.0
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.shareCopyBtn.isHidden = true
        UIApplication.shared.keyWindow?.addSubview(commonView)
        
        
    }
    
    //MARK:- 消息按钮
    @objc func messageBtnAction(button: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
        
        let vc = GotoMessageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
//         UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
//        let main = UIApplication.shared.keyWindow?.rootViewController as! MainViewController
//        main.selectedIndex = 2
    }
    
    //MARK:- 声音按钮
    @objc func voiceBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
        agoraKit.muteLocalAudioStream(!button.isSelected)
    }
    //MARK:-  准备/取消准备
    @objc func prepareBtnAction(button: UIButton) {
        // 站起状态或者未选择状态 提示先选择角色
        
        let uid = UserAccountViewModel.shareInstance.account?.userId!
        guard let index = getIndexWithUserIsSpeaking(uid: UInt(bitPattern: uid!)) else { return }
        let userList = readyRoomModel?.roomUserList
        let model = userList?[index]
        
//        if isStandUp != nil {
//            if isStandUp! == true {
//                showToastCenter(msg: "先にキャラクターを選択してください")
//                return
//            }
//        }
//
        if model!.scriptRoleId == 0 {
            showToastCenter(msg: "先にキャラクターを選択してください")
            return
        }

        button.isSelected = !button.isSelected
        var status = 0
        if button.isSelected { // 准备
            prepareBtn.setTitle("準備取り消し", for: . normal)
            prepareBtn.gradientClearLayerColor(cornerRadius: 20)
            prepareBtn.layer.borderColor = HexColor(MainColor).cgColor
            prepareBtn.layer.cornerRadius = 20
            prepareBtn.layer.borderWidth = 1
            prepareBtn.setTitleColor(HexColor(MainColor), for: .normal)
            status = 1
        } else { // 取消准备
            prepareBtn.setTitle("準備", for: .normal)
            prepareBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 20)
            prepareBtn.setTitleColor(UIColor.white, for: .normal)
            status = 0
        }
        
        // 更新 准备状态
        gameStart(status: status)
    }
    
    //MARK:- 说明
    @objc func stateBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
        popCommentView.isHidden = !popCommentView.isHidden
    }
    
    @objc func hidePopTipView() {
        popCommentView.isHidden = true
    }
}





// MARK: 更新UI
private extension PrepareRoomViewController {
    func updateViews() {
//        tableView.backgroundColor = UIColor.clear
//        for item in buttons {
//            item.imageView?.contentMode = .scaleAspectFit
//        }
    }
    
    func removeUser(uid: UInt) {
//        for (index, user) in readyRoomModel?.roomUserList!.enumerated() {
//            if user.uid == uid {
//                userList.remove(at: index)
//                break
//            }
//        }
    }
    
    func addUser(uid: UInt) {
//        let user = UserInfo.fakeUser(uid: uid)
//        userList.append(user)
        
        
    }
    
    func updateUser(uid: UInt, isMute: Bool) {
//        for (index, user) in userList.enumerated() {
//            if user.uid == uid {
//                userList[index].isMute = isMute
//                break
//            }
//        }
    }
    
    func getIndexWithUserIsSpeaking(uid: UInt) -> Int? {
        let userList = readyRoomModel?.roomUserList
        if userList != nil {
            for (index, user) in userList!.enumerated() {
                let userId = user.userId!
                if UInt(bitPattern: userId) == uid {
                    return index
                }
            }
            return nil
        }
        return nil
    }
    
    func getIndexWithUser(uid: Int) -> Int? {
        let roleList = readyRoomModel?.scriptRoleList
        let userList = readyRoomModel?.roomUserList!
        
        guard let itemIndex = getIndexWithUserIsSpeaking(uid: UInt(bitPattern: uid)) else { return nil}
        let model = userList?[itemIndex]
        let scriptRoleId = model?.scriptRoleId!
        
        for (index, role) in roleList!.enumerated() {
            let script_role_id = role.scriptRoleId
            if scriptRoleId == script_role_id {
                return index
            }
        }
        return nil
    }
}

// MARK: - 初始化声网sdk
extension PrepareRoomViewController {
    private func initAgoraKit() {
        // 初始化
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgoraKit_AppId, delegate: self)
        // 因为是纯音频多人通话的场景，设置为通信模式以获得更好的音质
        agoraKit.setChannelProfile(.communication)
        // 通信模式下默认为听筒，demo中将它切为外放
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        // 启动音量回调，用来在界面上显示房间其他人的说话音量
        agoraKit.enableAudioVolumeIndication(1000, smooth: 3, report_vad: false)
        // 加入案发现场的群聊频道
        

        let uid:UInt = UInt(bitPattern: (UserAccountViewModel.shareInstance.account?.userId!)!)
        agoraKit.joinChannel(byToken: nil, channelId: String(room_id!), info: nil, uid: uid) { (channel, uid, elapsed) in
            Log("channel=\(channel) uid=\(uid) elapsed=\(elapsed)")
        }
    }
}
// MARK: AgoraRtcEngineDelegate
extension PrepareRoomViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        if agoraStatus.muteAllRemote == true {
            agoraKit.muteAllRemoteAudioStreams(true)
        }

        if agoraStatus.muteLocalAudio == true {
            agoraKit.muteLocalAudioStream(true)
        }
//
        // 注意： 1. 由于demo欠缺业务服务器，所以用户列表是根据AgoraRtcEngineDelegate的didJoinedOfUid、didOfflineOfUid回调来管理的
        //       2. 每次加入频道成功后，新建一个用户列表然后通过回调进行统计
//        userList = [UserInfo]()
        
        guard let index = getIndexWithUserIsSpeaking(uid: uid),let userList = readyRoomModel?.roomUserList! else { return }
        let model = userList[index]
//        let str = "\(model.nickname!)入室しました"
        let obj = ["name": model.nickname!, "status" : "入室しました"] as [String : AnyObject]
        notifArr.append(obj)
        marqueeView.dataArray = notifArr
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // 当有用户加入时，添加到用户列表
        // 注意：由于demo缺少业务服务器，所以当观众加入的时候，观众也会被加入用户列表，并在界面的列表显示成静音状态。 正式实现的话，通过业务服务器可以判断是参与游戏的玩家还是围观观众
//        addUser(uid: uid)
        
//        let userList = readyRoomModel?.roomUserList!

        guard let userList = readyRoomModel?.roomUserList! else {
            return
        }
        if let index = getIndexWithUserIsSpeaking(uid: uid) {
            let model = userList[index]
            
            let obj = ["name": model.nickname!, "status" : "入室しました"] as [String : AnyObject]
            notifArr.append(obj)
            marqueeView.dataArray = notifArr
            
            
            Log(model)
        }
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        // 当用户离开时，从用户列表中清除
        
        removeUser(uid: uid)

        guard let userList = readyRoomModel?.roomUserList! else {
            return
        }
        
        if let index = getIndexWithUserIsSpeaking(uid: uid) {
            let model = userList[index]
            let obj = ["name": model.nickname!, "status" : "退室しました"] as [String : AnyObject]
            notifArr.append(obj)
            marqueeView.dataArray = notifArr
            Log(model)
        }
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        // 当频道里的用户开始或停止发送音频流的时候，会收到这个回调。在界面的用户头像上显示或隐藏静音标记
        guard let userList = readyRoomModel?.roomUserList! else {
            return
        }
        
        if !muted {
            for speaker in userList {
                let userId = speaker.userId!
                if let index = getIndexWithUser(uid: userId), let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? PrepareRoomCell {
                    cell.pointView.isHidden = muted
                    tableView.reloadData()
                }
            }
        }
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        // 收到说话者音量回调，在界面上对应的 cell 显示动效
//        guard let userList = readyRoomModel?.roomUserList! else {
//            return
//        }
        
        let userId = UserAccountViewModel.shareInstance.account?.userId!
        if let index = getIndexWithUser(uid: userId!), let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? PrepareRoomCell {
            
            if totalVolume <= 0 {
                cell.pointView.isHidden = true
                cell.animation = false
            } else {
                cell.pointView.isHidden = false
                cell.animation = true
            }
        }
        
        for speaker in speakers {
            let userId = speaker.uid
            if let index = getIndexWithUser(uid: Int(userId)), let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? PrepareRoomCell {
                if speaker.volume <= 0 {
                    cell.pointView.isHidden = true
                    cell.animation = false
                } else {
                    cell.pointView.isHidden = false
                    cell.animation = true
                }
            }
        }
        
    }
}

//MARK: - InputTextViewDelegate
extension PrepareRoomViewController: InputTextViewDelegate  {
    
    func commonBtnClick() {
        textInputView.removeFromSuperview()
        
        let password = textInputView.textFieldView.text
//        if (password != nil) {
//            lockStatus = 0
//        } else {
//            lockStatus = 1
//        }
        lockStatus = 0
        setPassword(password: password)
    }
    
    @objc func keyboardWillChangeFrame(notif: Notification) {
        // 获取动画执行的时间
        let duration = notif.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 获取键盘最终Y值
        let endFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 计算工具栏距离底部的间距
        let margin = FULL_SCREEN_HEIGHT - y - HOME_INDICATOR_HEIGHT
        
        // 执行动画
        textInputView.bottomConstraint.constant = margin
        UIView.animate(withDuration: duration) {
            self.textInputView.layoutIfNeeded()
        }
    }
}

//
extension PrepareRoomViewController {
    
}




extension PrepareRoomViewController: WebSocketDelegate {
    
    // initSocket方法
    func initWebSocketSingle () {
        SVProgressHUD.show(withStatus: "加载中")
        SingletonSocket.sharedInstance.socket.delegate = self
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        SVProgressHUD.dismiss()
        Log("websocketDidConnect=\(socket)")
         //设置重连次数，解决无限重连问题
         reConnectTime = 0
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
        //执行重新连接方法
        socketReconnect()
        
//        Log("websocketDidDisconnect=\(socket)\(error)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let dic = getDictionaryFromJSONString(jsonString: text)
        current_client_id = dic["client_id"] as? String
        let datas = getJSONStringFromDictionary(dictionary: ["room_id":room_id as Int])
        if dic["type"] as? String == "init" {
            bindRequest(scene: 1, client_id: current_client_id, datas: datas) { (result, error) in
            }
        } else if (dic["type"] as? String == "script_download"){
            
            Log("script_download-websocketDidReceiveMessage=\(socket)\(text)")

            let userId = dic["user_id"] as! Int
            let datas = dic["datas"] as! Float
            let s = String(format:"%.2f",datas)
            let progress = Float(s)!
            
            let userIndex = getIndexWithUserIsSpeaking(uid: UInt(bitPattern: userId))!
            let userList = readyRoomModel?.roomUserList
            let model = userList![userIndex]
            
            if model.status == 0 { // 未开始
                if model.scriptRoleId == 0 { // 未选择角色
                    prepareBtn.isUserInteractionEnabled = false
                    prepareBtn.setTitle("ダウンロード中:\(progress)%", for: .normal)
                    if progress == 100.0 {
                        prepareBtn.setTitle("準備", for: .normal)
                        prepareBtn.isUserInteractionEnabled = true
                    }
                    
                } else {
                    if let index = getIndexWithUser(uid: userId), let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? PrepareRoomCell {
                        cell.progressLabel.isHidden = false
                        
                        cell.progressLabel.text = String("\(progress)%")
                        tableView.reloadData()
                    }
                }
                if progress == 100.0 || progress == 100.00 ||  progress == 100  {
                    if let index = getIndexWithUser(uid: userId), let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? PrepareRoomCell {
                        cell.progressLabel.text = String("\(progress)%")
                        cell.prepareBtn.isHidden = true
                        cell.progressLabel.isHidden = true
                        tableView.reloadData()
                    }
                }
            } else { // 已准备
                if let index = getIndexWithUser(uid: userId), let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? PrepareRoomCell {
                    cell.prepareBtn.isHidden = true
                    cell.progressLabel.isHidden = false
                    cell.progressLabel.text = String("\(progress)%")
                    tableView.reloadData()
                }
                if progress == 100.0 || progress == 100.00 ||  progress == 100  {
                    if let index = getIndexWithUser(uid: userId), let cell = tableView.cellForRow(at: IndexPath(item: index, section: 0)) as? PrepareRoomCell {
                        cell.progressLabel.text = String("\(progress)%")
                        cell.progressLabel.isHidden = true
                        cell.prepareBtn.isHidden = false
                        tableView.reloadData()
                    }
                }
            }

            
        } else if (dic["type"] as? String == "room_ready") {
            // 取到结果
            guard  let resultDic :[String : AnyObject] = dic as? [String : AnyObject] else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["result"] as! [String : AnyObject]
                
                Log("websocketDidReceiveMessage----数据更新了")
                Log("websocketDidReceiveMessage=\(socket)\(text)")
                readyRoomModel = nil
                readyRoomModel = ReadyRoomModel(fromDictionary: resultData)
                if readyRoomModel != nil {
                    
                    refreshUI()
//                    DispatchQueue.main.async { [weak self] in
//
//                        self?.refreshUI()
//                    }
                }
            } else {
                
            }
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        Log("websocketDidReceiveData=\(socket)\(data)")


    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
}

//MARK: - 分享代理
extension PrepareRoomViewController: ShareViewDelegate {
    func shareFriendsBtnClick() {
        let vc = MyFriendsListViewController()
        vc.isShare = 2
        let model = ScriptDetailModel(fromDictionary: [ : ])
        model.scriptId = readyRoomModel?.scriptId
        model.cover = readyRoomModel?.scriptCover
        model.name = readyRoomModel?.scriptName
        model.introduction = readyRoomModel?.introduction
        model.roomId = readyRoomModel?.roomId
        vc.shareModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func shareLineBtnClick() {
        
    }
    
    func shareCopyBtnClick() {
        
    }
    
    
}


