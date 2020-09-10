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
class AppDelegate: UIResponder, UIApplicationDelegate {

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
        buglyConfig.debugMode = true
        Bugly.start(withAppId: BUGLY_APP_ID, config: buglyConfig)
        
        // UM
        UMConfigure.initWithAppkey(UMAppKey, channel: "App Store")
        UMConfigure.setLogEnabled(true)
        application.registerForRemoteNotifications()
        
        setUI()
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
//        self.window?.rootViewController = defaultViewController

        self.window?.rootViewController = LoginViewController()
        
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
            print("iOS 13 deviceToken：\(deviceId)")
        } else {
            let device = NSData(data: deviceToken)
            deviceId = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
            print("我的deviceToken：\(deviceId)")
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
           print(info)
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
           print(info)
           //应用处于后台时的远程推送接受
           UMessage.didReceiveRemoteNotification(userInfo)
        }else{
           //应用处于前台时的远程推送接受
        }
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




