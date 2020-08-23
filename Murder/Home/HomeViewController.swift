//
//  HomeViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import MJRefresh



let HomeListViewCellId = "HomeListViewCellId"
let HomeListHeaderViewId = "HomeListHeaderViewId"


class HomeViewController: UIViewController,UITextFieldDelegate {
    
    private var page_no = 1
    private var page_size = 20
    private var currentIndex = 0
    
    private lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    private var tableHeaderView: HomeListHeaderView!
    
    
    private var roomList: [HomeRoomModel] =  [HomeRoomModel]()
    private var bannerList: [HomeBannerModel] = [HomeBannerModel]()
    
    private lazy var textInputView : InputTextView! = {
        let inputView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        inputView.delegate = self
        inputView.textFieldView.delegate = self
        inputView.titleLabel.text = "パスワードを入力"
        inputView.commonBtn.setTitle("確認", for: .normal)
        inputView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        return inputView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        setUI()
        
//        loadRefresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


//MARK:- 网络请求
extension HomeViewController {
    // 加载更多
    @objc func loadMore() {
        page_no += 1
        
    }
    // 刷新
    @objc func loadRefresh() {
        page_no = 1
        loadData()
    }
    // 请求首页数据
    func loadData() {
        
        
        
  

        
        loadHomeData(page_no: page_no, page_size: page_size) {[weak self] (result, error) in
            if error != nil {
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
                return
            }
            
            
            Log("---------\(Thread.current)")
            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                
                if self!.page_no == 1 {
                    self!.roomList.removeAll()
                    self?.bannerList.removeAll()
                }
                
                let data = resultDic["data"] as! [String : AnyObject]
                
                let room_list = data["room_list"] as! [[String : AnyObject]]
                let user = data["user"]
                let banner_list = data["banner_list"] as! [[String : AnyObject]]
                
                
                for roomItem in room_list {
                    let roomModel = HomeRoomModel(fromDictionary: roomItem)
                    self!.roomList.append(roomModel)
                }
                
                for bannerItem in banner_list {
                    let bannerModel = HomeBannerModel(fromDictionary: bannerItem)
                    self!.bannerList.append(bannerModel)
                }
                
                let userModel = HomeUserModel(fromDictionary: user as! [String : AnyObject])
                
                
                let homeViewModel = HomeViewModel(bannerModelArr: self!.bannerList, userModel: userModel)
                
        
                
                
                self?.tableHeaderView.homeViewModel = homeViewModel
                
                self?.tableView.reloadData()
                
                Log("---------\(Thread.current)")

                
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
                
            } else {
                
               self?.tableView.mj_header.endRefreshing()
               self?.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    // 进入房间
    func joinRoom(room_id: Int, room_password: String?, script_id: Int, hasPassword: Bool) {
        joinRoomRequest(room_id: room_id, room_password: room_password, hasPassword: hasPassword) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
//                let vc = ScriptDetailsViewController()
//                vc.script_id = script_id
//                self?.navigationController?.pushViewController(vc, animated: true)
                
                let vc = PrepareRoomViewController()
                vc.room_id = room_id
                vc.script_id = script_id
                self?.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                showToastCenter(msg: "暗証番号が正しくありません")
            }
        }
    }
    
    // 判断房间是否需要密码
    func checkRoomId(room_id: Int, codeResult: @escaping(_ code: Int)->()) {
        roomCheckPassword(room_id: room_id) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["result"] as! [String : AnyObject]
                let is_pass = resultData["is_pass"] as! Int
                codeResult(is_pass)
            }
            
        }
    }
}



extension HomeViewController {
   private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadRefresh))
        header?.backgroundColor = UIColor.white
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        // 设置tableview的header
        tableView.mj_header = header
        
        // 进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
    }
    private func setUI() {
        tableHeaderView = HomeListHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: STATUS_BAR_HEIGHT + 260))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeListViewCell", bundle: nil), forCellReuseIdentifier: HomeListViewCellId)
        tableView.register(HomeListTableHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeListHeaderViewId)
        
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 127
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-STATUS_BAR_HEIGHT)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        tableView.tableHeaderView = tableHeaderView
        
        
        setupHeaderView()
        setupFooterView()
        
//        let headerView = UIView()
//        self.view.addSubview(headerView)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
//        headerView.addGestureRecognizer(tap)
//        headerView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalTo(bgView.snp.top)
//
//        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeListViewCellId, for: indexPath) as! HomeListViewCell
        cell.selectionStyle = .none
        
        let model = roomList[indexPath.row]
        cell.roomModel = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeListTableHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 60))
        header.titleLabel.text = "ホール"
        return header
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row
        let commonView = ListPopUpView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(commonView)
        let model = roomList[indexPath.row]
        commonView.roomModel = model
    
        
        
//        let vc = PrepareRoomViewController()
//        vc.room_id = 1
//        vc.script_id = model.scriptId
//
//        navigationController?.pushViewController(vc, animated: true)
//        return
            
            
        
        checkRoomId(room_id: model.roomId) {[weak self] (code) in
            
            commonView.enterBtnTapBlcok = {[weak self] (param)->() in
                Log(code)
                commonView.removeFromSuperview()
                if code == 1 { // 有密码
                    self!.textInputView.textFieldView.becomeFirstResponder()
                    UIApplication.shared.keyWindow?.addSubview(self!.textInputView)
                } else {
                    if model.userScriptStatus == 0 { // 未拥有该剧本
                        let vc = ScriptDetailsViewController()
                        vc.script_id = model.scriptId
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self?.joinRoom(room_id: model.roomId, room_password: nil, script_id: model.scriptId, hasPassword: false)
                    }
                    
                }
            }
        }
        
        

    }
    
}

extension HomeViewController: InputTextViewDelegate  {
    
    func commonBtnClick() {
        textInputView.removeFromSuperview()
        let text = textInputView.textFieldView.text!
        let model = roomList[currentIndex]
        joinRoom(room_id: model.roomId, room_password: text, script_id: model.scriptId, hasPassword: true)
        
//        let vc = ScriptDetailsViewController()
//        vc.script_id = model.scriptId
//        navigationController?.pushViewController(vc, animated: true)
        
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
