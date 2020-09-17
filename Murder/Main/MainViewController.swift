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
    
    lazy var imageNames = ["home","script","message","mine"]
    
    var checkUserModel: CheckUserModel?
    
    var redPoint = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabbar()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AgoraRtmLogin()
        
        setRedPoint()
        
        self.tabBar.tintColor = HexColor(MainColor)
        self.tabBar.barTintColor = UIColor.white
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifFunc(notif:)), name: NSNotification.Name(rawValue: No_Read_Num_Notif), object: nil)
        mgsNoRead()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        AgoraRtmLogout()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    private func setRedPoint() {
        redPoint.backgroundColor = HexColor("#ED2828")
        redPoint.tag = 101
        let tabFrame = self.tabBar.frame
        let x = ceil(0.65*tabFrame.size.width)
        let y = ceil(0.1*tabFrame.size.height)
        redPoint.frame = CGRect(x: x, y: y, width: 10, height: 10)
        redPoint.layer.cornerRadius = 5
        self.tabBar.addSubview(redPoint)
        redPoint.isHidden = true
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
                showToastCenter(msg: "AgoraRtmLogout")
                #warning("注释一下，记得解开")
//                UIApplication.shared.keyWindow?.rootViewController =  BaseNavigationViewController(rootViewController: LoginViewController())
//                userLogout()
//                self!.AgoraRtmLogout()
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

extension MainViewController {
    @objc private func notifFunc(notif: Notification) {
        Log(notif)
        let obj = notif.object as! Int
        
        if obj != 0 {
            redPoint.isHidden = false
        } else {
            redPoint.isHidden = true
        }
    }
    
    
    private func mgsNoRead() {
        msgNoReadRequest {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let no_read_num = data["no_read_num"] as! Int
                
                if no_read_num != 0 {
                    self!.redPoint.isHidden = false
                }
            }
        }
    }
    
    private func checkUser() {
        checkUrlRequest {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                self?.checkUserModel = CheckUserModel(fromDictionary: data)
                
                if self?.checkUserModel!.stage == 1 {
                    let vc = PrepareRoomViewController()
                    
                } else if (self?.checkUserModel!.stage == 2) {
                    
                }
                
                
                
            }
        }
    }
}
