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

//import



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var defaultViewController : UIViewController? {
        let isLogin = UserAccountViewModel.shareInstance.isLogin
        return isLogin ? UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() :  BaseNavigationViewController(rootViewController: LoginViewController())
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Bugly
        
        let buglyConfig = BuglyConfig()
        buglyConfig.reportLogLevel = .error
        buglyConfig.unexpectedTerminatingDetectionEnable = true
        buglyConfig.debugMode = true
        Bugly.start(withAppId: BUGLY_APP_ID, config: buglyConfig)
        
        
//        let device = NSData.init(data: deviceToken)
//        let device_Token = device.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
//        CLog(item: "deviceToken: \(device_Token)")
        

        UITabBar.appearance().tintColor = HexColor("#9A57EF")


        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white

        self.window?.rootViewController = defaultViewController
        
//        self.window?.rootViewController =  BaseNavigationViewController(rootViewController: PrepareRoomViewController())
//        self.window?.rootViewController =  BaseNavigationViewController(rootViewController: LoginViewController())
        
        self.window?.makeKeyAndVisible()
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


func initUMPush() {
//    //推送
//    UMessage.start(withAppkey: UMAppKey, launchOptions: launchOptions, httpsEnable: true)
//    UMessage.registerForRemoteNotifications()
//
//    //iOS10必须添加下面这段代码
//    if #available(iOS 10.0, *) {
//        let center = UNUserNotificationCenter.current
//        center().delegate = self
//        center().requestAuthorization(options:[.badge,.alert,.sound] , completionHandler: { (granted, error) in
//            if granted {
//                //点击允许
//                //这里可以添加一些自己的逻辑
//            }else{
//                //点击不允许
//                //这里可以添加一些自己的逻辑
//            }
//        })
//
//    } else {
//        // Fallback on earlier versions
//    }
//    //打开日志，方便调试
//    UMessage.setLogEnabled(true)
}


// 友盟推送配置
func umPushConfig()  {
//    // push组件基本功能配置
//    let entity = UMessageRegisterEntity.init()
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = Int(UMessageAuthorizationOptions.badge.rawValue|UMessageAuthorizationOptions.sound.rawValue|UMessageAuthorizationOptions.alert.rawValue)
//    if #available(iOS 10.0, *) {
//        let action1 = UNNotificationAction.init(identifier: "action1_identifier", title: "打开应用", options: .foreground)
//        let action2 = UNNotificationAction.init(identifier: "action2_identifier", title: "忽略", options: .foreground)
//        //UNNotificationCategoryOptionNone
//        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//        let category1 = UNNotificationCategory.init(identifier: "category1", actions: [action1, action2], intentIdentifiers: [], options: .customDismissAction)
//        let categories = NSSet.init(objects: category1)
//        entity.categories = (categories as! Set<AnyHashable>)
//        UNUserNotificationCenter.current().delegate = self
//        UMessage.registerForRemoteNotifications(launchOptions: CSCConfig.sharedInstance.lauchOptions, entity: entity) { (granted, error) in
//            if granted {
//
//            } else {
//
//            }
//        }
//
//    } else {
//        // Fallback on earlier versions
//        let action1 = UIMutableUserNotificationAction.init()
//        action1.identifier = "action1_identifier"
//        action1.title = "打开应用"
//        action1.activationMode = .foreground
//        let action2 = UIMutableUserNotificationAction.init()
//        action2.identifier = "action2_identifier"
//        action2.title = "忽略"
//        action2.activationMode = .background //当点击的时候不启动程序，在后台处理
//        action2.isAuthenticationRequired = true //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.isDestructive = true
//        let actionCategory1 = UIMutableUserNotificationCategory.init()
//        actionCategory1.identifier = "category1" // 这组动作的唯一标示
//        actionCategory1.setActions([action1, action2], for: .default)
//        let categories = NSSet.init(objects: actionCategory1)
//        entity.categories = (categories as! Set<AnyHashable>)
//    }
}



