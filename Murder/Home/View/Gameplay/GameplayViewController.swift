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
//import AgoraRtcKit

 let AppId = "26527026d3744a2888d47bbf3afa42b0"

private let GameplayViewCellId = "GameplayViewCellId"
private let crimeChannelId = "crime"

class GameplayViewController: UIViewController {
    
    // 滑动视图
    @IBOutlet weak var scrollView: UIScrollView!
    // 背景图片
    @IBOutlet weak var bgImgView: UIImageView!
    
        // AgoraRtcEngineKit 入口类
    //    var agoraKit: AgoraRtcEngineKit!
    
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
    
//    // 阶段说明
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
    private var timer: Timer?
    private var timerView = UIView()
    private var timerLabel = UILabel()
    private var timerCount = 600
    
    // 剩余次数
    private var remainingView = UIView()
    private var remainingLabel = UILabel()
    private var remainingCount = 5
    
    
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
    // 未知按钮名称
    var commonBtn: UIButton = UIButton()
    
    // 阶段
    var stage = 1
    
    // 举手
    var handsUp = false
    
    var voiceHide = false
    
    
    private lazy var collectionView: UICollectionView = {
        
           
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical     //滚动方向
        // 行间距
        layout.minimumLineSpacing = 20
        // 列间距
        layout.minimumInteritemSpacing = (FULL_SCREEN_WIDTH-120*2)
        
        layout.itemSize = CGSize(width: 90, height: 76)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15,  bottom: 0, right: 15)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 50+NAVIGATION_BAR_HEIGHT, width: FULL_SCREEN_WIDTH, height: 300), collectionViewLayout: layout)
        
        collectionView.register(UINib(nibName: "GameplayViewCell", bundle: nil), forCellWithReuseIdentifier: GameplayViewCellId)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
//    "zhangshan","lisi","wangwu","zhaoliu"
//    ["かごめ","サクラ","こはく","コナン","さんご","サクラ","こはく","コナン","さんご"]
    var userList: Array = ["かごめ","サクラ","こはく","コナン","さんご"]
    
//    ["image0","image1","image2","image3","image4","image5","image6","image7","image8"]
    var imageList: Array = ["image0","image1","image2","image3","image4"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        initAgoraKit()
        

        setUI()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        navigationController?.navigationBar.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }

}



// MARK: - setUI
extension GameplayViewController {
    private func setUI() {
        
        scrollView.contentSize = bgImgView.bounds.size
        bgImgView.sizeToFit()
        
        setHeaderView()
        setMiddleView()
        setBottomView()
        
    }
    
    /// 添加红点
    private func addRedPoint(commonView: UIView, x: CGFloat, y: CGFloat) {
        let point = UIView()
        commonView.addSubview(point)
        point.backgroundColor = HexColor("#ED2828")
        point.layer.cornerRadius = 3.5
        point.snp.makeConstraints { (make) in
            make.width.height.equalTo(7)
            make.left.equalToSuperview().offset(x)
            make.top.equalToSuperview().offset(y)
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
        electricityView.backgroundColor = UIColor.green
        electricityView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12.5)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(25)
            make.height.equalTo(10)
        }
                
        
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
        placeBtn.setTitle("平凡な旅館", for: .normal)
        placeBtn.setBackgroundImage(UIImage(named: "gameplay_place"), for: .normal)
        placeBtn.addTarget(self, action: #selector(palceBtnAction(button:)), for: .touchUpInside)
        addRedPoint(commonView: placeBtn, x: 64, y: 1.5)
        
        
        
        self.view.addSubview(popMenuView)
        popMenuView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeBtn.snp.bottom).offset(5)
            make.height.equalTo(175)
            make.width.equalTo(136)
        }
        popMenuView.imageName = "menu_catalogue_white"
        popMenuView.cellRowHeight = 55
        popMenuView.isHideImg = true
        popMenuView.lineColor = HexColor(hex:"#333333", alpha: 0.05)
        popMenuView.contentTextColor = HexColor("#999999")
        popMenuView.contentTextFont = 15
        popMenuView.titleArray = ["平凡な旅館","川辺の","大橋"]
        popMenuView.refresh()
        popMenuView.isHidden = true
        
        
        
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
        let string = "カウントダウン\(timerCount)s"
        let ranStr = String(timerCount)
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
        let str = NSString(string: string)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#ED2828"), range: theRange)
        timerLabel.attributedText = attrstring
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
        
        
        // 搜查
