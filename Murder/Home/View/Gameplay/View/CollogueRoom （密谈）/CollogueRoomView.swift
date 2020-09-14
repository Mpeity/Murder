//
//  CollogueRoomView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import AgoraRtcKit


let CollogueRoomCellId = "CollogueRoomCellId"

protocol CollogueRoomViewDelegate {
    
    func commonBtnTapAction(index: Int)
    
    func leaveBtnTapAction(index: Int)
}

class CollogueRoomView: UIView {
    
    var roomCount : Int? = 0 {
        didSet {
            
//            bgView.snp.remakeConstraints { (make) in
//                 make.left.equalToSuperview()
//                 make.right.equalToSuperview()
//                 make.bottom.equalToSuperview()
//                 if IS_iPHONE_X {
//                     make.height.equalTo(34 + 5 + 60 * roomCount!)
//                 } else {
//                     make.height.equalTo(5 + 60 * roomCount!)
//                 }
//            }
//
//            tableView.snp.remakeConstraints { (make) in
//                make.top.equalToSuperview().offset(5)
//                make.left.right.equalToSuperview()
//                make.height.equalTo(60 * roomCount!)
//            }
            

            tableView.reloadData()
            if selectIndexPath != nil {
                tableView.selectRow(at: selectIndexPath, animated: true, scrollPosition: .bottom)
            }
        }
    }
    
    var room_id : Int? {
        didSet {
            
        }
    }
    
    var delegate: CollogueRoomViewDelegate?
    
    private var agoraKit: AgoraRtcEngineKit!
    private var agoraStatus = AgoraStatus.sharedStatus()

    private lazy var tableView: UITableView = UITableView()
    
    private var uid : Int?
    
    var selectIndexPath: IndexPath?
    
    private var bgView : UIView!

    
    var itemModel: GPScriptRoleListModel? {
        didSet {
            uid = itemModel?.user?.userId
            
           
            
            tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
//        loadAgoraKit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CollogueRoomView {
    private func setUI() {
        
        if bgView == nil {
            bgView = UIView()
            bgView.backgroundColor = UIColor.white
            self.addSubview(bgView)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            if IS_iPHONE_X {
                make.height.equalTo(5 + 34 + 60 * 5)
            } else {
               make.height.equalTo(5 + 60 * 5)
            }
        }
        
        bgView.layoutIfNeeded()
        bgView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: 15)

                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CollogueRoomViewCell", bundle: nil), forCellReuseIdentifier: CollogueRoomCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 60
        tableView.backgroundColor = UIColor.white
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(60 * 5)
        }
        
        let headerView = UIView()
        self.addSubview(headerView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
        headerView.addGestureRecognizer(tap)
        headerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(bgView.snp.top)
           
        }
    }
}


extension CollogueRoomView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomCount!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollogueRoomCellId, for: indexPath) as! CollogueRoomViewCell
        cell.contentLabel.text = "密談室" + "\(indexPath.row+1)"
        cell.selectionStyle = .none
        if selectIndexPath != nil {
            if selectIndexPath == indexPath {
                cell.isSelected = true
                cell.leaveBtn.isHidden = false
                cell.commonBtn.isHidden = true
            } else {
                cell.isSelected = false
                cell.commonBtn.isHidden = true
            }
        } else {
            cell.isSelected = false
            cell.commonBtn.isHidden = false
        }

        
        let channelId = "密談室" + "\(indexPath.row+1)"
        uid = UserAccountViewModel.shareInstance.account?.userId
        cell.commonBtnActionBlcok = {[weak self] () in
            // 加入私聊频道
//            self!.agoraKit.leaveChannel(nil)
//            self!.agoraKit.joinChannel(byToken: nil, channelId: channelId, info: nil, uid: UInt(bitPattern: self!.uid!), joinSuccess: nil)
            self!.tableView.reloadData()
            self!.selectIndexPath = indexPath
            self!.tableView.selectRow(at: self!.selectIndexPath, animated: true, scrollPosition: .bottom)
            if self?.delegate != nil {
                self!.delegate!.commonBtnTapAction(index: indexPath.row)
            }
        }
        
        cell.leaveBtnActionBlcok = {[weak self] () in
            
            if self?.delegate != nil {
                self!.delegate!.leaveBtnTapAction(index: indexPath.row)
            }
            
//            if self!.room_id != nil {
//                // 从私聊返回案发现场时，重新加入案发现场的群聊频道
//                let uid = UserAccountViewModel.shareInstance.account?.userId
//                self!.agoraKit.joinChannel(byToken: nil, channelId: "\(self!.room_id!)", info: nil, uid: UInt(bitPattern: uid!) , joinSuccess: nil)
//                self?.hideView()
//            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? CollogueRoomViewCell
        
        
        if cell!.isSelected {
            if self.delegate != nil {
                self.delegate!.commonBtnTapAction(index: indexPath.row)
            }
            Log(cell!.isSelected )
        } else {
            
            Log(cell!.isSelected )
            
            if self.delegate != nil {
                self.delegate!.leaveBtnTapAction(index: indexPath.row)
            }
        }
        
    }
    
}

extension CollogueRoomView: AgoraRtcEngineDelegate {
    private func loadAgoraKit() {
        // 初始化AgoraRtcEngineKit
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgoraKit_AppId, delegate: self)
        agoraKit.leaveChannel(nil)
        agoraKit.setChannelProfile(.communication)
        // 通信模式下默认为听筒，demo中将它切为外放
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
    }
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        if agoraStatus.muteAllRemote == true {
            agoraKit.muteAllRemoteAudioStreams(true)
        }
        
        if agoraStatus.muteLocalAudio == true {
            agoraKit.muteLocalAudioStream(true)
        }
        
        // 注意： 1. 由于demo欠缺业务服务器，所以用户列表是根据AgoraRtcEngineDelegate的didJoinedOfUid、didOfflineOfUid回调来管理的
        //       2. 每次加入频道成功后，新建一个用户列表然后通过回调进行统计
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // 当有用户加入时，添加到用户列表
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        // 当用户离开时，从用户列表中清除
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        // 当频道里的用户开始或停止发送音频流的时候，会收到这个回调。在界面的用户头像上显示或隐藏静音标记
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        // 收到说话者音量回调，在界面上对应的 cell 显示动效
        
    }
}


extension CollogueRoomView {
    @objc func hideView() {
        self.isHidden = true
    }
}
