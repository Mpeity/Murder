//
//  GameplayViewController.swift
//  Murder
//
//  Created by mac on 2020/7/21.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SnapKit
import CLToast
import AgoraRtcKit
import Starscream
import SVProgressHUD


private let GameplayViewCellId = "GameplayViewCellId"

class GameplayViewController: UIViewController {
        
    var room_id: Int!
    
    var script_id: Int? {
        didSet {
            Log("这一个页面的script_id是---\(script_id)")
        }
    }

    private var current_client_id: String!
    
    

    private var scrollView: UIScrollView!
       // 背景图片
    private var bgImgView: UIImageView! = UIImageView()
    
    // AgoraRtcEngineKit 入口类
    var agoraKit: AgoraRtcEngineKit!
    
    var agoraStatus = AgoraStatus.sharedStatus()

    
    // 顶部视图
    private var headerBgView: UIView = UIView()
    
    // 退出房间按钮
    private var exitBtn: UIButton = UIButton()
    // 游戏名称展示
    private var gameNameLabel: UILabel = UILabel()
    // 消息按钮
    private var messageBtn: UIButton = UIButton()
    
    // wifi信号
    private var wifiImgView: UIImageView = UIImageView()
    // 电量
    private var electricityView: UIView = UIView()
    
    // 当前阶段
    private var currentLabel: UILabel = UILabel()
    // 阶段说明
    private var stateBtn: UIButton = UIButton()
    
//    // 阶段说明  0x1096299c0
//    var stateTipView: UIView = UIView()
//    var stateTipLabel: UILabel = UILabel()
    
    // 说明弹框配置
    private var preference:FEPreferences = FEPreferences()
    // 说明弹框
//    private var tipView: FETipView!
    
    private var popTipView: PopTipView!
    
    private var popCommentView: UIView!


    
    // 中间布局
    // 地点名称
    private var placeBtn: UIButton = UIButton()
    // 地点弹框
    private var popMenuView = PlacePopMenuView()
    
    // 倒计时
    private var timerView = UIView()
    private var timerLabel = UILabel()
    
    
    // 剩余次数
    private var remainingView = UIView()
    private var remainingLabel = UILabel()
    private var remainingCount: Int = 0
    
    
    // 搜查view
    var searchImgView = UIImageView()
    // 搜查按钮
    let searchBtn = UIButton()
    // 已空按钮
    let emptyBtn = UIButton()

    
    // 投票结果
    var voteResultBtn = UIButton()
    // 结算情报
    var voteInfoBtn = UIButton()
    
    // 底部按钮
    // 麦克风按钮
    var microphoneBtn: UIButton = UIButton()
    // 剧本按钮
    var scriptBtn: UIButton = UIButton()
    // 线索按钮
    var threadBtn: UIButton = UIButton()
    // 密谈按钮
    var collogueBtn: UIButton = UIButton()
    var collogueLabel = UILabel()
    
    
    // 未知按钮名称
    var commonBtn: GradienButton = GradienButton()
    
    // 举手
    var handsUp = false
    
    var voiceHide = false
    
    // 开关本地音频发送  YES: 停止发送本地音频流 NO: （默认）继续发送本地音频流
    var muteLocalAudioStream = false
    
    
    // 前一个节点
    var pre_node_type: Int? = 0
    // 当前id
    var script_node_id: Int? = 0
    // 我的id
    var script_role_id : Int!
    // 发起解散
    var dissolveView = DissolveView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
    // 剧本阅读
    var readScriptView = ReadScriptView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
    
    // 线索
    let threadView = ThreadView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
    
    // 纪录自己的位置
    var ownIndex: Int? = -1
    
    private lazy var leftCollectionView: UICollectionView = {
        
           
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical     //滚动方向
        // 行间距
        layout.minimumLineSpacing = 20
//        // 列间距
//        layout.minimumInteritemSpacing = (FULL_SCREEN_WIDTH-120*2)

        layout.itemSize = CGSize(width: 90, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15,  bottom: 0, right: 15)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 50+NAVIGATION_BAR_HEIGHT, width: 100, height: 100), collectionViewLayout: layout)
        
        collectionView.register(UINib(nibName: "GameplayViewCell", bundle: nil), forCellWithReuseIdentifier: GameplayViewCellId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    
    private lazy var rightCollectionView: UICollectionView = {
           
              
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .vertical     //滚动方向
       // 行间距
       layout.minimumLineSpacing = 20
        
//        列间距
//       layout.minimumInteritemSpacing = (FULL_SCREEN_WIDTH-120*2)

       layout.itemSize = CGSize(width: 90, height: 80)
       layout.sectionInset = UIEdgeInsets(top: 0, left: 15,  bottom: 0, right: 15)
       let collectionView = UICollectionView(frame:  CGRect(x: FULL_SCREEN_WIDTH-100, y: 50+NAVIGATION_BAR_HEIGHT, width: 100, height: 100), collectionViewLayout: layout)
       collectionView.register(UINib(nibName: "GameplayViewCell", bundle: nil), forCellWithReuseIdentifier: GameplayViewCellId)
       collectionView.backgroundColor = UIColor.clear
       collectionView.showsHorizontalScrollIndicator = false
       return collectionView
    }()
    
    
    var leftArr = NSMutableArray.init()
    var rightArr = NSMutableArray.init()

    
//    var rightArr: NSMutableArray = NSMutableArray.init()

    // 游戏进行中Model
    private var gamePlayModel : GamePlayModel?
    
    // 当前自己的角色Model
    private var currentScriptRoleModel :GPScriptRoleListModel?
    
    // 密谈
    var collogueRoomView: CollogueRoomView?
    
    // 是否加入密聊室
    var isJoinCollogueRoom: Bool? = false
    
    // 线索
//    var threadView : ThreadView?
    // 答题页面
    let commonQuestionView = QuestionView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
    
    // 地点index
    private var placeIndex: Int = 0
    
//    override  var  prefersStatusBarHidden:  Bool  {
//        return  true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
//        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        statusBar?.backgroundColor = UIColor.clear
        
        
        initWebSocketSingle()
        initAgoraKit()
        setUI()
        gamePlaying()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        
        navigationController?.navigationBar.isHidden = true
        
        if !SingletonSocket.sharedInstance.socket.isConnected {
            reConnectTime = 0
            socketReconnect()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.setStatusBarHidden(false, with: .none)

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SingletonSocket.sharedInstance.socket.disconnect()
        userLogout()
    }
    

    
    deinit {

    }

}



//MARK: - 数据请求
extension GameplayViewController {
    func gamePlaying() {
        if script_node_id != 0 {
            gameIngRequest(room_id: room_id, script_node_id: script_node_id!) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    let data = resultDic["data"] as! [String : AnyObject]
                    self?.gamePlayModel = GamePlayModel(fromDictionary: data)
                    
                    self?.joinSecretTalk()
                    self?.refreshUI()
                    
                } else {
                    
                }

            }

        }
    }
        
}

// MARK: - 根据ID取图片
extension GameplayViewController {
    
    func getImagePathWith(attachmentId: String) -> String? {
        Log("这里有图片吗------2----\(script_id)")
        guard let script_id = script_id else {
            Log("这里没有图片------7")
            return nil
        }
        
        if (UserDefaults.standard.value(forKey: String(script_id)) != nil) {
            let localData = ScriptLocalData.shareInstance.getNormalDefult(key: String(script_id))
            let dic = localData as! Dictionary<String, AnyObject>
            let filePath = dic[attachmentId]
            
            let lastPath = filePath?.components(separatedBy: "/").last
            let imagePath = NSHomeDirectory() + "/Documents/" + lastPath!
            Log("这里有图片吗------3")
            if !imagePath.isEmpty {
                Log("这里有图片------5")
                return imagePath
            } else {
                Log("这里没有图片------4")
                return nil
            }
        }
        return nil
    }
}

// MARK: - setUI
extension GameplayViewController {
    
