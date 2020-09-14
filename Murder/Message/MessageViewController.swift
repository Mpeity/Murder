//
//  MessageViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import AgoraRtmKit
import MJRefresh

let MessageListCellId = "MessageListCellId"

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!
    
    
    private var page_no = 1
    
    private var page_size = 15
    
    private var messageModel: MessageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "トーク"
        AgoraRtm.updateKit(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        msgNoRead()
        
        let peer = UserAccountViewModel.shareInstance.account?.userId
        AgoraRtm.kit?.queryPeersOnlineStatus([String(peer!)], completion: {[weak self] (peerOnlineStatus, peersOnlineErrorCode) in
            guard peersOnlineErrorCode == .ok else {
                showToastCenter(msg: "message-AgoraRtm login error: \(peersOnlineErrorCode.rawValue)")
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
extension MessageViewController {
    
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
        page_no += 1
        loadData()
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
extension MessageViewController {
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadRefresh))
        header?.backgroundColor = UIColor.white
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        // 设置tableview的header
        myTableView.mj_header = header
        
        // 进入刷新状态
        myTableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        myTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
    }
    
    func setUI() {
        
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
extension MessageViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageModel?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = messageModel?.list?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageListCellId, for: indexPath) as! MessageListCell
        cell.selectionStyle = .none
        cell.itemModel = model
        if model?.type != 3 {
            cell.avatarImgTapBlcok = {() in
                let commonView = LookFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                commonView.itemModel = model
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


extension MessageViewController {
    @objc func rightBtnAction() {
        let vc = MyFriendsListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MessageViewController: AgoraRtmDelegate {
    // 登录
    func AgoraRtmLogin() {
        let account = UserAccountViewModel.shareInstance.account?.userId
        AgoraRtm.updateKit(delegate: self)
        AgoraRtm.current = String(account!)
        AgoraRtm.kit?.login(byToken: nil, user: String(account!)) { [weak self] (errorCode) in
            print(String(account!))
            guard errorCode == .ok else {
                showToastCenter(msg: "login-AgoraRtm login error: \(errorCode.rawValue)")
                return
            }
            AgoraRtm.status = .online
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
