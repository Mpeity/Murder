//
//  Common.swift
//  Swift_WB
//
//  Created by mac on 2020/7/2.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation
import UIKit

//MARK:- 通知
// 点击标签 剧本刷新
let Script_Change_Notif = "Script_Change_Notif"

// 是否有未读消息通知
let No_Read_Num_Notif = "No_Read_Num_Notif"

// 删除好友
let Delete_Friend_Notif = "Delete_Friend_Notif"


// MARK:- 常量
let app_key = "135761428"
let app_secret = "07834af7d1a2d0459f4c2b63bfcf5f4f"
let redirect_uri = "http://www.520it.com"

// 声网APPID
let AgoraKit_AppId = "c9c14d866ca149119d7c6110dc47be36"
// 友盟推送
let UMAppKey = "5f5492aa375dc31531b9826e"


//MARK:- bugly
let BUGLY_APP_ID =  "7686b1c615"

let FULL_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let FULL_SCREEN_HEIGHT = UIScreen.main.bounds.size.height


let SCALE_SCREEN = FULL_SCREEN_WIDTH / 375.0


//// 计算横向比例
//#define H_PROPORTION (ScreenWidth) / 375.0
//#define H_P(value) (value) * H_PROPORTION

//iPHONE_X 判断
let IS_iPHONE_X = UIDevice.current.isX()
// 状态栏高度
let STATUS_BAR_HEIGHT:CGFloat = (IS_iPHONE_X ? 44.0 : 20.0)
// 导航栏高度
let NAVIGATION_BAR_HEIGHT:CGFloat = (IS_iPHONE_X ? 88.0 : 64.0)
// tabBar高度
let TAB_BAR_HEIGHT:CGFloat = (IS_iPHONE_X ? (49.0+34.0) : 49.0)
// home indicator
let HOME_INDICATOR_HEIGHT:CGFloat = (IS_iPHONE_X ? 34.0 : 0.0)


// MARK:- 颜色
// 主色调 紫色
let MainColor = "#9A57FE"
// 深灰黑色
let DarkGrayColor = "#333333"
// 灰黑色
let LightDarkGrayColor = "#666666"
// 浅灰色
let LightGrayColor = "#999999"
// 淡灰色
let LitterGrayColor = "#CACACA"
// 浅橙色
let LightOrangeColor = "#FEAD21"





extension UIDevice {
    public func isX() -> Bool {
//        if UIScreen.main.bounds.height == 812 {
//            return true
//        }
//
//        return false
        
        let screenHeight = UIScreen.main.nativeBounds.size.height;
        if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
            return true
        }
        return false
        
    }
}


// MARK: Log
func Log<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName):(\(lineNum))-\(message)")
    
    #endif
}

// MARK: 十六进制颜色值转换UIColor
func HexColor(_ hex: String) -> UIColor {

    var cString = hex.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let length = (cString as NSString).length
    //错误处理
    if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
        return UIColor.white
    }
    if cString.hasPrefix("#"){
        cString = (cString as NSString).substring(from: 1)
    }
    //字符串截取
    var range = NSRange()
    range.location = 0
    range.length = 2
    let rString = (cString as NSString).substring(with: range)
    range.location = 2
    let gString = (cString as NSString).substring(with: range)
    range.location = 4
    let bString = (cString as NSString).substring(with: range)
    //存储转换后的数值
    var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
    //进行转换
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    //根据颜色值创建UIColor
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

func HexColor(hex: String, alpha: CGFloat) -> UIColor {

    var cString = hex.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let length = (cString as NSString).length
    //错误处理
    if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
        return UIColor.white
    }
    if cString.hasPrefix("#"){
        cString = (cString as NSString).substring(from: 1)
    }
    //字符串截取
    var range = NSRange()
    range.location = 0
    range.length = 2
    let rString = (cString as NSString).substring(with: range)
    range.location = 2
    let gString = (cString as NSString).substring(with: range)
    range.location = 4
    let bString = (cString as NSString).substring(with: range)
    //存储转换后的数值
    var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
    //进行转换
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    //根据颜色值创建UIColor
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
}

func ColorWithRGB(r: Float, g: Float, b: Float) -> UIColor {
    //根据颜色值创建UIColor
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}