    private func joinSecretTalk() {
        script_id = gamePlayModel?.script.scriptId
        if let scriptRoleList = gamePlayModel!.scriptRoleList {
            for (index, itemModel) in scriptRoleList.enumerated() {
                let userId = itemModel.user.userId
                if userId == UserAccountViewModel.shareInstance.account?.userId {
                    currentScriptRoleModel = itemModel
                    ownIndex = index
                    break
                }
            }
        }
        
        // 绘制地图
        if currentScriptRoleModel?.scriptNodeMapList != nil {
            Log("这里有图片吗------1")
            let model = currentScriptRoleModel?.scriptNodeMapList?[0]
            drawImage(model: model)
        }
        
        if (currentScriptRoleModel?.secretTalkId)! > 0 {
            isJoinCollogueRoom = true
            let index = (currentScriptRoleModel?.secretTalkId!)! - 1
            commonBtnTapAction(index: index)
            if collogueRoomView == nil {
                collogueRoomView = CollogueRoomView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                collogueRoomView!.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                collogueRoomView?.roomCount = gamePlayModel?.script.secretTalkRoomNum
                collogueRoomView?.room_id = room_id
                collogueRoomView?.delegate = self
                collogueRoomView?.selectIndexPath = IndexPath(row: index, section: 0)
                self.view.addSubview(collogueRoomView!)
                collogueRoomView?.isHidden = true
            }
        }
    }
    
    private func refreshUI() {
        leftArr.removeAllObjects()
        rightArr.removeAllObjects()
        
        
        
        if let scriptRoleList = gamePlayModel!.scriptRoleList {
            for (index, itemModel) in scriptRoleList.enumerated() {
                if index % 2 == 0 {
                    leftArr.add(itemModel)
                } else {
                    rightArr.add(itemModel)
                }
            }
        }
                
        let count = gamePlayModel!.scriptRoleList?.count ?? 0
        
        let one = count / 2
        
        let two = count % 2
        
        let space = 20 * (one + two)
        leftCollectionView.frame = CGRect(x: 0, y: 50+NAVIGATION_BAR_HEIGHT, width: 100, height: CGFloat(100 * (one + two)) + CGFloat(space))
        leftCollectionView.reloadData()
        
        
        rightCollectionView.frame = CGRect(x: FULL_SCREEN_WIDTH-100, y: 50+NAVIGATION_BAR_HEIGHT, width: 100, height: CGFloat(100 * (one + two)) + CGFloat(space))
        rightCollectionView.reloadData()
        
        if let scriptRoleList = gamePlayModel!.scriptRoleList {
            for (index, itemModel) in scriptRoleList.enumerated() {
                let userId = itemModel.user.userId
                if userId == UserAccountViewModel.shareInstance.account?.userId {
                    currentScriptRoleModel = itemModel
                    ownIndex = index
                    break
                }
            }
        }

        if gamePlayModel?.script != nil {
            gameNameLabel.text = gamePlayModel?.script.scriptName
        } else {
           gameNameLabel.text = ""
        }
        
        // 配置按钮
        if gamePlayModel?.scriptNodeResult.buttonName != nil {
            commonBtn.setTitle(gamePlayModel?.scriptNodeResult.buttonName!, for: .normal)
        }
        
        // 密谈数量
        let collogueBtnNum = gamePlayModel?.script.secretTalkRoomNum
        collogueLabel.text = String(collogueBtnNum!)
        
    
        if gamePlayModel?.scriptNodeResult.nodeName != nil {
            currentLabel.text = gamePlayModel?.scriptNodeResult.nodeName
        }
        
        if gamePlayModel?.scriptNodeResult.describe != nil {
            preference.drawing.message = gamePlayModel?.scriptNodeResult!.describe! as! String
            
            addPopTipView()
        }
        
        
        if currentScriptRoleModel?.scriptNodeMapList != nil {
            popMenuView.selectIndexPath = IndexPath(row: placeIndex, section: 0)
            popMenuView.titleArray = (currentScriptRoleModel?.scriptNodeMapList!)! as [AnyObject]
            popMenuView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(placeBtn.snp.bottom).offset(5)
                make.height.equalTo(55*popMenuView.titleArray.count)
                make.width.equalTo(136)
            }
            
            // 绘制地图
            Log("这里有图片吗------1")
            let model = currentScriptRoleModel?.scriptNodeMapList?[placeIndex]
            drawImage(model: model)
        }
        
        
        // 更新 地图小红点
        let itemModel = currentScriptRoleModel?.scriptNodeMapList![placeIndex]
        let placeStr = itemModel?.name
        placeRedPoint(placeStr: placeStr!)
        
        
        

        // 更新 剧本小红点
        if currentScriptRoleModel?.chapter != nil {
            readScriptView.scriptData = currentScriptRoleModel?.chapter
            readScriptView.type = "script"
            scriptRedPoint()
        }
        
        

