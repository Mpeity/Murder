//
//  PrepareRoomViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let PrepareRoomCellId = "PrepareRoomCellId"


class PrepareRoomViewController: UIViewController {
    
    // 顶部视图
    var headerBgView: UIView = UIView()
    
    // 退出房间按钮
    var exitBtn: UIButton = UIButton()
    // 游戏名称展示
    var gameNameLabel: UILabel = UILabel()
    // 房间标签
    var statusImgView:UIImageView = UIImageView()
    // 锁
    var lockBtn: UIButton = UIButton()
    // 消息按钮
    var messageBtn: UIButton = UIButton()
    // wifi信号
    var wifiImgView: UIImageView = UIImageView()
    // 电量
    var electricityView: UIView = UIView()
    
    // 当前房间号
    var currentLabel: UILabel = UILabel()
    // 说明
    var stateBtn: UIButton = UIButton()
    // 说明弹框配置
    var preference:FEPreferences = FEPreferences()
    // 说明弹框
    var tipView: FETipView!

    
    
    // 阶段说明
    var stateTipView: UIView = UIView()
    var stateTipLabel: UILabel = UILabel()
    
    // 选择角色
    var choiceLabel: UILabel = UILabel()
    
    // 邀请按钮
    var inviteBtn: UIButton = UIButton()
    
    
    
    
    var tableView: UITableView = UITableView()
    
    // 底部视图
    var bottomView: UIView = UIView()
    // 跑马灯
    var marqueeView: MarqueeView = MarqueeView()
    // 准备按钮
    var prepareBtn: UIButton = UIButton()
    // 声音按钮
    var voiceBtn: UIButton = UIButton()
    
    var isStatusBarHidden = false {
        
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override var prefersStatusBarHidden: Bool {
           return self.isStatusBarHidden
    }
       




}

extension PrepareRoomViewController {
    private func setUI() {
        self.view.backgroundColor = HexColor("#27025E")
        
        setHeaderView()
 
        
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
//            make.width.equalTo(100)
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
        
        // 锁按钮
        bgView.addSubview(lockBtn)
        lockBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-99)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(12)
        }
        lockBtn.setImage(UIImage(named: "createroom_lock"), for: .normal)
        
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
        electricityView.backgroundColor = UIColor.green
        electricityView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12.5)
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(25)
            make.height.equalTo(10)
        }
        
        // 当前房间号
        bgView.addSubview(currentLabel)
        currentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11.5)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(16)
//            make.width.equalTo(100)
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
        stateBtn.setTitle("キャラクター紹介", for: .normal)
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
        choiceLabel.text = "キャラクターを選択（4/9）"
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
//        prepareBtn.setGradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 20)
        prepareBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 20)
        prepareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        prepareBtn.setTitle("準備", for: .normal)
        prepareBtn.setTitleColor(UIColor.white, for: .normal)
        prepareBtn.addTarget(self, action: #selector(prepareBtnAction(button:)), for: .touchUpInside)
        
        
        
        
        
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PrepareRoomCell", bundle: nil), forCellReuseIdentifier: PrepareRoomCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 80
        tableView.backgroundColor = HexColor("#27025E")
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(choiceLabel.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp_top).offset(-15)
        }
        
    }
    

    
    
    
}


extension PrepareRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        let cell = tableView.dequeueReusableCell(withIdentifier: PrepareRoomCellId, for: indexPath) as! PrepareRoomCell
        cell.selectionStyle = .none
        cell.backgroundColor = HexColor("#27025E")
        cell.isSelected = false
        if indexPath.row == 1{
            cell.ownerLabel.isHidden = false
            cell.pointView.isHidden = true
        } else {
            cell.ownerLabel.isHidden = true
        }
        
        if indexPath.row == 4 {
            cell.avatarImgView.image = UIImage(named: "unselected_icon")
            cell.pointView.isHidden = true
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
      
}


extension PrepareRoomViewController {
    //MARK:- 退出房间按钮
    @objc func exitBtnAction(button: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        
        let commonView = OutOfRoomView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        // 退出房间 确认按钮
        commonView.confirmBtnTapBlcok = {[weak self]() in
            self?.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(commonView)
    }
    
    
        //MARK:- 邀请按钮
        @objc func inviteBtnAction(button: UIButton) {
            
            let commonView = PrepareRoomShareView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            self.view.addSubview(commonView)
        }
    
    //MARK:- 消息按钮
    @objc func messageBtnAction(button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 声音按钮
    @objc func voiceBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
    }
    //MARK:-  准备/取消
    @objc func prepareBtnAction(button: UIButton) {
        
        button.isSelected = !button.isSelected
        if !button.isSelected { // 取消
            prepareBtn.setTitle("準備取り消し", for: . normal)
//            prepareBtn.cornerAll(byRoundingCorners: .allCorners, radii: 20, borderWidth: 1, borderColor: MainColor)

        } else { // 准备
            prepareBtn.setTitle("準備", for: .normal)
//            prepareBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 20)
        }
        
        let vc = GameplayViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func stateBtnAction(button: UIButton) {
        button.isSelected = !button.isSelected
        preference.drawing.backgroundColor = UIColor.white
        preference.drawing.textColor = HexColor(LightDarkGrayColor)
        preference.positioning.targetPoint = CGPoint(x: button.center.x, y: button.frame.maxY+55)
        preference.drawing.maxTextWidth = 332*SCALE_SCREEN
        preference.drawing.maxHeight = 208
        preference.positioning.marginLeft = 16
        preference.drawing.textAlignment = .left
        preference.drawing.message = "「あの人と出会えることは神様の恩賜だろう。しかしあの人と愛し合うことは腐れ縁だとう。」あなたの名前はフラ、昔あなたのお爺さんは一応役人だ、でも上司から陥れられ、一族は落ちぶれた。幼いあなたは伶人になって、家族と離れ離れになってしまった、自分の本名も覚えられない。数年後、あなたは伊勢守の上泉家に買われ、家の侍女となった。その一瞬で、斎宮殿と大宮司様に時間を稼いでた、その隙を狙い、斎宮殿と大宮司様が化け物を祓った。"
        
        preference.animating.shouldDismiss = false        
        if button.isSelected {
            tipView = FETipView(preferences: preference)
            tipView.show()
        } else {
            tipView.dismiss()
        }
    }
}


extension PrepareRoomViewController {
    private func btnLayer(layerView:UIButton) {
        // layerFillCode
        let layer = CALayer()
        layer.frame = layerView.bounds
        layer.backgroundColor = UIColor(red: 0.6, green: 0.34, blue: 1, alpha: 1).cgColor
        layerView.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.21, green: 0.13, blue: 0.95, alpha: 1).cgColor, UIColor(red: 0.58, green: 0.29, blue: 1, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = layerView.bounds
        layerView.layer.addSublayer(gradient1)
        layerView.layer.cornerRadius = 20
    }
}
