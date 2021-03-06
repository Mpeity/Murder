//
//  AppDelegate.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import Bugly
import AgoraRtmKit
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    var defaultViewController : UIViewController? {
        let isLogin = UserAccountViewModel.shareInstance.isLogin
        return isLogin ? UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() :  BaseNavigationViewController(rootViewController: LoginViewController())
    }

    // 接收到远程通知
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        Log("didReceive notification: UILocalNotification")
        
    }
    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Bugly
        let buglyConfig = BuglyConfig()
        buglyConfig.reportLogLevel = .error
        buglyConfig.unexpectedTerminatingDetectionEnable = true
        buglyConfig.debugMode = false
        Bugly.start(withAppId: BUGLY_APP_ID, config: buglyConfig)
        
        
        UIApplication.shared.registerForRemoteNotifications()
        
        // UM
        UMConfigure.initWithAppkey(UMAppKey, channel:  nil)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

        } else {
            // Fallback on earlier versions
        }
         let entity = UMessageRegisterEntity.init()
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等

        entity.types = Int(UInt8(UMessageAuthorizationOptions.badge.rawValue) | UInt8(UMessageAuthorizationOptions.alert.rawValue) | UInt8(UMessageAuthorizationOptions.sound.rawValue))

       UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
           if granted {
            // 用户选择了接收Push消息
            Log("用户选择了接收Push消息")

           } else {
               // 用户拒绝接收Push消息
               Log("用户拒绝接收Push消息")
           }
       }
        
        UMCommonLogSwift.setUpUMCommonLogManager()
        UMCommonSwift.setLogEnabled(bFlag: false)
        UMCommonSwift.initWithAppkey(appKey: UMAppKey, channel: "App Store")
        
        
        setUI()
        //        [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        application.setStatusBarHidden(false, with: .none)
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = defaultViewController

//        self.window?.rootViewController = BaseNavigationViewController(rootViewController: LoginViewController())
//        self.window?.rootViewController = RegisterViewController()
//        self.window?.rootViewController = SetPasswordsViewController()
//        self.window?.rootViewController = CompleteInfoViewController()
        
        self.window?.makeKeyAndVisible()
        return true
    }
    
    
    ///请求完成后会调用把获取的deviceToken返回给我们
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var deviceId = String()
        if #available(iOS 13.0, *) {
            let bytes = [UInt8](deviceToken)
            for item in bytes {
                deviceId += String(format:"%02x", item&0x000000FF)
            }
            Log("iOS 13 deviceToken：\(deviceId)")
        } else {
            let device = NSData(data: deviceToken)
            deviceId = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
            Log("我的deviceToken：\(deviceId)")
        }
 
    }

    /**
      UNUserNotificationCenterDelegate
    */
    //iOS10以下使用这个方法接收通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
       UMessage.didReceiveRemoteNotification(userInfo)
    }
    
      
    @available(iOS 10.0, *)
    //iOS10新增：处理前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
           let info = userInfo as NSDictionary
            Log(info)
           //应用处于前台时的远程推送接受
           UMessage.setAutoAlert(false)
           UMessage.didReceiveRemoteNotification(userInfo)
        }else{
           //应用处于前台时的远程推送接受
        }
        completionHandler([.alert,.sound,.badge])
    }
   


    @available(iOS 10.0, *)
   //iOS10新增：处理后台点击通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
           let info = userInfo as NSDictionary
            Log(info)
           //应用处于后台时的远程推送接受
           UMessage.didReceiveRemoteNotification(userInfo)
            
        }else{
           //应用处于前台时的远程推送接受
        }
        
    }
    
    
    //进入后台模式，主动断开socket，防止出现处理不了的情况
    func applicationWillResignActive(_ application: UIApplication) {
//           if SingletonSocket.sharedInstance.socket.isConnected {
//                reConnectTime = 5
//                socketDisConnect()
//            }
     }

    //进入前台模式，主动连接socket
    func applicationDidBecomeActive(_ application: UIApplication) {
        //解决因为网络切换或链接不稳定问题，引起socket断连问题
        //如果app从无网络，到回复网络，需要执行重连
//        if !SingletonSocket.sharedInstance.socket.isConnected {
//            reConnectTime = 0
//            socketReconnect()
//        }
    }

    
//MARK: - 通过下面的方法实现点击html可以打开app
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 跳转到app剧本详情页
        if url.scheme != nil , url.scheme!.contains("murderurl") {
            let urlString = url.absoluteString as NSString  //url 的绝对字符串
            let queryArray = urlString.components(separatedBy: "id=")  //通过/把URL切成数组
            let script_id = Int(queryArray.last!)
            
            let scriptDetailVC = ScriptDetailsViewController()
            scriptDetailVC.script_id = script_id
            scriptDetailVC.modalPresentationStyle = .fullScreen
            
            
            let viewController = UIApplication.shared.keyWindow?.rootViewController
            let tabVC = viewController as! MainViewController
            let vc = tabVC.selectedViewController as! BaseNavigationViewController
            vc.pushViewController(scriptDetailVC, animated: true)
            
            
            
//            let viewController = UIApplication.shared.keyWindow?.rootViewController
//
//            if viewController?.isKind(of: UITabBarController.self) ?? false {
//
//                let tabVC = viewController as! MainViewController
//                let vc = tabVC.selectedViewController
//                vc?.present(scriptDetailVC, animated: true, completion: nil)
//                Log(vc)
//                Log("111")
//
//            }
//
//            if viewController?.isKind(of: UINavigationController.self) ?? false {
//                Log(viewController)
//                let nav = viewController as! BaseNavigationViewController
//                let vc = nav.visibleViewController
//
//                vc?.present(scriptDetailVC, animated: true, completion: nil)
//                Log("222")
//
//            }
//            if (viewController?.presentedViewController) != nil {
//                Log("333")
//                Log(viewController)
//            }
            
            return true
        }
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle

//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

    

extension AppDelegate {
    private func setUI() {

        UITabBar.appearance().tintColor = HexColor("#9A57EF")
    }
}