        // 更新 线索小红点
        if currentScriptRoleModel?.gameUserClueList != nil {
            threadView.gameUserClueList = currentScriptRoleModel?.gameUserClueList
            threadView.script_id = script_id
            threadRedPoint()
        }

    }
    
    //MARK:- 绘制地图
    func drawImage(model: GPNodeMapListModel?) {
        guard let imagePath = getImagePathWith(attachmentId: (model?.attachmentId!)!) else { return }
        Log("这里有图片------6\(model?.attachmentId)")
        

        let image = UIImage(contentsOfFile: imagePath)
    
    

        Log("这里有图片------6\(image!)")
        var size = CGSize.zero
        var newImage = UIImage()
        if (image?.size.height)! < FULL_SCREEN_HEIGHT {
            let height = FULL_SCREEN_HEIGHT
            let scale = CGFloat(FULL_SCREEN_HEIGHT / (image?.size.height)!)
            let width = (image?.size.width)! * scale
            let newSize = CGSize(width: width, height: height)
            newImage = imageWithImage(image: image!, size: newSize)
            size = newImage.size
        } else {
            let height = FULL_SCREEN_HEIGHT
            let scale = CGFloat(FULL_SCREEN_HEIGHT / (image?.size.height)!)
            let width = (image?.size.width)! * scale
            let newSize = CGSize(width: width, height: height)
            newImage = imageWithImage(image: image!, size: newSize)
            size = newImage.size
        }
        
        
    
        

        bgImgView.size = size
        scrollView.contentSize = CGSize(width: bgImgView.bounds.size.width, height: 0)

        
//        scrollView.contentSize = CGSize(width: bgImgView.bounds.size.width, height: 0)
        
//        scrollView.contentSize = bgImgView.bounds.size
        
        bgImgView.image = newImage
        bgImgView.sizeToFit()
        bgImgView.contentMode = .scaleAspectFill

        drawImagesButtons(mapModel: model!, orignalSize: (image?.size)!)
        
        // 绘制地图小红点
        let placeStr = model?.name
        placeRedPoint(placeStr: placeStr!)
    }
    
    //MARK:- thread redpoint
    private func threadRedPoint() {
         if currentScriptRoleModel?.gameUserClueList != nil {
             let arr = currentScriptRoleModel?.gameUserClueList!
             for item in arr! {
                 if item.isRead == 0 { // 未查看
                     addRedPoint(commonView: threadBtn, x: 30, y: 5)
                     break
                 }
                 hideRedPoint(commonView: threadBtn)
             }
         }
    }
    
    //MARK:- script redpoint
    private func scriptRedPoint() {
         if currentScriptRoleModel?.chapter != nil {
             let arr = currentScriptRoleModel?.chapter!
             for item in arr! {
                 if item.see == 0 { // 未查看
                     addRedPoint(commonView: scriptBtn, x: 30, y: 5)
                     break
                 }
                 hideRedPoint(commonView: scriptBtn)
             }
         }
    }
    
    //MARK:- place redpoint
    private func placeRedPoint(placeStr: String) {
        // 绘制地图小红点
         let placeStrWidth = placeStr.ga_widthForComment(fontSize: 10.0, height: 21)
         Log(placeStrWidth)
         placeBtn.snp.remakeConstraints { (make) in
             make.centerX.equalToSuperview()
             make.top.equalTo(headerBgView.snp.bottom).offset(5)
             make.height.equalTo(21)
             make.width.equalTo(placeStrWidth + 35)
         }
         placeBtn.setTitle(placeStr, for: .normal)
         
         // 背景地图
         if currentScriptRoleModel?.scriptNodeMapList != nil {
             let arr = currentScriptRoleModel?.scriptNodeMapList!
             for item in arr! {
                 if item.see == 0 { // 未查看
                     addRedPoint(commonView: placeBtn, x: placeStrWidth + 20, y: 5)
                     break
                 }
                 hideRedPoint(commonView: placeBtn)
             }
         }
    }
    
    //MARK:- 绘制地图的按钮
    func drawImagesButtons(mapModel: GPNodeMapListModel, orignalSize: CGSize) {
        let list = mapModel.scriptMapPlaceList!
        if list.isEmpty {
            return
        }
        let scale = Float(FULL_SCREEN_HEIGHT/orignalSize.height)
        for itemModel in list {
            let x = CGFloat((itemModel.controlXCoordinate! as NSString).floatValue * scale)
            let y = CGFloat((itemModel.controlYCoordinate! as NSString).floatValue * scale)
            let width = CGFloat((itemModel.controlWidth! as NSString).floatValue * scale)
            let height = CGFloat((itemModel.controlHeight! as NSString).floatValue * scale)
            
            let button = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
            button.backgroundColor = UIColor.clear
            bgImgView.addSubview(button)
            bgImgView.isUserInteractionEnabled = true
            
            let statusImageView = UIImageView()
            bgImgView.addSubview(statusImageView)
            statusImageView.snp.makeConstraints { (make) in
                make.height.equalTo(16)
                make.width.equalTo(43)
                make.top.equalTo(button.snp_top).offset(-16)
                make.left.equalTo(button.snp_left)
            }
            
            if itemModel.searchOver == 1 { // 已空
                statusImageView.image = UIImage(named: "yikong_icon")
                button.addTarget(self, action: #selector(emptyBtnAction), for: .touchUpInside)
            } else { // 可搜
                statusImageView.image = UIImage(named: "soucha_icon")
                button.tag = itemModel.scriptPlaceId!
                button.addTarget(self, action: #selector(searchBtnAction(button:)), for: .touchUpInside)

            }
            
        }
        
    }
    
    //MARK:- 说明
    private func addPopTipView() {

        let message = gamePlayModel?.scriptNodeResult!.describe!
        let size = getHeight(string: message!, width: 200)
        let width = 230
        var height = size.height
        height = height + 36 + 20
        let leftSpace = Int(FULL_SCREEN_WIDTH) - width - 15
        
        if popCommentView == nil {
               popCommentView = UIView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
               popCommentView.backgroundColor = UIColor.clear
               self.view.addSubview(popCommentView)
               popCommentView.isUserInteractionEnabled = true
               let tap = UITapGestureRecognizer(target: self, action: #selector(hidePopTipView))
               popCommentView.addGestureRecognizer(tap)
        }
        popCommentView.isHidden = true

        
        if popTipView == nil {
            
//            let y = stateBtn.frame.maxY + 10
            
//            let y = STATUS_BAR_HEIGHT + 40 + stateBtn.frame.height * 0.5
            
            var y = 0
            if IS_iPHONE_X {
                y = Int(STATUS_BAR_HEIGHT + 50 + stateBtn.frame.height )
            } else {
                y = Int(STATUS_BAR_HEIGHT + 40 + stateBtn.frame.height * 0.5)
            }
            
            popTipView = PopTipView(frame: CGRect(x: leftSpace, y: Int(y), width: width, height: Int(height)))
            popTipView.backgroundColor = UIColor.clear
            popCommentView.addSubview(popTipView)
        }
     
        popTipView.content = gamePlayModel?.scriptNodeResult!.describe!
    }
    
    
    private func setUI() {
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        self.view.addSubview(scrollView)
        bgImgView.frame = CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT)
        self.scrollView.addSubview(bgImgView)
        
        scrollView.backgroundColor = UIColor.white

        
        //是否有,弹簧效果
        self.scrollView.bounces = false
        //是否滚动
        self.scrollView.isScrollEnabled = true
        //是否显示水平/垂直滚动条
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isUserInteractionEnabled = true
        
        setHeaderView()
        setMiddleView()
        setBottomView()
        
        // 申请解散弹框
        self.view.addSubview(dissolveView)
        dissolveView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        // 不解散
        dissolveView.dissolutionBtnNoBlcok = {[weak self] () ->() in
            
            self!.dissolutionRequest(status: 1)
            self!.dissolveView.votingView.isHidden = true
            self!.dissolveView.dissolutionView.isHidden = true
            self!.dissolveView.isHidden = true
            
        }
        
        // 解散
        dissolveView.dissolutionBtnTapBlcok = {[weak self] () ->() in
            self!.dissolutionRequest(status: 3)
            self!.dissolveView.votingView.isHidden = true
            self!.dissolveView.dissolutionView.isHidden = true
            self!.dissolveView.isHidden = true
        }
        
        // 发起解散
        dissolveView.dissolutionBtnStartBlcok = {[weak self] () ->() in
            // 【1拒绝解散3解散状态】
            self!.dissolutionRequest(status: 3)
            self!.dissolveView.votingView.isHidden = true
            self!.dissolveView.dissolutionView.isHidden = true
            self!.dissolveView.isHidden = true
        }
        
        // 取消发起
        dissolveView.dissolutionBtnCancelBlcok = {[weak self] () ->() in
            self!.dissolveView.votingView.isHidden = true
            self!.dissolveView.dissolutionView.isHidden = true
            self!.dissolveView.isHidden = true
        }
        dissolveView.isHidden = true
        
        // 剧本阅读
        readScriptView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        readScriptView.isHidden = true
        self.view.addSubview(readScriptView)
        
        // 线索
        threadView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        threadView.isHidden = true
        self.view.addSubview(threadView)
        
        // 投票
        self.view.addSubview(commonQuestionView)
        commonQuestionView.isHidden = true
        commonQuestionView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)

    }
    
    /// 添加红点
    private func addRedPoint(commonView: UIView, x: CGFloat, y: CGFloat) {
        
        hideRedPoint(commonView: commonView)
        
        let point = UIView()
        point.tag = 1234
        commonView.addSubview(point)
        point.backgroundColor = HexColor("#ED2828")
        point.layer.cornerRadius = 3.5
        point.snp.makeConstraints { (make) in
            make.width.height.equalTo(7)
            make.left.equalToSuperview().offset(x)
            make.top.equalToSuperview().offset(y)
        }
    }
    
    private func hideRedPoint(commonView: UIView) {
        let point = commonView.viewWithTag(1234)
        if point != nil {
            point?.removeFromSuperview()
        }
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
            make.width.equalTo(200)
        }
        gameNameLabel.text = "平凡な宿"
        gameNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        gameNameLabel.textColor = UIColor.white
        gameNameLabel.textAlignment = .left
        
        
        // 消息按钮
        bgView.addSubview(messageBtn)
        messageBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-73)
            make.top.equalToSuperview().offset(10.5)
            make.size.equalTo(12)
        }
        messageBtn.setImage(UIImage(named: "gameplay_message"), for: .normal)
        messageBtn.addTarget(self, action: #selector(messageBtnAction(button:)), for: .touchUpInside)
        
        let lineOneImgView = UIImageView()
        lineOneImgView.image = UIImage(named: "createroom_line")
        bgView.addSubview(lineOneImgView)
        lineOneImgView.snp.makeConstraints { (make) in
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
                
        
        // 当前阶段
        bgView.addSubview(currentLabel)
        currentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11.5)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(16)
            make.width.equalTo(100)
        }
        currentLabel.text = "【 第一幕 】"
        currentLabel.font = UIFont.systemFont(ofSize: 13.0)
        currentLabel.textColor = UIColor.white
        currentLabel.textAlignment = .left

        
        // 阶段说明
         bgView.addSubview(stateBtn)
         stateBtn.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(15)
            make.width.equalTo(75)
         }
        stateBtn.isSelected = false
        stateBtn.createButton(style: .left, spacing: 5, imageName: "gameplay_explain", title: "段階説明", cornerRadius: 0, color: nil)
        stateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        stateBtn.backgroundColor = UIColor.clear
        stateBtn.addTarget(self, action: #selector(stateBtnAction(button:)), for: .touchUpInside)
        
    }
    // MARK: - 中间
    private func setMiddleView() {
        
        self.view.addSubview(leftCollectionView)
        leftCollectionView.delegate = self
        leftCollectionView.dataSource = self
        
        self.view.addSubview(rightCollectionView)
        rightCollectionView.delegate = self
        rightCollectionView.dataSource = self
        
        // 地点名称按钮
        self.view.addSubview(placeBtn)
        placeBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerBgView.snp.bottom).offset(5)
            make.height.equalTo(21)
            make.width.equalTo(86)

        }
        placeBtn.isSelected = true
        placeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        placeBtn.setBackgroundImage(UIImage(named: "gameplay_place"), for: .normal)
        placeBtn.addTarget(self, action: #selector(palceBtnAction(button:)), for: .touchUpInside)
        
        
//        addRedPoint(commonView: placeBtn, x: 64, y: 1.5)
        
        
        self.view.addSubview(popMenuView)
        popMenuView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeBtn.snp.bottom).offset(5)
            make.height.equalTo(55)
            make.width.equalTo(136)
        }
        popMenuView.imageName = "menu_catalogue_white"
        popMenuView.cellRowHeight = 55
        popMenuView.isHideImg = true
        popMenuView.lineColor = HexColor(hex:"#333333", alpha: 0.05)
        popMenuView.contentTextColor = HexColor("#999999")
        popMenuView.contentTextFont = 15
        popMenuView.refresh()
        popMenuView.isHidden = true
        popMenuView.delegate = self

        
        
        
        // 倒计时
        self.view.addSubview(timerView)
        timerView.backgroundColor = HexColor(hex: "#ffffff", alpha: 0.6)
        timerView.layer.cornerRadius = 12.5
        timerView.snp.makeConstraints { (make) in
            make.top.equalTo(placeBtn.snp_bottom).offset(12.5)
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
        }
        
        timerView.addSubview(timerLabel)
        timerLabel.textColor = HexColor(DarkGrayColor)
        timerLabel.font = UIFont.systemFont(ofSize: 10)
