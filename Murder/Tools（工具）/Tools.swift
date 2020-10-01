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
import CLToast
import SVProgressHUD

//MARK:- 获取文本高度
func getHeight(string: String, width:CGFloat)-> CGSize {
    let label = UILabel()
    label.backgroundColor = UIColor.gray
    label.text = string
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = HexColor("#666666")
    label.textAlignment = .left
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
    return size
}

//MARK:- 富文本
func setMutableString(content: String, _ color: UIColor = HexColor("#666666") , fontSize: CGFloat = 12) -> NSAttributedString? {
//    let myMutableString = try! NSMutableAttributedString(data: (content.data(using: String.Encoding.unicode))!, options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType:NSMutableAttributedString.DocumentType.html], documentAttributes: nil)
//
//
//    let range = NSMakeRange(0, myMutableString.length)
//    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
//    myMutableString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)], range: range)
    
    
    guard let news = content.removingPercentEncoding,let data = news.data(using: .unicode) else{return nil}
    let att = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html]
    guard let attStr = try? NSMutableAttributedString(data: data, options: att, documentAttributes: nil) else{return nil}
    let range = NSMakeRange(0, attStr.length)
    attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)], range: range)
    
    return attStr
}

func getDateStr(timeStamp:String) -> String {
    let interval:TimeInterval = TimeInterval.init(timeStamp)!
    let date = Date(timeIntervalSince1970: interval*0.001)
    let dateformatter = DateFormatter()
    //自定义日期格式
    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateformatter.string(from: date as Date)
}

func getTime() -> String {
    //获取当前时间
    let now = NSDate()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
    print("当前日期时间：\(dformatter.string(from: now as Date))")
     
    //当前时间的时间戳
    let timeInterval:TimeInterval = now.timeIntervalSince1970*1000
    let timeStamp = Int(timeInterval)
    print("当前时间的时间戳：\(timeStamp)")
    return String(timeStamp)
}

func imageWithImage(image: UIImage, size: CGSize) -> UIImage {
    UIGraphicsBeginImageContext(size)
    image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
    return newImage!
}

// JSONString转换为字典
func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
   let jsonData:Data = jsonString.data(using: .utf8)!
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
   if dict != nil {
       return dict as! NSDictionary
   }

   return NSDictionary()
}

func getArrayFromJSONString(jsonString:String) ->NSArray{
   let jsonData:Data = jsonString.data(using: .utf8)!
   let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
   if array != nil {
       return array as! NSArray
   }
   return array as! NSArray
}
/**
字典转换为JSONString
 
- parameter dictionary: 字典参数
 
- returns: JSONString
*/
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
   if (!JSONSerialization.isValidJSONObject(dictionary)) {
       print("无法解析出JSONString")
       return ""
   }
   let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
   let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
   return JSONString! as String

}

//数组转json
func getJSONStringFromArray(array:NSArray) -> String {
    
   if (!JSONSerialization.isValidJSONObject(array)) {
       print("无法解析出JSONString")
       return ""
   }
    
   let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData?
   let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
   return JSONString! as String    
}


//MARK:- 居中弹框
func showToastCenter(msg: String, _ cornerRadius:CGFloat = 25) {
    CLToastManager.share.cornerRadius = cornerRadius
    CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
    CLToast.cl_show(msg: msg)
}


/**
 获取手机电池状态

 @return 电池状态字符串
 
 */

func batterState(commonView: UIView, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, cornerRadius: CGFloat, lineWidth: CGFloat, strokeColor: UIColor) {
    
    let path1 = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: width, height: height), cornerRadius: cornerRadius)
    let batterLayer = CAShapeLayer()
    batterLayer.lineWidth = lineWidth
    batterLayer.strokeColor = strokeColor.cgColor
    batterLayer.fillColor = UIColor.clear.cgColor
    batterLayer.path = path1.cgPath
    commonView.layer.addSublayer(batterLayer)
    
    let path2 = UIBezierPath()
    path2.move(to: CGPoint(x: x+width+1, y: y+height/3))
    path2.addLine(to: CGPoint(x: x+width+1, y: y+height*2/3))

    let shapeLayer = CAShapeLayer()
    shapeLayer.lineWidth = 2
    shapeLayer.strokeColor = strokeColor.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.path = path2.cgPath
    commonView.layer.addSublayer(shapeLayer)

    
    // 绘制进度
    //设置batteryMonitoringEnabled为YES来获取电池信息
    UIDevice.current.isBatteryMonitoringEnabled = true
    
    //电池百分比
    let batteryLevel  = UIDevice.current.batteryLevel
//    let batteryStatus  = NSString(format:"%0.0f%%",batteryLevel*100) as String
    
    let bgView = UIView(frame: CGRect(x: lineWidth, y: y+CGFloat(lineWidth), width: CGFloat(batteryLevel)*(width-2*lineWidth), height: height-CGFloat(lineWidth*2)))
    bgView.layer.cornerRadius = 1
    bgView.backgroundColor = UIColor.white
    commonView.addSubview(bgView)

    
    let batteryView = UIView(frame: CGRect(x: lineWidth, y: y+CGFloat(lineWidth), width: CGFloat(batteryLevel)*(width-2*lineWidth), height: height-CGFloat(lineWidth*2)))
    batteryView.layer.cornerRadius = 1
    batteryView.backgroundColor = UIColor.init(red: 0.324, green: 0.941, blue: 0.413, alpha: 1.0)
    
    commonView.addSubview(batteryView)


}

func getiPhoneBatteryState() -> String {
    

    
    //设置batteryMonitoringEnabled为YES来获取电池信息
    UIDevice.current.isBatteryMonitoringEnabled = true
    
    //电池百分比
    let batteryLevel  = UIDevice.current.batteryLevel
    let batteryStatus  = NSString(format:"%0.0f%%",batteryLevel*100) as String
    
    Log(batteryStatus)
    
    let phoneBatteryState = UIDevice.current.batteryState
    
    var state:String
    switch (phoneBatteryState) {
        case .unknown:
            state = "未知电池状态"
            break;
        case .unplugged:
            state = "未充电，使用电池";
            break;
        case .charging:
            state = "充电中，并且电量小于 100%";
            break;
        case .full:
            state = "充电中, 电量已达 100%";
            break;
        default:
            state = "未知电池状态";
            break;
    }
    return state;
}

//func getSignalStrength() {
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
//    NSString *dataNetworkItemView = nil;
//
//    for (id subview in subviews) {
//        if([subview isKindOfClass:    [NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
//        dataNetworkItemView = subview;
//        break;
//        }
//     }
//    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
//
//    NSLog(@"signal %d", signalStrength);
//}


func getNetworkType() {
//
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//    for (id subview in subviews) {
//        if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//        int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
//        switch (networkType) {
//            case 0:
//                NSLog(@"NONE");
//                break;
//            case 1:
//                NSLog(@"2G");
//                break;
//            case 2:
//                NSLog(@"3G");
//                break;
//            case 3:
//                NSLog(@"4G");
//                break;
//            case 5:
//            {
//                NSLog(@"WIFI");
//            }
//                break;
//            default:
//                break;
//            }
//        }
//    }
    
}


//MARK:- 获取设备网络状态
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
    attributedStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragaraphStryle], range: NSMakeRange(0, (text as NSString).length))
    // 生成一个统一计算文本高度的Label
    let stringLabel = UILabel()
    stringLabel.numberOfLines = 0
    stringLabel.font = font
    stringLabel.attributedText = attributedStr
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

