//
//  NetworkTools.swift
//  Swift_WB
//
//  Created by mac on 2020/7/1.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import AFNetworking
import CLToast

//" https://moushao.mx5918.com"
let BaseUrl = "http://192.168.0.191"


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
        return tools
        
    }()
}

// MARK:- 封装请求方法
extension NetworkTools {
    func request(urlString: String, method: MethodType, parameters: [String : AnyObject]?, finished: @escaping(_ reslut: AnyObject?, _ error: Error?) -> ()) {
        
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
}

extension NetworkTools {
    // 请求token
    func loadAccessToken(code: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : redirect_uri] as [String : AnyObject]
        
        
        request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
            finished(result as? [String : AnyObject], error)
        }
    }
    
    // 用户信息
    func loadUserInfo(access_token : String , uid : String , finished : @escaping(_ result: [String : AnyObject]? , _ error : Error?) -> ()) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        let parameters = ["access_token" : access_token, "uid" : uid] as [String : AnyObject]
        
        request(urlString: urlString, method: .GET, parameters: parameters) { (result, error) in
            finished(result as? [String : AnyObject], error)
        }
    }
    
    // 首页数据
//    func loadHomeStatus(since_id : Int, mix_id : Int, finished: @escaping(_ reslut: [[String: AnyObject]]?, _ error: Error?) -> ()) {
//        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        let parameters = ["access_token" : (UserAccountViewModel.shareInstance.account?.access_token)!, "since_id" : since_id, "mix_id" : mix_id] as [String : Any]
//        
//        request(urlString: urlString, method: .GET, parameters: parameters as [String : AnyObject]) { (result, error) in
//            
//            guard let resultDic = result as? [String : AnyObject] else {
//                return
//            }
//            
//            finished(resultDic["statuses"] as? [[String : AnyObject]], error)
//        }
//    }
    
}