//        let string = "カウントダウン\(timerCount)s"
//        let ranStr = String(timerCount)
//        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
//        let str = NSString(string: string)
//        let theRange = str.range(of: ranStr)
//        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#ED2828"), range: theRange)
//        timerLabel.attributedText = attrstring
        timerLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview()
            make.height.equalTo(25)
        }
        timerView.isHidden = true
        
        // 剩余次数
        self.view.addSubview(remainingView)
        remainingView.backgroundColor = HexColor(hex: "#20014D", alpha: 0.8)
        remainingView.layer.cornerRadius = 12.5
        remainingView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-82-HOME_INDICATOR_HEIGHT)
            make.right.equalToSuperview().offset(15)
            make.height.equalTo(27)
        }
        
        remainingView.addSubview(remainingLabel)
        remainingLabel.textColor = UIColor.white
        remainingLabel.font = UIFont.systemFont(ofSize: 10)
        let remainingString = "操作できる回数：\(remainingCount)"
        let remainingRanStr = String(remainingCount)
        let remainingAttrstring:NSMutableAttributedString = NSMutableAttributedString(string:remainingString)
        let remainingStr = NSString(string: remainingString)
        let remainingTheRange = remainingStr.range(of: remainingRanStr)
        remainingAttrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor(LightOrangeColor), range: remainingTheRange)
        remainingLabel.attributedText = remainingAttrstring
        remainingLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-25)
            make.top.equalToSuperview()
            make.height.equalTo(27)
        }
        remainingView.isHidden = true
        
        
        // 投票
        self.view.addSubview(voteResultBtn)
        voteResultBtn.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(44)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-145)
            } else {
                           // Fallback on earlier versions
                make.right.equalToSuperview().offset(-145)
            }
            make.centerX.equalToSuperview()
        }
        voteResultBtn.layoutIfNeeded()
        voteResultBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        voteResultBtn.setTitle("投票結果", for: .normal)
        voteResultBtn.setTitleColor(UIColor.white, for: .normal)
        voteResultBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        voteResultBtn.addTarget(self, action: #selector(voteResultBtnAction), for: .touchUpInside)
        voteResultBtn.isHidden = true

        
        self.view.addSubview(voteInfoBtn)
        voteInfoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(44)
            make.top.equalTo(voteResultBtn.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        voteInfoBtn.layoutIfNeeded()
        voteInfoBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        voteInfoBtn.setTitle("決算情報", for: .normal)
        voteInfoBtn.setTitleColor(UIColor.white, for: .normal)
        voteInfoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        voteInfoBtn.addTarget(self, action: #selector(voteInfoBtnAction), for: .touchUpInside)
        voteInfoBtn.isHidden = true
    }
    
    private func setBottomView() {
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-7)
            } else {
                // Fallback on earlier versions
                make.right.equalToSuperview().offset(-7)
            }
        }
        
        // 麦克风
        bottomView.addSubview(microphoneBtn)
        microphoneBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.size.equalTo(50)
        }
        
        microphoneBtn.isSelected = true
        microphoneBtn.setImage(UIImage(named: "createroom_voice"), for: .selected)
        microphoneBtn.setImage(UIImage(named: "createroom_no_voice"), for: .normal)
        
//        microphoneBtn.createButton(style: .top, spacing: 5, imageName: "gameplay_microphone", title: "マイク", cornerRadius: 25, color: "#20014D")
        microphoneBtn.addTarget(self, action: #selector(microphoneBtnAction(button:)), for: .touchUpInside)
        
        
        let bgView = UIView()
        bottomView.addSubview(bgView)
        bgView.backgroundColor = HexColor("#20014D")
        bgView.layer.cornerRadius = 25
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(microphoneBtn.snp.right).offset(15)
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        
        // 剧本按钮
        bgView.addSubview(scriptBtn)
        scriptBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview()
            make.size.equalTo(50)
        }
        scriptBtn.createButton(style: .top, spacing: 5, imageName: "gameplay_script", title: "シナリオ", cornerRadius: 25, color: "#20014D")

        scriptBtn.addTarget(self, action: #selector(scriptBtnAction(button:)), for: .touchUpInside)
//        addRedPoint(commonView: scriptBtn, x: 30, y: 5)
        
        
        // 线索按钮
        bgView.addSubview(threadBtn)
        threadBtn.snp.makeConstraints { (make) in
            make.left.equalTo(scriptBtn.snp.right).offset(7)
            make.top.equalToSuperview()
            make.size.equalTo(50)
        }
        threadBtn.createButton(style: .top, spacing: 5, imageName: "gameplay_thread", title: "手掛かり", cornerRadius: 25, color: "#20014D")
        threadBtn.addTarget(self, action: #selector(threadBtnBtnAction(button:)), for: .touchUpInside)
//        addRedPoint(commonView: threadBtn, x: 30, y: 5)

        
        
        // 密谈按钮
        bgView.addSubview(collogueBtn)
        collogueBtn.snp.makeConstraints { (make) in
            make.left.equalTo(threadBtn.snp.right).offset(7)
            make.top.equalToSuperview()
            make.size.equalTo(50)
        }
        collogueBtn.createButton(style: .top, spacing: 5, imageName: "gameplay_collogue", title: "密談", cornerRadius: 25, color: "#20014D")
        collogueBtn.addTarget(self, action: #selector(collogueBtnAction(button:)), for: .touchUpInside)
        
        collogueLabel.textColor = UIColor.black
        collogueLabel.font = UIFont.systemFont(ofSize: 10)
        collogueLabel.textAlignment = .center
        collogueBtn.addSubview(collogueLabel)
        collogueLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        
        // 未知按钮
        bgView.addSubview(commonBtn)
        commonBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-6)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.width.equalTo(94)
        }
        commonBtn.layoutIfNeeded()
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.setTitle("ボタン名", for: .normal)
        commonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .bold)
        commonBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 19)

        commonBtn.addTarget(self, action: #selector(commonBtnAction(button:)), for: .touchUpInside)
        
    }
    
}

// MARK: - 按钮响应事件
extension GameplayViewController {
    
    @objc func hidePopTipView() {
        popCommentView.isHidden = true
    }
    
    //MARK: - 投票结果
    @objc func voteResultBtnAction() {
        let commonView = VoteResultView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.room_id = room_id
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(commonView)
    }
    
    //MARK: - 情报结算
    @objc func voteInfoBtnAction() {
        let commonView = BillingInfoView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.room_id = room_id
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(commonView)
    }
    
    
    //MARK: - 搜查
    @objc func searchBtnAction(button: UIButton) {
        
        let script_place_id = button.tag
        gameSearch(script_place_id: script_place_id)
        

        
        if currentScriptRoleModel?.user?.point != nil {
            remainingCount = currentScriptRoleModel!.user!.point!
        }
//        remainingCount -= 1
        let remainingString = "操作できる回数：\(remainingCount)"
        let remainingRanStr = String(remainingCount)
        let remainingAttrstring:NSMutableAttributedString = NSMutableAttributedString(string:remainingString)
        let remainingStr = NSString(string: remainingString)
        let remainingTheRange = remainingStr.range(of: remainingRanStr)
        remainingAttrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor(LightOrangeColor), range: remainingTheRange)
        remainingLabel.attributedText = remainingAttrstring
        
