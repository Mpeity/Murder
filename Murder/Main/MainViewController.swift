//
//  MainViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import AgoraRtmKit


class MainViewController: UITabBarController {
    
    lazy var imageNames = ["home","script","message","script"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AgoraRtmLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        AgoraRtmLogout()
    }
    
}

extension MainViewController {
    private func setupTabbar() {
       for i in 0..<tabBar.items!.count {
           let item = tabBar.items![i]
           item.image = UIImage(named: imageNames[i])
           item.selectedImage = UIImage(named: imageNames[i]+"_highlighted")
       }
    }
}

extension MainViewController: AgoraRtmDelegate {
    // 登录
    func AgoraRtmLogin() {
        let account = UserAccountViewModel.shareInstance.account?.userId
        AgoraRtm.updateKit(delegate: self)
        AgoraRtm.current = String(account!)

        AgoraRtm.kit?.login(byToken: nil, user: String(account!)) { [weak self] (errorCode) in
            
            print(String(account!))
            
            
            guard errorCode == .ok else {
                
                showToastCenter(msg: "AgoraRtm login error: \(errorCode.rawValue)")
                return
            }
            AgoraRtm.status = .online
        }
    }
    
    // 退出账号
    func AgoraRtmLogout() {
        guard AgoraRtm.status == .online else {
            return
        }
        AgoraRtm.kit?.logout(completion: { (error) in
            guard error == .ok else {
                return
            }
            AgoraRtm.status = .offline
        })
    }
    
    // Receive one to one offline messages
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        AgoraRtm.add(offlineMessage: message, from: peerId)
    }
    
    func rtmKit(_ kit: AgoraRtmKit, imageMessageReceived message: AgoraRtmImageMessage, fromPeer peerId: String) {
        AgoraRtm.add(offlineMessage: message, from: peerId)
    }
}
