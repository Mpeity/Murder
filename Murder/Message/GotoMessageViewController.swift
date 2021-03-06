//
//  GotoMessageViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import AgoraRtmKit
import MJRefresh

//let MessageListCellId = "MessageListCellId"

class GotoMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!
    
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    
    
    private var page_no = 1
    
    private var page_size = 15
    
    private var messageModel: MessageModel?
    
    private var receive_id: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "トーク"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        AgoraRtm.updateKit(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        
        navigationController?.navigationBar.isHidden = false

        setUI()
        msgNoRead()
        
        let peer = UserAccountViewModel.shareInstance.account?.userId
        AgoraRtm.kit?.queryPeersOnlineStatus([String(peer!)], completion: {[weak self] (peerOnlineStatus, peersOnlineErrorCode) in
            guard peersOnlineErrorCode == .ok else {
                self?.AgoraRtmLogin()
                return
            }
            Log(peerOnlineStatus)
            let status:AgoraRtmPeerOnlineStatus = peerOnlineStatus![0]
            if (status.isOnline == true) { // 在线
            } else { // 离线
                self?.AgoraRtmLogin()
            }
        })
    }
}

// MARK: - LoadData
extension GotoMessageViewController {
    
    private func msgNoRead() {
        msgNoReadRequest {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let no_read_num = data["no_read_num"] as! Int
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: No_Read_Num_Notif), object: no_read_num)
            }
        }
    }
    
    @objc private func loadMore() {
//        page_no += 1
//        loadData()
    }
    
    @objc private func loadRefresh() {
        page_no = 1
        loadData()
    }
    
    func loadData() {
        msgListRequest(page_no: page_no, page_size: page_size) {[weak self] (result, error) in
            if error != nil {
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
                return
            }
            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                
                let model = MessageModel(fromDictionary: data)
                if model.list?.count ?? 0 < 15 { // 最后一页
                    self?.myTableView.mj_header.endRefreshing()
                    self?.myTableView.mj_footer.endRefreshing()
                }
                
                if self?.page_no == 1 {
                    self?.messageModel = model
                } else {
                    self?.messageModel?.list?.append(contentsOf: model.list!)
                }

//                if self?.scriptModel!.list != nil {
//                    if self?.messageModel!.list?.count == 0 {
//                        self?.defaultView.isHidden = false
//                    } else {
//                        self?.defaultView.isHidden = true
//                    }
//                } else {
//                    self?.defaultView.isHidden = false
//                }
//                self?.tableHeaderView.tagList = self?.scriptModel!.tagList!
                
                
                self?.myTableView.reloadData()
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
            } else {
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
            }
        }
    }
}



// MARK: - UI
extension GotoMessageViewController {
    
    private func setNavigationBar() {
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)

    }
    
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadRefresh))
        header?.backgroundColor = UIColor.white
//        header?.setTitle("下拉刷新", for: .idle)
//        header?.setTitle("释放更新", for: .pulling)
//        header?.setTitle("加载中...", for: .refreshing)
        
        header?.lastUpdatedTimeLabel.isHidden = true  // 隐藏时间
        header?.stateLabel.isHidden = true // 隐藏文字
        header?.isAutomaticallyChangeAlpha = true //自动更改透明度
        
        // 设置tableview的header
        myTableView.mj_header = header
        
        // 进入刷新状态
        myTableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        myTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
    }
    
    func setUI() {
        
        setNavigationBar()
        
        let btn = UIButton()
        btn.setTitle("私の友達", for: .normal)
        btn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItem = rightItem
        
        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 73
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "MessageListCell", bundle: nil), forCellReuseIdentifier: MessageListCellId)
        
        setupHeaderView()
        setupFooterView()
    }
}

// MARK: - TableView Delegate
extension GotoMessageViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModel?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messageModel?.list?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageListCellId, for: indexPath) as! MessageListCell
        cell.selectionStyle = .none
        cell.itemModel = model
        if model?.type != 3 {
            cell.avatarImgTapBlcok = {[weak self]() in
                let commonView = LookFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                commonView.delegate = self
                commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                commonView.itemModel = model
                self?.receive_id = model?.userId
                UIApplication.shared.keyWindow?.addSubview(commonView)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = messageModel?.list?[indexPath.row]
        // 消息类型【0text 1剧本邀请 2剧本 3好友申请
        let type = model?.type
        
        switch type {
        case 0,1,2:
            let vc = SendMessageViewController()
//            let userId = model?.userId
//            vc.type = .peer(String(userId!))
            vc.messageListModel = model
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            let vc = ApplyFriendsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }
}


extension GotoMessageViewController {
    @objc func rightBtnAction() {
        let vc = MyFriendsListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GotoMessageViewController: AgoraRtmDelegate {
    // 登录
    func AgoraRtmLogin() {
        func AgoraRtmLogin() {
            let account = UserAccountViewModel.shareInstance.account?.userId
            AgoraRtm.updateKit(delegate: self)
            AgoraRtm.current = String(account!)

            AgoraRtm.kit?.login(byToken: nil, user: String(account!)) { [weak self] (errorCode) in
                
                Log(String(account!))
                
                guard errorCode == .ok else {
                    UIApplication.shared.keyWindow?.rootViewController =  BaseNavigationViewController(rootViewController: LoginViewController())
                    userLogout()
                    AgoraRtmLogout()
                    return
                }
                AgoraRtm.status = .online
            }
        }
    }
    
    // Receive one to one offline messages
//    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
//        AgoraRtm.add(offlineMessage: message, from: peerId)
//    }
//
//    func rtmKit(_ kit: AgoraRtmKit, imageMessageReceived message: AgoraRtmImageMessage, fromPeer peerId: String) {
//        AgoraRtm.add(offlineMessage: message, from: peerId)
//    }
    
    
}


extension GotoMessageViewController: LookFriendsViewDelegate {
    func editBtnActionFunc() {
        let commonView = EidtFirendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.receive_id = receive_id
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
    func DeleteFriends() {
        loadRefresh()
    }
 
}

extension GotoMessageViewController: EidtFirendsViewDelegate {
    func deleteFriends() {
        loadRefresh()
    }
    
    func blackFriends() {
        loadRefresh()
    }
    
    func reportFriends() {
        
        let vc = FriendReportViewController()
        vc.receive_id = receive_id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