        if remainingCount == 0 {
            CLToastManager.share.cornerRadius = 15
            CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
            CLToast.cl_show(msg: "あなたの捜査できる回数はすでになくなりました")
        }
        
    }
    
    // 搜证
    func gameSearch(script_place_id: Int) {
        script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
                SVProgressHUD.show()

        searchClueRequest(room_id: room_id, script_place_id: script_place_id, script_clue_id: nil, script_node_id: script_node_id!) {[weak self] (result, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["search_clue_result"] as! [String : AnyObject]
                let clueResultModel = SearchClueResultModel(fromDictionary: resultData)
                
                let threadCardView = ThreadCardDetailView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                threadCardView.script_id = self?.script_id
                threadCardView.clueResultModel = clueResultModel
                threadCardView.script_place_id = script_place_id
                threadCardView.room_id = self!.room_id
                threadCardView.script_node_id = self!.script_node_id
                
                threadCardView.clueResultModel = clueResultModel
                threadCardView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                self!.view.addSubview(threadCardView)

            } else {
                
            }
        }
    }
    
    // 公开
    func publicClue(model :SearchClueResultModel, script_place_id: Int) {
        clueOpenRequest(room_id: room_id, script_clue_id: model.scriptClueId!, script_place_id:script_place_id, script_node_id: script_node_id!) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                
            let data = resultDic["data"] as! [String : AnyObject]

            } else {
                
            }
        }
    }
    
    //MARK: - 已空
    @objc func emptyBtnAction() {
        CLToastManager.share.cornerRadius = 25
        CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
        CLToast.cl_show(msg: "捜査できる手掛かりはありません")
    }
    
    
    
    /// 头部按钮
    //MARK: 退出房间按钮
    @objc func exitBtnAction(button: UIButton) {
        dissolveView.isHidden = false
        dissolveView.dissolutionView.isHidden = false
    }
    
    // 解散接口
    func dissolutionRequest(status: Int) {
        gameDissolutionRequest(room_id: room_id, status: status) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                
            }
        }
    }
    
    //MARK: 解散房间是 退出声网/断开socekt
    private func userLogout() {
        // 退出当前剧本，离开群聊频道
        agoraStatus.muteAllRemote = false
        agoraStatus.muteLocalAudio = false
        agoraKit.leaveChannel(nil)
        
//        SingletonSocket.sharedInstance.socket.disconnect()
    }
    
    //MARK: 退出房间
    private func popRootVC() {
        userLogout()
        self.navigationController?.popToRootViewController(animated: true)
        return
    }
    
    //MARK: 消息按钮
    @objc func messageBtnAction(button: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        let vc = GotoMessageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //
    //MARK: 阶段说明弹框
    @objc func stateBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
//        popCommentView.isHidden = !popCommentView.isHidden
        
        if popCommentView.isHidden == true {
            popCommentView.isHidden = false
        } else {
            popCommentView.isHidden = true
        }
    }
    
    
    //MARK: 地点名称按钮
    @objc func palceBtnAction(button: UIButton) {
        
        if button.isSelected {
            popMenuView.isHidden = false
            button.isSelected = false
        } else {
            popMenuView.isHidden = true
            button.isSelected = true

        }
        
    }
    
    
    /// 底部按钮
    //MARK: 麦克风
    @objc func microphoneBtnAction(button: UIButton) {
//        button.isSelected = !button.isSelected
//        agoraKit.muteLocalAudioStream(button.isSelected)
        
        
        Log("我加入了2")
        button.isSelected = !button.isSelected
        
        
        if button.isSelected {
            muteLocalAudioStream = false
        } else {
            muteLocalAudioStream = true
        }
        
        // 开关本地音频发送  YES: 停止发送本地音频流 NO: （默认）继续发送本地音频流
        agoraKit.muteLocalAudioStream(muteLocalAudioStream)
        
        if muteLocalAudioStream == true { //
            updateVoice(uid: (UserAccountViewModel.shareInstance.account?.userId)!, totalVolume: 0)
        }
        getMicrophoneStatus(mute: muteLocalAudioStream)
    }
    
    // 自己
    func getMicrophoneStatus(mute: Bool) {
        if let index = getIndexWithUserIsSpeaking(uid: (UserAccountViewModel.shareInstance.account?.userId!)!) {
            
            let tureIndex = index / 2
            if index % 2 == 0 { // 左边
                if let cell = leftCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                    cell.l_comImgView.isHidden = !mute
                    cell.l_comImgView.image = UIImage(named: "image0")
                    cell.l_voiceView.isHidden = !mute
                    cell.l_voiceImgView.isHidden = !mute
                }
                
            } else {
                if let cell = rightCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                    cell.r_comImgView.isHidden = !mute
                    cell.r_comImgView.image = UIImage(named: "image0")
                    cell.r_voiceView.isHidden = !mute
                    cell.r_voiceImgView.isHidden = !mute
                }
            }
        }
    }
    
    
    
    //MARK: 剧本
    @objc func scriptBtnAction(button: UIButton) {
//        if currentScriptRoleModel?.chapter?.count != 0{
            

            readScriptView.isHidden = false
            readScriptView.type = "script"
            readScriptView.scriptData = currentScriptRoleModel?.chapter
            readScriptView.room_id = gamePlayModel?.room.roomId
            readScriptView.script_role_id = currentScriptRoleModel?.user.scriptRoleId
            readScriptView.script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
//        }
    }
    
    //MARK: 线索
    @objc func threadBtnBtnAction(button: UIButton) {
                    
        threadView.isHidden = false
        threadView.script_id = script_id
        threadView.script_role_id = currentScriptRoleModel?.user.scriptRoleId
        threadView.room_id = gamePlayModel?.room.roomId
        threadView.script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
        threadView.gameUserClueList = currentScriptRoleModel?.gameUserClueList
        
    }
    
    
    //MARK:- 密谈
    @objc func collogueBtnAction(button: UIButton) {
        // 密谈视图
        if collogueRoomView == nil {
            collogueRoomView = CollogueRoomView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            collogueRoomView!.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            collogueRoomView?.roomCount = gamePlayModel?.script.secretTalkRoomNum
            collogueRoomView?.room_id = room_id
            collogueRoomView?.delegate = self
            self.view.addSubview(collogueRoomView!)
        }
        if currentScriptRoleModel?.secretTalkId! == 0 {
            collogueRoomView?.selectIndexPath = nil
            collogueRoomView?.roomCount = gamePlayModel?.script.secretTalkRoomNum
        }
        collogueRoomView?.isHidden = false
    }
    
    //MARK: 系统配置未知按钮
    @objc func commonBtnAction(button: UIButton) {
//        节点类型【1故事背景2自我介绍3剧本阅读4搜证5答题6结算】
        
        Log("当前节点")
        Log(pre_node_type)
        Log(gamePlayModel?.scriptNodeResult.nodeType)
        
        
        pre_node_type = gamePlayModel?.scriptNodeResult.nodeType
        
        
        if gamePlayModel?.scriptNodeResult.nodeType != 5 {
            commonBtn.setGradienButtonColor(start: "#999999", end: "#999999", cornerRadius: 19)
            commonBtn.isUserInteractionEnabled = false
        }

        
        script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
        
        if gamePlayModel?.scriptNodeResult.nodeType == 5 && currentScriptRoleModel?.readyOk == 0 { // 答题
            
            if currentScriptRoleModel?.scriptQuestionList?.count != 0 {
                commonQuestionView.isHidden = false
                commonQuestionView.room_id = room_id
                commonQuestionView.script_node_id = script_node_id
                commonQuestionView.scriptQuestionList = currentScriptRoleModel?.scriptQuestionList
                
                // 答题 触发倒计时
                gameCountdownRequest(room_id: room_id, script_node_id: script_node_id!) { (result, error) in
                    if error != nil {
                        return
                    }
                    // 取到结果
                    guard  let resultDic :[String : AnyObject] = result else { return }
                    if resultDic["code"]!.isEqual(1) {

                    }
                }
                return
            }
        }
        
        if gamePlayModel?.scriptNodeResult.nodeType == 6 {
            popRootVC()
            return
        }
        
        gameReadyRequest(role_id: (currentScriptRoleModel?.user.scriptRoleId)!, room_id: room_id, current_script_node_id: script_node_id!) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let countdown = data["countdown"] as! Int
                if countdown == 1 { // 调用倒计时接口
                    if self?.gamePlayModel?.scriptNodeResult.nodeType != 5 {
                        gameCountdownRequest(room_id: self!.room_id, script_node_id: self!.script_node_id!) { (result, error) in
                            if error != nil {
                                return
                            }
                            // 取到结果
                            guard  let resultDic :[String : AnyObject] = result else { return }
                            if resultDic["code"]!.isEqual(1) {
                        
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK: 点击头像
    @objc func userViewTap(user: Any) {
        let playerView = PlayerView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        playerView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(playerView)
    }
    
    
    
    //MARK:- 点击空白 关闭弹窗
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        popMenuView.isHidden = true
//        placeBtn.isSelected = true
//
//        tipView.dismiss()
//        stateBtn.isSelected = true
//    }
}

//MARK:- 密谈
extension GameplayViewController: CollogueRoomViewDelegate {
    // 进入密谈室
    func commonBtnTapAction(index: Int) {
        
        isJoinCollogueRoom = true
        
        let channelId = "\(room_id!)_" + "chat\(index+1)"
        
        
        // 加入私聊频道
        agoraKit.leaveChannel(nil)
        
        // 因为是纯音频多人通话的场景，设置为通信模式以获得更好的音质
        agoraKit.setChannelProfile(.communication)
        // 通信模式下默认为听筒，demo中将它切为外放
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        // 启动音量回调，用来在界面上显示房间其他人的说话音量
        agoraKit.enableAudioVolumeIndication(1000, smooth: 3, report_vad: false)
        // 将本地播放的所有远端用户音量设置为原始音量的 50
        // 该方法中 volume 参数表示录音信号的音量，取值范围为 [0, 400]：
        // 0: 静音。
        // 100: （默认值）原始音量，即不对信号做缩放。
        // 400: 原始音量的 4 倍（把信号放大到原始信号的 4 倍）。
         agoraKit.adjustPlaybackSignalVolume(400)
        
        // 开关本地音频发送  YES: 停止发送本地音频流 NO: （默认）继续发送本地音频流
        
        

        let uid = UserAccountViewModel.shareInstance.account?.userId
        agoraKit.joinChannel(byToken: nil, channelId: channelId, info: nil, uid: UInt(bitPattern: uid!), joinSuccess: nil)
        
        agoraKit.muteLocalAudioStream(muteLocalAudioStream)
        getMicrophoneStatus(mute: muteLocalAudioStream)
        if muteLocalAudioStream == true { //
            updateVoice(uid: (UserAccountViewModel.shareInstance.account?.userId)!, totalVolume: 0)
        }
        
        
        
        let script_role_id = currentScriptRoleModel?.user.scriptRoleId
        let secret_talk_id = index+1
        let mapData = ["user_id":UserAccountViewModel.shareInstance.account?.userId!,"type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":1,"script_role_id":script_role_id!,"secret_talk_id":secret_talk_id,"game_status_type":"secret_talk","key":(UserAccountViewModel.shareInstance.account?.key!)! as String] as [String : AnyObject]
        
        let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
        SingletonSocket.sharedInstance.socket.write(string: mapJson)
        
    }
    
    
    // 退出密谈室
    func leaveBtnTapAction(index: Int) {
        
        collogueRoomView!.isHidden = true
        isJoinCollogueRoom = false
        
        let script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
        let script_role_id = currentScriptRoleModel?.user.scriptRoleId
        let secret_talk_id = index+1
        let mapData = ["user_id":UserAccountViewModel.shareInstance.account?.userId!,"type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":0,"script_role_id":script_role_id!,"secret_talk_id":secret_talk_id,"game_status_type":"secret_talk","key":(UserAccountViewModel.shareInstance.account?.key!)! as String] as [String : AnyObject]
        
        let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
        SingletonSocket.sharedInstance.socket.write(string: mapJson)
   
        agoraKit.leaveChannel(nil)
        initAgoraKit()
        
        // 开关本地音频发送  YES: 停止发送本地音频流 NO: （默认）继续发送本地音频流
        agoraKit.muteLocalAudioStream(muteLocalAudioStream)
        
        getMicrophoneStatus(mute: muteLocalAudioStream)
        
        if muteLocalAudioStream == true {
            updateVoice(uid: (UserAccountViewModel.shareInstance.account?.userId)!, totalVolume: 0)
        }
    }
    
}

//MARK: - PopMenuDelegate
extension GameplayViewController: PlacePopMenuViewDelegate {
    func cellDidSelected(index: Int, model: AnyObject?) {
        
        

        placeBtn.isSelected = true

        placeIndex = index

        let currentIndex = index
        let itemModel = currentScriptRoleModel?.scriptNodeMapList![currentIndex]
        
        drawImage(model: itemModel)
        let script_role_id = currentScriptRoleModel?.user.scriptRoleId!
        let script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId!
        let mapData = ["user_id":UserAccountViewModel.shareInstance.account?.userId!,"type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id,"status":1,"script_role_id":script_role_id,"game_status_type":"map_see","script_node_map_id":itemModel?.scriptNodeMapId!,"key":UserAccountViewModel.shareInstance.account?.key] as [String : Any]
        
        let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
        SingletonSocket.sharedInstance.socket.write(string: mapJson)
    }
}


//MARK: - UICollectionViewDelegate
extension GameplayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if (gamePlayModel != nil) {
//            let count = gamePlayModel!.scriptRoleList?.count ?? 0
//            return count
//        }
//        return 0
        
        if collectionView == leftCollectionView {
            return leftArr.count
        } else {
            return rightArr.count
        }
        
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        var ownSecretTalkId  = 0
        ownSecretTalkId = currentScriptRoleModel!.secretTalkId!
        
        Log("我加入了3")

        if collectionView == leftCollectionView {
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: GameplayViewCellId, for: indexPath) as! GameplayViewCell
            
            let itemModel = leftArr[indexPath.row] as! GPScriptRoleListModel
            cell.backgroundColor = UIColor.clear
            
            if itemModel.readyOk != nil {
                handsUp = (itemModel.readyOk == 1) ? true : false
            }
            
            
            cell.rightView.isHidden = true
            cell.leftView.isHidden = false
            
            cell.l_avatarImgView.setImageWith(URL(string: itemModel.head!))
            cell.l_nameLabel.text = itemModel.scriptRoleName
            
            if handsUp {
                cell.l_handsUp.isHidden = false
            } else {
                cell.l_handsUp.isHidden = true
            }
            if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId{
                cell.l_avatarImgView.layer.borderColor = HexColor(LightOrangeColor).cgColor
                // 是否有人发起解散申请
                if itemModel.applyDismiss == 1  { // 是
                    dissolveView.isHidden = false
                    dissolveView.votingView.isHidden = false
                    dissolveView.dissolutionView.isHidden = true
                }
            }
            
            
            
            
            
            if ownSecretTalkId == 0  {
                let indexStr = itemModel.secretTalkId!
                if indexStr != 0 {
                    cell.l_miLabel.isHidden = false
                    cell.l_miLabel.text = "密\(indexStr)"
//                    cell.l_comImgView.isHidden = true
                    cell.l_comImgView.image = UIImage(named: "image0")
                    
                } else {
//                    cell.l_comImgView.isHidden = true
                    cell.l_miLabel.isHidden = true
                    cell.l_comImgView.image = UIImage(named: "image0")
                }
                
                if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId {
                    if muteLocalAudioStream {
                        cell.l_comImgView.isHidden = false
                    } else {
                        cell.l_comImgView.isHidden = true
                    }
                }
                
            } else {
                if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId {
                    let indexStr = itemModel.secretTalkId!
                    cell.l_miLabel.isHidden = false
                    cell.l_miLabel.text = "密\(indexStr)"
                    if muteLocalAudioStream {
                        cell.l_comImgView.isHidden = false
                    } else {
                        cell.l_comImgView.isHidden = true
                    }

                } else {
                    if itemModel.secretTalkId! == 0 {
                        cell.l_miLabel.isHidden = true
                        cell.l_comImgView.image = UIImage(named: "image0")
                        cell.l_comImgView.isHidden = false
                    } else {
                        let indexStr = itemModel.secretTalkId!
                        if indexStr == ownSecretTalkId {
                            cell.l_miLabel.isHidden = false
                            cell.l_miLabel.text = "密\(indexStr)"
                            cell.l_comImgView.isHidden = true
                        } else {
                            cell.l_comImgView.image = UIImage(named: "image0")
                            cell.l_comImgView.isHidden = false
                            cell.l_miLabel.isHidden = true
                        }
                        
                    }
                    
                }
            }
            
            return cell
        } else {
            
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: GameplayViewCellId, for: indexPath) as! GameplayViewCell
            
            let itemModel = rightArr[indexPath.row] as! GPScriptRoleListModel
            cell.backgroundColor = UIColor.clear
            
            if itemModel.readyOk != nil {
                handsUp = (itemModel.readyOk == 1) ? true : false
            }
            if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId{
                  cell.r_avatarImgView.layer.borderColor = HexColor(LightOrangeColor).cgColor
                  // 是否有人发起解散申请
                  if itemModel.applyDismiss == 1  { // 是
                      dissolveView.isHidden = false
                      dissolveView.votingView.isHidden = false
                      dissolveView.dissolutionView.isHidden = true
                  }
              }

              cell.r_avatarImgView.setImageWith(URL(string: itemModel.head!))
              cell.rightView.isHidden = false
              cell.leftView.isHidden = true
              cell.r_nameLabel.text = itemModel.scriptRoleName

              if handsUp {
                  cell.r_handsUp.isHidden = false
              } else {
                  cell.r_handsUp.isHidden = true
              }
            
            if ownSecretTalkId == 0  {
                let indexStr = itemModel.secretTalkId!
                if indexStr != 0 {
                    cell.r_miLabel.isHidden = false
                    cell.r_miLabel.text = "密\(indexStr)"
//                    cell.r_comImgView.isHidden = true
                    cell.l_comImgView.image = UIImage(named: "image0")
                } else {
//                    cell.r_comImgView.isHidden = true
                    cell.r_miLabel.isHidden = true
                    cell.l_comImgView.image = UIImage(named: "image0")
                }
                if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId {
                    if muteLocalAudioStream {
                        cell.r_comImgView.isHidden = false
                    } else {
                        cell.r_comImgView.isHidden = true
                    }
                }
            } else {
                if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId {
                    let indexStr = itemModel.secretTalkId!
                    cell.r_miLabel.isHidden = false
                    cell.r_miLabel.text = "密\(indexStr)"
                    if muteLocalAudioStream {
                        cell.r_comImgView.isHidden = false
                    } else {
                        cell.r_comImgView.isHidden = true
                    }

                } else {
                    if itemModel.secretTalkId! == 0 {
                        cell.r_miLabel.isHidden = true
                        cell.r_comImgView.image = UIImage(named: "image0")
                        cell.r_comImgView.isHidden = false
                    } else {
                        let indexStr = itemModel.secretTalkId!
                        if indexStr == ownSecretTalkId {
                            cell.r_miLabel.isHidden = false
                            cell.r_miLabel.text = "密\(indexStr)"
                            cell.r_comImgView.isHidden = true
                        } else {
                            cell.r_comImgView.image = UIImage(named: "image0")
                            cell.r_comImgView.isHidden = false
                            cell.r_miLabel.isHidden = true
                        }
                    }
                }
            }
            

            return cell
        }
        
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if gamePlayModel!.scriptRoleList.isEmpty {
            return
        }
        
        var model = GPScriptRoleListModel(fromDictionary: [ : ])

        if collectionView == leftCollectionView {
            model = leftArr[indexPath.row] as! GPScriptRoleListModel
        } else {
            model = rightArr[indexPath.row] as! GPScriptRoleListModel
        }
        
        
        let playerView = PlayerView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        playerView.itemModel = model
        playerView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(playerView)
    }
    
}


private extension GameplayViewController {


    func getIndexWithUserIsSpeaking(uid: Int) -> Int? {
        let userList = gamePlayModel?.scriptRoleList
        if userList != nil {
            for (index, user) in userList!.enumerated() {
                let userId = user.user?.userId!
                if userId == uid {
                    return index
                }
            }
            return nil
        }
        return nil
    }
    
}



// MARK: - 初始化声网sdk
extension GameplayViewController {
    private func initAgoraKit() {
        // 初始化
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgoraKit_AppId, delegate: self)
        // 将本地播放的所有远端用户音量设置为原始音量的 50
        // 该方法中 volume 参数表示录音信号的音量，取值范围为 [0, 400]：
        // 0: 静音。
        // 100: （默认值）原始音量，即不对信号做缩放。
        // 400: 原始音量的 4 倍（把信号放大到原始信号的 4 倍）。
         agoraKit.adjustPlaybackSignalVolume(400)
        
        // 因为是纯音频多人通话的场景，设置为通信模式以获得更好的音质
        agoraKit.setChannelProfile(.communication)
        // 通信模式下默认为听筒，demo中将它切为外放
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        // 启动音量回调，用来在界面上显示房间其他人的说话音量
        agoraKit.enableAudioVolumeIndication(1000, smooth: 3, report_vad: false)
        // 加入案发现场的群聊频道

        print(String(room_id!))
        
        let uid:UInt = UInt(bitPattern: (UserAccountViewModel.shareInstance.account?.userId!)!)
        agoraKit.joinChannel(byToken: nil, channelId: String(room_id!), info: nil, uid: uid , joinSuccess: nil)
    }
}

// MARK: AgoraRtcEngineDelegate
extension GameplayViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        if agoraStatus.muteAllRemote == true {
            agoraKit.muteAllRemoteAudioStreams(true)
        }
        if agoraStatus.muteLocalAudio == true {
            agoraKit.muteLocalAudioStream(true)
        }
        
        
        Log("我加入了1")
        
//
        // 注意： 1. 由于demo欠缺业务服务器，所以用户列表是根据AgoraRtcEngineDelegate的didJoinedOfUid、didOfflineOfUid回调来管理的
        //       2. 每次加入频道成功后，新建一个用户列表然后通过回调进行统计
//        userList = [UserInfo]()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // 当有用户加入时，添加到用户列表
        // 注意：由于demo缺少业务服务器，所以当观众加入的时候，观众也会被加入用户列表，并在界面的列表显示成静音状态。 正式实现的话，通过业务服务器可以判断是参与游戏的玩家还是围观观众
        
//        let index = getIndexWithUserIsSpeaking(uid: Int(bitPattern: uid))
//        if index != nil {
//            let tureIndex = index! / 2
//            if index! % 2 == 0 {
//                if let cell = leftCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell {
//                    cell.l_comImgView.isHidden = true
//                }
//            } else {
//                if let cell = rightCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell {
//                    cell.r_comImgView.isHidden = true
//                }
//            }
//        }
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        
        if !isJoinCollogueRoom! { // 未加入密聊室
            // 当用户离开时，从用户列表中清除
            if let index = getIndexWithUserIsSpeaking(uid: Int(bitPattern: uid)) {
                let tureIndex = index / 2
                if index % 2 == 0 { // 左边
                    if let cell = leftCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                        cell.l_comImgView.isHidden = false
                        cell.l_comImgView.image = UIImage(named: "leave_icon")
                        cell.l_voiceView.isHidden = true
                        cell.l_voiceImgView.isHidden = true
                        cell.l_animation = false
                    }
                    
                } else {
                    if let cell = rightCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                        cell.r_comImgView.isHidden = false
                        cell.r_comImgView.image = UIImage(named: "leave_icon")
                        cell.r_voiceView.isHidden = true
                        cell.r_voiceImgView.isHidden = true
                        cell.r_animation = false
                    }
                }
                
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        // 当频道里的用户开始或停止发送音频流的时候，会收到这个回调。在界面的用户头像上显示或隐藏静音标记
        
        if let index = getIndexWithUserIsSpeaking(uid: Int(bitPattern: uid)) {
            let tureIndex = index / 2
            if index % 2 == 0 { // 左边
                if let cell = leftCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                    cell.l_comImgView.isHidden = !muted
                    cell.l_comImgView.image = UIImage(named: "image0")
                    cell.l_voiceView.isHidden = muted
                    cell.l_voiceImgView.isHidden = muted
                }
                
            } else {
                if let cell = rightCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                    cell.r_comImgView.isHidden = !muted
                    cell.r_comImgView.image = UIImage(named: "image0")
                    cell.r_voiceView.isHidden = muted
                    cell.r_voiceImgView.isHidden = muted
                }
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        
        // 收到说话者音量回调，在界面上对应的 cell 显示动效

        if muteLocalAudioStream == true { // 禁止本地音频发送
            updateVoice(uid: (UserAccountViewModel.shareInstance.account?.userId)!, totalVolume: 0)
        } else {
            updateVoice(uid: (UserAccountViewModel.shareInstance.account?.userId)!, totalVolume: totalVolume)
        }

        for speaker in speakers {
            updateVoice(uid: Int(speaker.uid), totalVolume: Int(speaker.volume))
        }
    }
    
    // 是不是静音
    private func mute(uid: Int, muted: Bool) {
        if let index = getIndexWithUserIsSpeaking(uid: uid) {
            let tureIndex = index / 2
            if index % 2 == 0 { // 左边
                if let cell = leftCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                    cell.l_comImgView.isHidden = !muted
                    cell.l_comImgView.image = UIImage(named: "image0")
                    cell.l_voiceView.isHidden = muted
                    cell.l_voiceImgView.isHidden = muted
                }
                
            } else {
                if let cell = rightCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                    cell.r_comImgView.isHidden = !muted
                    cell.r_comImgView.image = UIImage(named: "image0")
                    cell.r_voiceView.isHidden = muted
                    cell.r_voiceImgView.isHidden = muted

                }
            }
        }
    }
    
    //MARK:- 根据声音显示头像
    private func updateVoice(uid: Int, totalVolume: Int ) {
        
        
        if let index = getIndexWithUserIsSpeaking(uid: Int(uid)) {
            
            let tureIndex = index / 2
            if index % 2 == 0 { // 左边
                if let cell = leftCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GameplayViewCell {
                    if totalVolume <= 0 {
                        cell.l_voiceView.isHidden = true
                        cell.l_voiceImgView.isHidden = true
                        cell.l_animation = false
                    } else {
                        cell.l_voiceView.isHidden = false
                        cell.l_voiceImgView.isHidden = false
                        cell.l_animation = true
                    }
                }
                  
              } else {
                
                if let cell = rightCollectionView.cellForItem(at: IndexPath(item: tureIndex, section: 0)) as? GameplayViewCell  {
                    
                      
                    if totalVolume <= 0 {
                        cell.r_voiceView.isHidden = true
                        cell.r_voiceImgView.isHidden = true
                        cell.r_animation = false
                    } else {
                        cell.r_voiceView.isHidden = false
                        cell.r_voiceImgView.isHidden = false
                        cell.r_animation = true
                    }
                }
             }
              
        }
        
        
        
//        if let index = getIndexWithUserIsSpeaking(uid: Int(uid)),
//            let cell = leftCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GameplayViewCell {
//
//            if index%2 == 0 {
//                if totalVolume <= 0 {
//                    cell.l_voiceView.isHidden = true
//                    cell.l_voiceImgView.isHidden = true
//                    cell.l_animation = false
//                } else {
//                    cell.l_voiceView.isHidden = false
//                    cell.l_voiceImgView.isHidden = false
//                    cell.l_animation = true
//                }
//
//            } else {
//                if totalVolume <= 0 {
//                    cell.r_voiceView.isHidden = true
//                    cell.r_voiceImgView.isHidden = true
//                    cell.r_animation = false
//                } else {
//                    cell.r_voiceView.isHidden = false
//                    cell.r_voiceImgView.isHidden = false
//                    cell.r_animation = true
//                }
//            }
//        }
    }
    
}



