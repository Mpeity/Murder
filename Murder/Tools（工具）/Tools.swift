//
//  Tools.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



enum NetWorkType {
    case NetworkStatesNone // 没有网络
    case NetworkStates2G // 2G
    case NetworkStates3G // 3G
    case NetworkStates4G // 4G
    case NetworkStatesWIFI // WIFI
}



func AlamofiremonitorNet() {
 let manager = NetworkReachabilityManager(host: "www.apple.com")
    manager?.listener = { status in
        print("网络状态: \(status)")
        if status == .reachable(.ethernetOrWiFi) { //WIFI
            print("wifi")
        } else if status == .reachable(.wwan) { // 蜂窝网络
            print("4G")
        } else if status == .notReachable { // 无网络
            print("无网络")
        } else { // 其他
            
        }
        
    }
    manager?.startListening()//开始监听网络
   }


// 检测网络状态
func currentNetworkType() -> NetWorkType {
    let array :NSArray = (((UIApplication.shared.value(forKeyPath: "statusBar") as AnyObject).value(forHTTPHeaderField: "foregroundView") as AnyObject).subviews)! as NSArray
    var states :NetWorkType = .NetworkStatesNone
    for info in array {
        if (info as AnyObject).isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
            let networkType = ((info as AnyObject).value(forHTTPHeaderField: "dataNetworkType")! as AnyObject).integerValue
            switch (networkType) {
            case 0:
                states = .NetworkStatesNone;
                //无网模式
                break;
            case 1:
                states = .NetworkStates2G;
                break;
            case 2:
                states = .NetworkStates3G;
                break;
            case 3:
                states = .NetworkStates4G;
                break;
            case 5:
                states = .NetworkStatesWIFI;
                break;
            default:
                break;
            }

        }
    }
    return states

}


func getSignalStrength() {
    let array :NSArray = (((UIApplication.shared.value(forKeyPath: "statusBar") as AnyObject).value(forHTTPHeaderField: "foregroundView") as AnyObject).subviews)! as NSArray
    var dataNetworkItemView: NSString = ""
    for info in array {
        if (info as AnyObject).isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!) {
            dataNetworkItemView = info as! NSString
            break
        }
    }
    let signalStrength = dataNetworkItemView.value(forKey: "_wifiStrengthBars") as! Int
    
    Log("signalStrength= \(signalStrength)")
}


//指定字符 指定颜色并加上下划线
func getNSAttributedString(str: String, color: String) -> NSAttributedString {
    let myMutableString = NSMutableAttributedString(string: str)
    let range = NSMakeRange(0, myMutableString.length)
    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: HexColor(color), range: range)
    myMutableString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
    return myMutableString
}

/**
* 计算 文本的宽度
*/
func labelWidth(text: String, height: CGFloat, fontSize: CGFloat) -> CGFloat {
    let size = CGSize(width: 0, height: height)
    let font = UIFont.systemFont(ofSize: fontSize)
    let attributes = [NSAttributedString.Key.font: font]
    let labelSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    return labelSize.width
}

/**
 * 计算 文本的高度
 */
func stringSizeWithString(text: String?, width: CGFloat, font: UIFont) -> CGSize {
    
    guard let text = text else {
        return CGSize.zero
    }
    // 文本高度
    let attributedStr = NSMutableAttributedString(string: text)
    let paragaraphStryle = NSMutableParagraphStyle()
    paragaraphStryle.lineSpacing = 5
    attributedStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragaraphStryle], range: NSMakeRange(0, text.lengthOfBytes(using: .utf8)))
    // 生成一个统一计算文本高度的Label
    let stringLabel = UILabel()
    stringLabel.numberOfLines = 0
    stringLabel.font = font
    stringLabel.attributedText = attributedStr
//    return stringLabel.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
    
    return stringLabel.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))

}

func stringSingleHeightWithWidth(text: String?, width: CGFloat, font: UIFont) -> CGFloat {
    // 文本高度
    let size = stringSizeWithString(text: text, width: width, font: font)
    return size.height
}

/**
 * 自定义导航栏
 */
func setNavigationBar(superView: UIView, titleLabel:UILabel, leftBtn: UIButton,  rightBtn: UIButton?) {
    let bgView = UIView()
    bgView.backgroundColor = UIColor.clear
    superView.addSubview(bgView)
    bgView.snp.makeConstraints { (make) in
        make.height.equalTo(44)
        if #available(iOS 11.0, *) {
            make.top.equalTo(superView.safeAreaLayoutGuide.snp.top)
        } else {
            // Fallback on earlier versions
            make.top.equalToSuperview()
        }
        make.left.right.equalToSuperview()
        
    }
    
    bgView.addSubview(leftBtn)
    leftBtn.snp.makeConstraints { (make) in
        make.height.equalTo(44)
        make.width.equalTo(47)
        make.left.equalToSuperview()
        make.top.equalToSuperview()
    }
    leftBtn.setImage(UIImage(named: "back_white"), for: .normal)
    
    if rightBtn != nil {
        bgView.addSubview(rightBtn!)
        rightBtn!.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(47)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    
    
    bgView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
        make.height.equalTo(44)
        make.top.equalToSuperview()
        if rightBtn != nil {
            make.left.equalTo(leftBtn.snp_right).offset(10)
            make.right.equalTo(rightBtn!.snp_left).offset(-10)
        } else {
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
    }
    titleLabel.textColor = UIColor.white
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
}

