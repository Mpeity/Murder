//
//  NetworkTools.swift
//  Swift_WB
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import AFNetworking
import CLToast
import SVProgressHUD

//let SocketUrl = "ws://192.168.0.189"
//let BaseUrl = "http://192.168.0.189"

let BaseUrl = "https://mousha.mx5918.com"
let SocketUrl = "ws://mousha.mx5918.com"

enum MethodType {
    case GET
    case POST
}

class NetworkTools: AFHTTPSessionManager {
    // 线程安全
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tools.responseSerializer.acceptableContentTypes?.insert("application/json")
        tools.responseSerializer.acceptableContentTypes?.insert("application/octet-stream")
        
        return tools
        
    }()
}


// MARK:- 封装请求方法
extension NetworkTools {
    
    func uploadImage(urlString: String, imageData: Data, parameters: [String : AnyObject]?, finished: @escaping(_ reslut: AnyObject?, _ error: Error?) -> ()) {
        
        let key = UserAccountViewModel.shareInstance.account?.key as AnyObject?            
        NetworkTools.shareInstance.requestSerializer.setValue((key as! String), forHTTPHeaderField: "key")
        
        let urlStr = BaseUrl + urlString
        let successCallBack = { (task: URLSessionDataTask , result: Any?) -> Void in
            if let resultData: [String : AnyObject]  = result as? [String : AnyObject] {
                if resultData["code"]!.isEqual(1) {
                    finished(result as AnyObject?, nil)
                } else { // code 值处理
                    CLToastManager.share.cornerRadius = 25
                    CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
                    CLToast.cl_show(msg: resultData["msg"]! as! String)
                }
            }
        }
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) -> Void in
            finished(nil, error)
        }
        post(urlStr, parameters: parameters, constructingBodyWith: { (formData) in
            
            formData.appendPart(withFileData: imageData, name: "file", fileName: "imageFile.jpg", mimeType: "image/jpg")
        }, success: successCallBack, failure: failureCallBack)
        
        
    }
    
    func requestWithToken(urlString: String, method: MethodType, parameters: [String : AnyObject]?, finished: @escaping(_ reslut: AnyObject?, _ error: Error?) -> ()) {

        let key = UserAccountViewModel.shareInstance.account?.key as AnyObject?
        
        NetworkTools.shareInstance.requestSerializer.setValue((key as! String), forHTTPHeaderField: "key")
        
        let urlStr = BaseUrl + urlString
        let successCallBack = { (task: URLSessionDataTask , result: Any?) -> Void in            
            if let resultData: [String : AnyObject]  = result as? [String : AnyObject] {
                SVProgressHUD.dismiss()
                if resultData["code"]!.isEqual(1) {
                    finished(result as AnyObject?, nil)
                } else if resultData["code"]!.isEqual(2011) {
                    // 请登录
                    UIApplication.shared.keyWindow?.rootViewController =  BaseNavigationViewController(rootViewController: LoginViewController())
                    userLogout()
                    AgoraRtmLogout()
                    
                    CLToastManager.share.cornerRadius = 25
                    CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
                    CLToast.cl_show(msg: resultData["msg"]! as! String)
                } else { // code 值处理
                    
                    CLToastManager.share.cornerRadius = 25
                    CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
                    CLToast.cl_show(msg: resultData["msg"]! as! String)
                }
            }
        }
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) -> Void in
            finished(nil, error)
            SVProgressHUD.dismiss()
        }
    
        if method == .GET {
            get(urlStr, parameters: parameters, success:successCallBack, failure:failureCallBack)
        } else {
            post(urlStr, parameters: parameters, success: successCallBack, failure: failureCallBack)
        }
        
    }
    
    func request(urlString: String, method: MethodType, parameters: [String : AnyObject]?, finished: @escaping(_ reslut: AnyObject?, _ error: Error?) -> ()) {
        
        let urlStr = BaseUrl + urlString
                
        let successCallBack = { (task: URLSessionDataTask , result: Any?) -> Void in
            SVProgressHUD.dismiss()
            if let resultData: [String : AnyObject]  = result as? [String : AnyObject] {
                
                if resultData["code"]!.isEqual(1) {
                    
                    finished(result as AnyObject?, nil)

                } else { // code 值处理
                    CLToastManager.share.cornerRadius = 25
                    CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
                    CLToast.cl_show(msg: resultData["msg"]! as! String)                    
                }
            }
        }
        
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) -> Void in
            SVProgressHUD.dismiss()
            finished(nil, error)
        }
    
        
        
        if method == .GET {
            get(urlStr, parameters: parameters, success:successCallBack, failure:failureCallBack)
        } else {
            
            post(urlStr, parameters: parameters, success: successCallBack, failure: failureCallBack)
//            post(urlString, parameters: parameters, success: { (URLSessionDataTask , result: Any?) in
//                print(result!)
//
//            }) { (task: URLSessionDataTask?, error: Error) in
//                print(error)
//
//            }
        }
        
    }
    
    func requestOther(urlString: String, method: MethodType, parameters: [String : AnyObject]?, finished: @escaping(_ reslut: AnyObject?, _ error: Error?) -> ()) {
        let urlStr = urlString
        let successCallBack = { (task: URLSessionDataTask , result: Any?) -> Void in
            
            if let resultData: [String : AnyObject]  = result as? [String : AnyObject] {
                if resultData["code"]!.isEqual(1) {
                    finished(result as AnyObject?, nil)
                } else { // code 值处理
                    CLToastManager.share.cornerRadius = 25
                    CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
                    CLToast.cl_show(msg: resultData["msg"]! as! String)
                }
            }
        }
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) -> Void in
            finished(nil, error)
        }
        if method == .GET {
            get(urlStr, parameters: parameters, success:successCallBack, failure:failureCallBack)
        } else {
            post(urlStr, parameters: parameters, success: successCallBack, failure: failureCallBack)
        }
    }
}


