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
    
    private var page_size = 1
    
    private var messageModel: MessageModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "トーク"
        AgoraRtm.updateKit(delegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
        



}

// MARK: - LoadData
extension MessageViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageListCellId, for: indexPath) as! MessageListCell
        cell.selectionStyle = .none
        let model = messageModel?.list?[indexPath.row]
        cell.itemModel = model
        cell.avatarImgTapBlcok = {() in
//            let commonView = LookFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
//            commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
//            UIApplication.shared.keyWindow?.addSubview(commonView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = messageModel?.list?[indexPath.row]
        // 消息类型【0text 1剧本邀请 2剧本 3好友申请
        let type = model?.type
        
        switch type {
        case 0:
            let vc = SendMessageViewController()
//            let userId = model?.userId
//            vc.type = .peer(String(userId!))
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            break
    
        case 2:
            break
            
        case 3:
            let vc = ApplyFriendsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
//        if indexPath.row == 0  {
//            let vc = ApplyFriendsViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let vc = SendMessageViewController()
//            vc.type = .peer("挣大把钱钱")
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}


extension MessageViewController {
    @objc func rightBtnAction() {
        let vc = MyFriendsListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- AgoraRtmDelegate
extension MessageViewController: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        showToastCenter(msg: "connection state changed: \(state.rawValue)")
    }
    
    // Receive one to one offline messages
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        AgoraRtm.add(offlineMessage: message, from: peerId)
    }
    
    func rtmKit(_ kit: AgoraRtmKit, imageMessageReceived message: AgoraRtmImageMessage, fromPeer peerId: String) {
        AgoraRtm.add(offlineMessage: message, from: peerId)
    }
}