extension GameplayViewController {

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Log(scrollView.contentOffset.x)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        Log(scrollView.contentOffset.x)
    }
}


extension GameplayViewController: WebSocketDelegate {
    
    // initSocket方法
    func initWebSocketSingle () {
        SingletonSocket.sharedInstance.socket.delegate = self
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        Log("gameplay--websocketDidConnect=\(socket)")
        //设置重连次数，解决无限重连问题
        reConnectTime = 0
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
         Log("gameplay--websocketDidDisconnect=\(socket)\(error)")
        
        //执行重新连接方法
        socketReconnect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let dic = getDictionaryFromJSONString(jsonString: text)
        current_client_id = dic["client_id"] as? String
        let datas = getJSONStringFromDictionary(dictionary: ["room_id":room_id as Int])
        if dic["type"] as? String == "init" {
            Log("gameplay--websocketDidReceiveMessage=\(socket)\(text)")

            bindRequest(scene: 1, client_id: current_client_id, datas: datas) { (result, error) in
            }
        } else if (dic["type"] as? String == "game_ing") {
            // 隐藏倒计时
            timerView.isHidden = true
            
            guard  let resultDic :[String : AnyObject] = dic as? [String : AnyObject] else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                Log("gameplay--websocketDidReceiveMessage=\(socket)\(text)")
                
                gamePlayModel = GamePlayModel(fromDictionary: data)
                                
                refreshUI()
                
                if pre_node_type != gamePlayModel?.scriptNodeResult.nodeType {
                    commonBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 19)
                    commonBtn.isUserInteractionEnabled = true
                }
                
                script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
                
                if gamePlayModel?.room.status! == 3  { // 房间已经解散
                    popRootVC()
                }
                
                if gamePlayModel?.scriptNodeResult.nodeType == 4 { // 搜证
                    if currentScriptRoleModel?.user?.point != nil {
                        remainingCount = currentScriptRoleModel!.user!.point!
                    }
                    remainingView.isHidden = false
                    let remainingString = "操作できる回数：\(remainingCount)"
                    let remainingRanStr = String(remainingCount)
                    let remainingAttrstring:NSMutableAttributedString = NSMutableAttributedString(string:remainingString)
                    let remainingStr = NSString(string: remainingString)
                    let remainingTheRange = remainingStr.range(of: remainingRanStr)
                    remainingAttrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor(LightOrangeColor), range: remainingTheRange)
                    remainingLabel.attributedText = remainingAttrstring
                    
                    if remainingCount == 0 {
                        CLToastManager.share.cornerRadius = 15
                        CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
                        CLToast.cl_show(msg: "あなたの捜査できる回数はすでになくなりました")
                    }
                }
                
