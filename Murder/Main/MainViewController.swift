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
    
    var timer: DispatchSourceTimer?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabbar()
        
        updateVersion()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AgoraRtmLogin()
        
        setRedPoint()
        
        let uid = UserAccountViewModel.shareInstance.account?.userId!
        let alias = "alias_\(uid!)"
        UMessage.addAlias(alias, type: "SINA_WEIBO") {  (result, error) in
            Log(result)
            Log(error)
         }
        
        
        self.tabBar.tintColor = HexColor(MainColor)
        self.tabBar.barTintColor = UIColor.white
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(notifFunc(notif:)), name: NSNotification.Name(rawValue: No_Read_Num_Notif), object: nil)
        mgsNoRead()
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
                
        timer?.schedule(deadline: .now(), repeating: .seconds(2))
        // 设定时间源的触发事件
        timer?.setEventHandler(handler: {
            DispatchQueue.main.async { [weak self] in
                self?.onlineTime()
            }
        })
        // 启动时间源
        timer?.resume()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        AgoraRtmLogout()
        timer?.cancel()
        timer = nil
        
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
            
            Log(String(account!))
            
            guard errorCode == .ok else {
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
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Send_Message_Notif), object: nil)
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
    
    private func onlineTime() {
        
        if UserAccountViewModel.shareInstance.isLogin == false {
            return
        }
        
        onlineTimeRequest { (result, error) in
            
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


extension MainViewController {
    func updateVersion() {
        //获取当前设备中应用的版本号
        func getSystemVersion() -> String? {
            let dic = Bundle.main.infoDictionary
            let currentVersion = dic?["CFBundleShortVersionString"]
            return currentVersion as? String
        }
        // 版本号专为Int类型
        func versionExchangeType(version: String) -> Int {
            
            let subArr = version.components(separatedBy: CharacterSet.init(charactersIn: "."))
            if subArr.count > 0 {
                var value: String = ""
                for item in subArr {
                    value.append(item)
                }
                return Int(value)!
            } else {
                return 0
            }
        }
        
        getVersionIndex { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["result"] as! [String : AnyObject]
                let model = UpdateVersionModel(fromDictionary: resultData)
                
                Log(model.content)
                
                
                var backgroundVerison = 0
                if model.version == nil {
                    backgroundVerison = 100
                } else {
                    backgroundVerison = versionExchangeType(version: model.version!)
                }

                //本地的版本号
                var localVersion = versionExchangeType(version: getSystemVersion()!)
                if localVersion == 10 {
                    localVersion = 100
                }
                //判断两个版本是否相同
//                if (localVersion < backgroundVerison) {
                    let commonView = UpdateVersionView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                    commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                    commonView.model = model
                    UIApplication.shared.keyWindow?.addSubview(commonView)
//                }else {
//                    Log("无版本可更新。。")
//                }
            }
        }
    }
}
