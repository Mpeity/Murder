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
    private var tipView: FETipView!
    
    // 中间布局
    // 地点名称
    private var placeBtn: UIButton = UIButton()
    // 地点弹框
    private var popMenuView = PopMenuView()
    
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
    var commonBtn: UIButton = UIButton()
    
    // 举手
    var handsUp = false
    
    var voiceHide = false
    
    var node_type: Int? = 0
    // 当前id
    var script_node_id: Int? = 0
    // 我的id
    var script_role_id : Int!
    // 发起解散
    var dissolveView = DissolveView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
    // 剧本阅读
    var readScriptView = ReadScriptView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
    
    // 纪录自己的位置
    var ownIndex: Int? = -1
    
    private lazy var collectionView: UICollectionView = {
        
           
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical     //滚动方向
        // 行间距
        layout.minimumLineSpacing = 20
        // 列间距
        layout.minimumInteritemSpacing = (FULL_SCREEN_WIDTH-120*2)
        
        layout.itemSize = CGSize(width: 90, height: 76)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15,  bottom: 0, right: 15)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 50+NAVIGATION_BAR_HEIGHT, width: FULL_SCREEN_WIDTH, height: 100), collectionViewLayout: layout)
        
        collectionView.register(UINib(nibName: "GameplayViewCell", bundle: nil), forCellWithReuseIdentifier: GameplayViewCellId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    var userList: Array = ["かごめ","サクラ","こはく","コナン","さんご"]
    
    var imageList: Array = ["image0","image1","image2","image3","image4"]

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWebSocketSingle()
        
        initAgoraKit()
        
        setUI()
        
//        getiPhoneBatteryState()
        
        gamePlaying()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userLogout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        
        let size =  collectionView.collectionViewLayout.collectionViewContentSize
        
        let count = gamePlayModel!.scriptRoleList?.count ?? 0
        
        let one = count / 2
        
        let two = count % 2
        
        collectionView.frame = CGRect(x: 0, y: 50+NAVIGATION_BAR_HEIGHT, width: FULL_SCREEN_WIDTH, height: CGFloat(96 * (one + two)))
        collectionView.reloadData()
        
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
        // 绘制地图
        if currentScriptRoleModel?.scriptNodeMapList != nil {
            Log("这里有图片吗------1")
            let model = currentScriptRoleModel?.scriptNodeMapList?[0]
            drawImage(model: model)
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
        
        if gamePlayModel?.scriptNodeResult.description != nil {
            preference.drawing.message = gamePlayModel?.scriptNodeResult!.describe as! String
        }
        
        
        if currentScriptRoleModel?.scriptNodeMapList != nil {
            popMenuView.type = "place"
            popMenuView.titleArray = (currentScriptRoleModel?.scriptNodeMapList!)! as [AnyObject]
            popMenuView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(placeBtn.snp.bottom).offset(5)
                make.height.equalTo(55*popMenuView.titleArray.count)
                make.width.equalTo(136)
            }
        }
        
        // 更新 剧本小红点
        if currentScriptRoleModel?.chapter != nil {
            readScriptView.scriptData = currentScriptRoleModel?.chapter
        }
        
        //
        let mapList = currentScriptRoleModel?.scriptNodeMapList!
        if mapList != nil {
            for item in mapList! {
                let mapId = item.scriptNodeMapId
                switch mapId {
                case 1: // 背景地图
                    if item.see == 0 {
                        hideRedPoint(commonView: placeBtn)
                    } else {
                        addRedPoint(commonView: placeBtn, x: 30, y: 5)
                    }
                    
                    break
                case 2: // 自我介绍地图
                    if item.see == 0 {
                        
                    } else {
                        
                    }
                    break
                case 3: // 剧本阅读
                    if item.see == 0 {
                        addRedPoint(commonView: scriptBtn, x: 30, y: 5)
                    } else {
                        hideRedPoint(commonView: scriptBtn)
                    }
                    break
                case 4: // 搜证
                    if item.see == 0 {
                        addRedPoint(commonView: threadBtn, x: 30, y: 5)
                    } else {
                        hideRedPoint(commonView: threadBtn)
                    }
                    break
                    
                case 5: // 答题
                    if item.see == 0 {
                        
                    } else {
                        
                    }
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    //MARK:- 绘制地图
    func drawImage(model: GPNodeMapListModel?) {
        guard let imagePath = getImagePathWith(attachmentId: (model?.attachmentId!)!) else { return }
            let image = UIImage(contentsOfFile: imagePath)
        
            Log("这里有图片------6\(image!)")
        
            let height = FULL_SCREEN_HEIGHT
            let scale = CGFloat(FULL_SCREEN_HEIGHT / (image?.size.height)!)
            let width = (image?.size.width)! * scale
            
            let newSize = CGSize(width: width, height: height)
            
            let newImage = imageWithImage(image: image!, size: newSize)
            
            let size = newImage.size

            bgImgView.size = size
            scrollView.contentSize = bgImgView.bounds.size
            bgImgView.image = newImage
            bgImgView.sizeToFit()
                        
            drawImagesButtons(mapModel: model!, orignalSize: (image?.size)!)
            
            placeBtn.setTitle(model?.name, for: .normal)
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
    
    
    private func setUI() {
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        self.view.addSubview(scrollView)
        bgImgView.frame = CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT)
        self.scrollView.addSubview(bgImgView)

        
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
//        self.view.addSubview(readScriptView)
    }
    
    /// 添加红点
    private func addRedPoint(commonView: UIView, x: CGFloat, y: CGFloat) {
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
        let point = self.view.viewWithTag(1234)
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
            make.width.equalTo(100)
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
        
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 地点名称按钮
        self.view.addSubview(placeBtn)
        placeBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerBgView.snp.bottom).offset(5)
            make.height.equalTo(21)
            make.width.equalTo(86)

        }
        placeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        placeBtn.setBackgroundImage(UIImage(named: "gameplay_place"), for: .normal)
        placeBtn.addTarget(self, action: #selector(palceBtnAction(button:)), for: .touchUpInside)
        addRedPoint(commonView: placeBtn, x: 64, y: 1.5)
        
        
        self.view.addSubview(popMenuView)
        popMenuView.type = "place"
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
        let remainingString = "カウントダウン：\(remainingCount)"
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

        
        // 游戏玩家列表
        for (index, item) in userList.enumerated() {

            var position: Position!
            var marginx = 15.5
            var count = 0
            if index%2 == 0 {
                position = .left
                marginx = 15.5
                count = index/2
            } else {
                position = .right
                marginx = Double(FULL_SCREEN_WIDTH-44-15.5)
                count = index/2

            }



            
            let userView = UIView(position: position, oneself: false, imageName: imageList[index], title: item, handsUp: false, isSpeaking: false, isCollogue: false)
            let width = 90
            let height = 65
            userView.frame = CGRect(x: Int(CGFloat(marginx)), y: 200+(20+height)*Int(CGFloat(count)), width: width, height: height)
            userView.isUserInteractionEnabled = true

            let tap = UITapGestureRecognizer(target: self, action: #selector(userViewTap(user:)))
            userView.addGestureRecognizer(tap)
//            self.view.addSubview(userView)
            

            
            
           let itemCell = GameplayViewCell(frame: CGRect(x: Int(CGFloat(marginx)), y: 200+(20+height)*Int(CGFloat(count)), width: width, height: height))
            self.view.addSubview(itemCell)

        }
        

        
        
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
        microphoneBtn.createButton(style: .top, spacing: 5, imageName: "gameplay_microphone", title: "マイク", cornerRadius: 25, color: "#20014D")
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
        addRedPoint(commonView: scriptBtn, x: 30, y: 5)
        
        
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
        commonBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 19)

        commonBtn.addTarget(self, action: #selector(commonBtnAction(button:)), for: .touchUpInside)
        
    }
    
}

// MARK: - 按钮响应事件
extension GameplayViewController {
    
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
        remainingView.isHidden = false
//        remainingCount -= 1
        let remainingString = "カウントダウン：\(remainingCount)"
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
        SVProgressHUD.show(withStatus: "加载中")
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
//                let threadCardView = ThreadCardView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                let threadCardView = ThreadNewCardView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                threadCardView.clueResultModel = clueResultModel
                threadCardView.script_place_id = script_place_id
                threadCardView.room_id = self!.room_id
                threadCardView.script_node_id = self!.script_node_id
                
                threadCardView.deepBtnActionBlock = {[weak self] (param)->() in
                }
                
                threadCardView.publicBtnActionBlock = {[weak self] (param)->() in
//                    self!.publicClue(model: param, script_place_id: script_place_id)
//                    threadCardView.removeFromSuperview()
                }
                
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
        
        SingletonSocket.sharedInstance.socket.disconnect()
    }
    
    //MARK: 退出房间
    private func popRootVC() {
        userLogout()
        self.navigationController?.popToRootViewController(animated: true)
        return
    }
    
    //MARK: 消息按钮
    @objc func messageBtnAction(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //
    //MARK: 阶段说明弹框
    @objc func stateBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
        preference.drawing.backgroundColor = UIColor.white
        preference.drawing.textColor = HexColor(LightDarkGrayColor)
        preference.positioning.targetPoint = CGPoint(x: button.center.x, y: button.frame.maxY+55)
        preference.drawing.maxTextWidth = 231*SCALE_SCREEN
        preference.drawing.maxHeight = 208
        preference.positioning.marginLeft = 16
        preference.drawing.textAlignment = .left
        preference.animating.shouldDismiss = false
        if button.isSelected {
            tipView = FETipView(preferences: preference)
            tipView.show()
        } else {
            tipView.dismiss()
        }
//        if button.isSelected {
//            UIView.animate(withDuration: 0.5) {
//                self.stateTipView.isHidden = false
//            }
//        } else {
//            UIView.animate(withDuration: 0.5) {
//                self.stateTipView.isHidden = true
//            }
//        }
    }
    
    
    //MARK: 地点名称按钮
    @objc func palceBtnAction(button: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        button.isSelected = !button.isSelected
        if button.isSelected {
            popMenuView.isHidden = false
        } else {
            popMenuView.isHidden = true

        }
    }
    
    
    /// 底部按钮
    //MARK: 麦克风
    @objc func microphoneBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
        agoraKit.muteLocalAudioStream(button.isSelected)
        if button.isSelected {
            microphoneBtn.setImage(UIImage(named: "gameplay_microphone_no"), for: .normal)
            microphoneBtn.setTitleColor(HexColor("#999999"), for: .normal)
            voiceHide = false
        } else {
            microphoneBtn.setImage(UIImage(named: "gameplay_microphone"), for: .normal)
            microphoneBtn.setTitleColor(UIColor.white, for: .normal)
            voiceHide = true
        }
        collectionView.reloadData()
    }
    
    //MARK: 剧本
    @objc func scriptBtnAction(button: UIButton) {
        if currentScriptRoleModel?.chapter?.count != 0{
            
            if !self.view.subviews.contains(readScriptView) {
                self.view.addSubview(readScriptView)
            }
            readScriptView.isHidden = false
            readScriptView.type = "script"
            readScriptView.scriptData = currentScriptRoleModel?.chapter
            readScriptView.room_id = gamePlayModel?.room.roomId
            readScriptView.script_role_id = gamePlayModel?.scriptNodeResult.myRoleId
            readScriptView.script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
        }
    }
    
    //MARK: 线索
    @objc func threadBtnBtnAction(button: UIButton) {
        if currentScriptRoleModel?.gameUserClueList?.count != 0 {
           let threadView = ThreadView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
           
           threadView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
           threadView.script_role_id = gamePlayModel?.scriptNodeResult.myRoleId
            
            threadView.room_id = gamePlayModel?.room.roomId
            threadView.script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
            threadView.gameUserClueList = currentScriptRoleModel?.gameUserClueList
           self.view.addSubview(threadView)
        }

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
        
        script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
        
        if gamePlayModel?.scriptNodeResult.nodeType == 5 && currentScriptRoleModel?.readyOk == 0 { // 答题
            if currentScriptRoleModel?.scriptQuestionList?.count != 0 {
                self.view.addSubview(commonQuestionView)
                commonQuestionView.room_id = room_id
                commonQuestionView.script_node_id = script_node_id
                commonQuestionView.scriptQuestionList = currentScriptRoleModel?.scriptQuestionList
                commonQuestionView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                
                
                
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
        
        gameReadyRequest(role_id: (gamePlayModel?.scriptNodeResult.myRoleId)!, room_id: room_id, current_script_node_id: script_node_id!) {[weak self] (result, error) in
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
}

//MARK:- 密谈
extension GameplayViewController: CollogueRoomViewDelegate {
    // 进入密谈室
    func commonBtnTapAction(index: Int) {
        
        isJoinCollogueRoom = true
        
        let channelId = "\(room_id!)_" + "chat\(index+1)"
        
        // 纪录自己加入的密谈室
        
        // 加入私聊频道
        agoraKit.leaveChannel(nil)
        let uid = UserAccountViewModel.shareInstance.account?.userId
        agoraKit.joinChannel(byToken: nil, channelId: channelId, info: nil, uid: UInt(bitPattern: uid!), joinSuccess: nil)
        
        let script_role_id = currentScriptRoleModel?.user.scriptRoleId
        let secret_talk_id = index+1
        let mapData = ["type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":1,"script_role_id":script_role_id!,"secret_talk_id":secret_talk_id,"game_status_type":"secret_talk","key":(UserAccountViewModel.shareInstance.account?.key!)! as String] as [String : AnyObject]
        
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
        let mapData = ["type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":0,"script_role_id":script_role_id!,"secret_talk_id":secret_talk_id,"game_status_type":"secret_talk","key":(UserAccountViewModel.shareInstance.account?.key!)! as String] as [String : AnyObject]
        
        let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
        SingletonSocket.sharedInstance.socket.write(string: mapJson)
        
        
        
        
        agoraKit.leaveChannel(nil)
        // 离开密谈 重新至回游戏中
        agoraKit.delegate = self
        // 通信模式下默认为听筒，demo中将它切为外放
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)

        // 从私聊返回案发现场时，重新加入案发现场的群聊频道
        let uid:UInt = UInt(bitPattern: (UserAccountViewModel.shareInstance.account?.userId!)!)
        agoraKit.joinChannel(byToken: nil, channelId: String(room_id!), info: nil, uid: uid , joinSuccess: nil)

    }
    
}

//MARK: - PopMenuDelegate
extension GameplayViewController: PopMenuViewDelegate {
    func cellDidSelected(index: Int, model: AnyObject?) {
        let currentIndex = index
//        let itemModel = gamePlayModel?.scriptNodeResult.scriptNodeMapList![currentIndex]
        let itemModel = currentScriptRoleModel?.scriptNodeMapList![currentIndex]
        
        drawImage(model: itemModel)
        let script_role_id = gamePlayModel?.scriptNodeResult.myRoleId!
        let script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId!
        let mapData = ["type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id,"status":1,"script_role_id":script_role_id,"game_status_type":"map_see","script_node_map_id":itemModel?.scriptNodeMapId!,"key":UserAccountViewModel.shareInstance.account?.key] as [String : Any]
        
        let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
        SingletonSocket.sharedInstance.socket.write(string: mapJson)
    }
}


//MARK: - UICollectionViewDelegate
extension GameplayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (gamePlayModel != nil) {
            let count = gamePlayModel!.scriptRoleList?.count ?? 0
            return count
        }
        return 0
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: GameplayViewCellId, for: indexPath) as! GameplayViewCell
        
        let itemModel = gamePlayModel!.scriptRoleList[indexPath.row]
        cell.backgroundColor = UIColor.clear
        
        if itemModel.readyOk != nil {
            handsUp = (itemModel.readyOk == 1) ? true : false
        }
        if indexPath.item%2 == 0 {
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
           
        } else {
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
        }
        var ownSecretTalkId  = 0
        ownSecretTalkId = currentScriptRoleModel!.secretTalkId!
        
        if ownSecretTalkId == 0 { // 未进入密聊室
            let indexStr = itemModel.secretTalkId!
            if indexPath.item%2 == 0 {
                if indexStr != 0 {
                     cell.l_miLabel.isHidden = false
                     cell.l_miLabel.text = "密\(indexStr)"
                     cell.l_comImgView.isHidden = true
                 } else {
                     cell.l_comImgView.isHidden = true
                     cell.l_miLabel.isHidden = true
                 }
            } else {
                if indexStr != 0 {
                    cell.r_miLabel.isHidden = false
                    cell.r_miLabel.text = "密\(indexStr)"
                    cell.r_comImgView.isHidden = true
                } else {
                    cell.r_comImgView.isHidden = true
                    cell.r_miLabel.isHidden = true
                }
            }

        } else {
            // 自己在左边还是右边
            if ownIndex! % 2 == 0 { // 左边
                if indexPath.item%2 == 0 {
                    if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId {
                        let indexStr = itemModel.secretTalkId!
                        cell.l_miLabel.isHidden = false
                        cell.l_miLabel.text = "密\(indexStr)"
                        cell.l_comImgView.isHidden = true

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
                
            } else {
                if indexPath.item%2 != 0 {
                    if UserAccountViewModel.shareInstance.account?.userId ==  itemModel.user?.userId {
                        let indexStr = itemModel.secretTalkId!
                        cell.r_miLabel.isHidden = false
                        cell.r_miLabel.text = "密\(indexStr)"
                        cell.r_comImgView.isHidden = true

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
        }
        
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if gamePlayModel!.scriptRoleList.isEmpty {
            return
        }
        let model = gamePlayModel!.scriptRoleList[indexPath.row]
        
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
//
        // 注意： 1. 由于demo欠缺业务服务器，所以用户列表是根据AgoraRtcEngineDelegate的didJoinedOfUid、didOfflineOfUid回调来管理的
        //       2. 每次加入频道成功后，新建一个用户列表然后通过回调进行统计
//        userList = [UserInfo]()
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // 当有用户加入时，添加到用户列表
        // 注意：由于demo缺少业务服务器，所以当观众加入的时候，观众也会被加入用户列表，并在界面的列表显示成静音状态。 正式实现的话，通过业务服务器可以判断是参与游戏的玩家还是围观观众
        
        let index = getIndexWithUserIsSpeaking(uid: Int(bitPattern: uid))
        if index != nil {
            let cell = collectionView.cellForItem(at: IndexPath(item: index!, section: 0)) as? GameplayViewCell
            if index! % 2 == 0 {
                cell?.l_comImgView.isHidden = true
            } else {
                cell?.r_comImgView.isHidden = true
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        
        if !isJoinCollogueRoom! { // 未加入密聊室
            // 当用户离开时，从用户列表中清除
            if let index = getIndexWithUserIsSpeaking(uid: Int(bitPattern: uid)),
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GameplayViewCell {
                
                if index % 2 == 0 {
                    cell.l_comImgView.isHidden = false
                    cell.l_comImgView.image = UIImage(named: "leave_icon")
                    cell.l_voiceView.isHidden = true
                    cell.l_voiceImgView.isHidden = true
                    cell.l_animation = false
                } else {
                    cell.r_comImgView.isHidden = false
                    cell.r_comImgView.image = UIImage(named: "leave_icon")
                    cell.r_voiceView.isHidden = true
                    cell.r_voiceImgView.isHidden = true
                    cell.r_animation = false
                }
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        // 当频道里的用户开始或停止发送音频流的时候，会收到这个回调。在界面的用户头像上显示或隐藏静音标记
        
        if let index = getIndexWithUserIsSpeaking(uid: Int(bitPattern: uid)),
        let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GameplayViewCell {
            if index%2 == 0 {
               cell.l_comImgView.isHidden = !muted
               cell.l_comImgView.image = UIImage(named: "image0")
               cell.l_voiceView.isHidden = muted
               cell.l_voiceImgView.isHidden = muted
            } else {
               cell.r_comImgView.isHidden = !muted
               cell.r_comImgView.image = UIImage(named: "image0")
               cell.r_voiceView.isHidden = muted
               cell.r_voiceImgView.isHidden = muted
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        // 收到说话者音量回调，在界面上对应的 cell 显示动效
        
        guard let speakers = gamePlayModel?.scriptRoleList else {
            return
        }
        for speaker in speakers {
            if speaker.user == nil {
                continue
            }
            if let index = getIndexWithUserIsSpeaking(uid: (speaker.user?.userId)!),
                let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? GameplayViewCell {
                if index%2 == 0 {
                    if totalVolume == 0 {
                        cell.l_voiceView.isHidden = true
                        cell.l_voiceImgView.isHidden = true
                        cell.l_animation = false
                    } else {
                        cell.l_voiceView.isHidden = false
                        cell.l_voiceImgView.isHidden = false
                        cell.l_animation = true
                    }

                } else {
                    if totalVolume == 0 {
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
    }
}

extension GameplayViewController {
    // contentOffSet属性 点击按钮,移动图片
    @objc func didOffSetBtn(sender: UIButton) {
        var scrollOffSet:CGPoint = scrollView.contentOffset
        scrollOffSet.x += 50
        scrollOffSet.y += 50
        
        UIView.animate(withDuration: 1.0) {
            self.scrollView.contentOffset = scrollOffSet
        }
//        // UIScrollView自带的动画
//        scrollView.setContentOffset(scrollOffSet, animated: true)
    }
    
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
                
                script_node_id = gamePlayModel?.scriptNodeResult.scriptNodeId
                
                if gamePlayModel?.room.status! == 3  { // 房间已经解散
                    showToastCenter(msg: "房间已解散!")
                    popRootVC()
                }
                
                if gamePlayModel?.scriptNodeResult.nodeType == 5 && currentScriptRoleModel?.readyOk == 0 { // 答题
                    if currentScriptRoleModel?.scriptQuestionList?.count != 0 {
                    
                        self.view.addSubview(commonQuestionView)
                        commonQuestionView.room_id = room_id
                        commonQuestionView.script_node_id = script_node_id
                        commonQuestionView.scriptQuestionList = currentScriptRoleModel?.scriptQuestionList
                        commonQuestionView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                        
                        
                        
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
                }
                if gamePlayModel?.scriptNodeResult.nodeType == 6 {
                    commonQuestionView.isHidden = true
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
                
                Log("gameplay--websocketDidReceiveMessage=\(socket)\(data)")
                
                let count = data["countdown"] as! Int
                if count == 0 {
                    timerView.isHidden = true
                    commonQuestionView.countLabel.isHidden = true
                }
                
                let string = "カウントダウン\(count)s"
                let ranStr = String(count)
                let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
                let str = NSString(string: string)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#ED2828"), range: theRange)
                
                if gamePlayModel?.scriptNodeResult.nodeType == 5 {
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