                if gamePlayModel?.scriptNodeResult.nodeType == 5 && currentScriptRoleModel?.readyOk == 0 { // 答题
                    if currentScriptRoleModel?.scriptQuestionList?.count != 0 {
                                        
                        commonQuestionView.isHidden = false
                        commonQuestionView.room_id = room_id
                        commonQuestionView.script_node_id = script_node_id
                        commonQuestionView.scriptQuestionList = currentScriptRoleModel?.scriptQuestionList
                        
                        
                        // 答题 触发倒计时
                        gameCountdownRequest(room_id: room_id, script_node_id: script_node_id!) { (result, error) in
                            if error != nil {
                                return
                            }
                            // 取到结果
                            guard  let resultDic :[String : AnyObject] = result else { return }
                            if resultDic["code"]!.isEqual(1) {
                        
                            }
                            
                        }
                    }
                } else {
                    commonQuestionView.isHidden = true
                }
                
                
                if gamePlayModel?.scriptNodeResult.nodeType == 6 {
//                    commonQuestionView.isHidden = true
                    voteInfoBtn.isHidden = false
                    voteResultBtn.isHidden = false
                }
            }
        } else if (dic["type"] as? String == "room_ready") {
            
            
        } else if (dic["type"] as? String == "game_countdown") { // 倒计时
            timerView.isHidden = false
            guard  let resultDic :[String : AnyObject] = dic as? [String : AnyObject] else { return }
            if resultDic["code"]!.isEqual(1) {
                
                let data = resultDic["data"] as! [String : AnyObject]
                
//                Log("gameplay--websocketDidReceiveMessage=\(socket)\(data)")
                
                let count = data["countdown"] as! Int
                if count == 0 {
                    timerView.isHidden = true
                    commonQuestionView.countLabel.isHidden = true
                }
                
                let string = "カウントダウン\(count)s"
                let ranStr = "\(count)s"
                let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
                let str = NSString(string: string)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#ED2828"), range: theRange)
                
                if gamePlayModel?.scriptNodeResult.nodeType == 5 {
                    
                    let string = "カウントダウン：\(count)s"
                    let ranStr = "\(count)s"
                    let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
                    let str = NSString(string: string)
                    let theRange = str.range(of: ranStr)
                    attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#666666"), range: theRange)
                    
                    commonQuestionView.countLabel.isHidden = false
                    commonQuestionView.countLabel.textColor = HexColor(LightDarkGrayColor)
                    commonQuestionView.countLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                    timerView.isHidden = true
                    commonQuestionView.countLabel.attributedText = attrstring

                } else {
                    commonQuestionView.countLabel.isHidden = true
                    timerView.isHidden = false
                    timerLabel.attributedText = attrstring
                }
            }
            
        }


    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        Log("gameplay--websocketDidReceiveData=\(socket)\(data)")
    }

}