//        self.view.addSubview(searchImgView)
        self.view.insertSubview(searchImgView, aboveSubview: collectionView)
        searchImgView.isUserInteractionEnabled = true
        searchImgView.image = UIImage(named: "ceshi_icon")
        searchImgView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
            make.width.equalTo(180)
            make.centerX.equalToSuperview()
            make.top.equalTo(placeBtn.snp_bottom).offset(210*SCALE_SCREEN)
        }
        searchImgView.isHidden = true
        
        searchBtn.setImage(UIImage(named: "soucha_icon"), for: .normal)
        self.view.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.width.equalTo(43)
            make.top.equalTo(searchImgView.snp_top).offset(-16)
            make.left.equalTo(searchImgView.snp_left)
        }
        searchBtn.addTarget(self, action: #selector(searchBtnAction), for: .touchUpInside)
        searchBtn.isHidden = true

        
        emptyBtn.setImage(UIImage(named: "yikong_icon"), for: .normal)
        searchImgView.addSubview(emptyBtn)
        emptyBtn.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.width.equalTo(43)
            make.top.equalToSuperview().offset(104)
            make.left.equalToSuperview().offset(92)
        }
        emptyBtn.addTarget(self, action: #selector(emptyBtnAction), for: .touchUpInside)
        emptyBtn.isHidden = true
        
        
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
        addRedPoint(commonView: threadBtn, x: 30, y: 5)

        
        
        // 密谈按钮
        bgView.addSubview(collogueBtn)
        collogueBtn.snp.makeConstraints { (make) in
            make.left.equalTo(threadBtn.snp.right).offset(7)
            make.top.equalToSuperview()
            make.size.equalTo(50)
        }
        collogueBtn.createButton(style: .top, spacing: 5, imageName: "gameplay_collogue", title: "密談", cornerRadius: 25, color: "#20014D")
        collogueBtn.addTarget(self, action: #selector(collogueBtnAction(button:)), for: .touchUpInside)
        
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
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(commonView)
    }
    
    //MARK: - 情报结算
    @objc func voteInfoBtnAction() {
        let commonView = BillingInfoView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(commonView)
        
    }
    
    
    //MARK: - 倒计时
    @objc func countDown() {
        timerCount -= 1
        let string = "カウントダウン\(timerCount)s"
        let ranStr = String(timerCount)
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
        let str = NSString(string: string)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor("#ED2828"), range: theRange)
        timerLabel.attributedText = attrstring
        if timerCount == 0 {
            // 进入下一个阶段
            timerCount = 0
            timer?.invalidate()
            timerView.isHidden = false
            
        }
        
    }
    
    //MARK: - 搜查
    @objc func searchBtnAction() {
        remainingView.isHidden = false
        remainingCount -= 1
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
    
    //MARK: - 已空
    @objc func emptyBtnAction() {
        CLToastManager.share.cornerRadius = 25
        CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
        CLToast.cl_show(msg: "捜査できる手掛かりはありません")
    }
    
    
    
    /// 头部按钮
    // 退出房间按钮
    @objc func exitBtnAction(button: UIButton) {
        let dissolveView = DissolveView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        dissolveView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        dissolveView.dissolutionBtnTapBlcok = {[weak self] () in
            let vc = ScriptDetailsViewController()
//            self?.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
        self.view.addSubview(dissolveView)
    }
    
    // 消息按钮
    @objc func messageBtnAction(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //
    // 阶段说明弹框
    @objc func stateBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
        preference.drawing.backgroundColor = UIColor.white
        preference.drawing.textColor = HexColor(LightDarkGrayColor)
        preference.positioning.targetPoint = CGPoint(x: button.center.x, y: button.frame.maxY+55)
        preference.drawing.maxTextWidth = 231*SCALE_SCREEN
        preference.drawing.maxHeight = 208
        preference.positioning.marginLeft = 16
        preference.drawing.textAlignment = .left
        preference.drawing.message = "段階説明文字段階説明文字,段階説明文字段階説明文字段階。段階説明文字段階説明文字,段階説明文字段階説明文字段階。"
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
    
    
    // 地点名称按钮
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
    // 麦克风
    @objc func microphoneBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
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
    
    // 剧本
    @objc func scriptBtnAction(button: UIButton) {
        let readScriptView = ReadScriptView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        readScriptView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(readScriptView)
        
    }
    
    // 线索
    @objc func threadBtnBtnAction(button: UIButton) {
        let threadView = ThreadView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        threadView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(threadView)
    }
    
    
    //MARK:- 密谈
    @objc func collogueBtnAction(button: UIButton) {
        let collogueRoomView = CollogueRoomView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        collogueRoomView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)        
        self.view.addSubview(collogueRoomView)
        
    }
    
    // 系统配置未知按钮
    @objc func commonBtnAction(button: UIButton) {
        
        switch stage {
        case 1:
            // 点击进入下一个阶段
            timerView.isHidden = false
            timer?.fire()
            handsUp = true
            collectionView.reloadData()
            stage += 1
            break
        case 2:
//            handsUp = false

            timerCount = 0
            timerView.isHidden = true
            timer?.invalidate()
            // 阅读剧本
            stage += 1
            break
        case 3:
            // 搜证
            searchImgView.isHidden = false
            emptyBtn.isHidden = false
            searchBtn.isHidden = false
            stage += 1
            break
        case 4:
            // 投票
            let commonView = QuestionView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            self.view.addSubview(commonView)
            stage += 1
            break
        case 5:
//            let commonView = BillingInfoView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
//            commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
//            self.view.addSubview(commonView)
            
            remainingView.isHidden = true
            voteInfoBtn.isHidden = false
            voteResultBtn.isHidden = false
            break
            
        default:
            break
        }

        
        
        
    }
    
    // 点击头像
    @objc func userViewTap(user: Any) {
 
        let playerView = PlayerView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        playerView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(playerView)
    }
    
    
    
    // contentOffSet属性 点击按钮,移动图片
    func didOffSetBtn(sender: UIButton) {
        var scrollOffSet:CGPoint = scrollView.contentOffset
        scrollOffSet.x += 50
        scrollOffSet.y += 50
        
        UIView.animate(withDuration: 1.0) {
            self.scrollView.contentOffset = scrollOffSet
        }
//        // UIScrollView自带的动画
//        scrollView.setContentOffset(scrollOffSet, animated: true)
    }
}


extension GameplayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameplayViewCellId, for: indexPath) as! GameplayViewCell
//        cell.titleLabel.text = dataArr[indexPath.item]
//        if (selectIndexPath == indexPath) {
//            cell.titleLabel.textColor = UIColor.white
//            cell.commonView.backgroundColor = HexColor(MainColor)
//            cell.layer.cornerRadius = 10
//        } else {
//            cell.titleLabel.textColor = HexColor(LightDarkGrayColor)
//            cell.commonView.backgroundColor = UIColor.white
//        }
        
        cell.backgroundColor = UIColor.clear
        if indexPath.item%2 == 0 {
            cell.rightView.isHidden = true
            cell.leftView.isHidden = false
            cell.l_avatarImgView.image = UIImage(named: imageList[indexPath.row])
            cell.l_nameLabel.text = userList[indexPath.item]
            
            if indexPath.item == 2{
                cell.l_voiceView.isHidden = false
                cell.l_voiceImgView.isHidden = false
                cell.l_avatarImgView.layer.borderColor = HexColor(LightOrangeColor).cgColor
                if handsUp {
                    cell.l_handsUp.isHidden = false
                } else {
                    cell.l_handsUp.isHidden = true
                }
                
                if voiceHide {
                    cell.l_voiceView.isHidden = false
                } else {
                    cell.l_voiceView.isHidden = true
                }
            }

        } else {
            cell.rightView.isHidden = false
            cell.leftView.isHidden = true
            cell.r_avatarImgView.image = UIImage(named: imageList[indexPath.row])
            cell.r_nameLabel.text = userList[indexPath.item]

            if indexPath.item == 1{
                cell.r_miLabel.isHidden = false
            }
        }
         return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.reloadData()
        let playerView = PlayerView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        playerView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        self.view.addSubview(playerView)
        
    }
    
}




//// MARK: - 初始化声网sdk
//extension GameplayViewController: AgoraRtcEngineDelegate {
//    private func initAgoraKit() {
//        // 初始化
//        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppId, delegate: self)
//        // 因为是纯音频多人通话的场景，设置为通信模式以获得更好的音质
//        agoraKit.setChannelProfile(.communication)
//        // 通信模式下默认为听筒，demo中将它切为外放
//        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
//        // 启动音量回调，用来在界面上显示房间其他人的说话音量
//        agoraKit.enableAudioVolumeIndication(1000, smooth: 3, report_vad: false)
//        // 加入案发现场的群聊频道
//        agoraKit.joinChannel(byToken: nil, channelId: crimeChannelId, info: nil, uid: 0, joinSuccess: nil)
//    }
//}

