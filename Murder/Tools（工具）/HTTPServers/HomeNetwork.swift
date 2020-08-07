//
//  HomeNetwork.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/7.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


//MARK:- 首页接口
private let home_page_url = "/api/index/home_page"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* email [string]    是    邮箱
* captcha [int]    是    重置密码验证码
* newpassword [string]    是    新密码
* repassword [string]    是    新密码确认密码
*/
func loadHomeData(email: String, password:String, repassword: String, captcha: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = home_page_url
    let parameters = ["email" : email, "captcha": captcha, "newpassword" : password, "repassword": repassword] as [String : AnyObject]
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


// 请求token
func loadAccessToken(code: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = "https://api.weibo.com/oauth2/access_token"
    let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : redirect_uri] as [String : AnyObject]
    
    
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

// 用户信息
func loadUserInfo(access_token : String , uid : String , finished : @escaping(_ result: [String : AnyObject]? , _ error : Error?) -> ()) {
    let urlString = "https://api.weibo.com/2/users/show.json"
    let parameters = ["access_token" : access_token, "uid" : uid] as [String : AnyObject]
    
    NetworkTools.shareInstance.request(urlString: urlString, method: .GET, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}
