//
//  MineNetwork.swift
//  Murder
//
//  Created by m.a.c on 2020/8/13.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

//MARK:- 我的|用户信息
private let mine_url = "/api/user/mine"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 */
func mineInfoRequest(finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = mine_url
    let parameters = [:] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK: - 应用反馈
private let feedback_url = "/api/user/feedback"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * email [string]        email
 * content [string]    是    反馈内容
 */
func feedbackRequest(email: String, content: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = feedback_url
    var parameters = [:] as [String : AnyObject]
    if email == "" || email == " " {
        parameters = ["content": content] as [String : AnyObject]
    } else {
        parameters = ["email": email, "content": content] as [String : AnyObject]
    }
//    let parameters = ["email": email, "content": content] as [String : AnyObject]
    
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK: - 退出登录
private let login_out_url = "/api/user/login_out"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * email [string]        email
 * content [string]    是    反馈内容
 */
func loginOutRequest(email: String, content: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = login_out_url
    let parameters = ["email": email, "content": content] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 开局记录详情
private let room_log_info_url = "/api/script/room_log_info"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间号
 */
func roomLogInfoRequest(room_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = room_log_info_url
    let parameters = ["room_id": room_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 开局记录列表
private let script_log_url = "/api/script/script_log"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * page_no [int]        页码
 * page_size [int]        条数
 */
func scriptLogRequest(page_no: Int, page_size: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = script_log_url
    let parameters = ["page_no": page_no, "page_size": page_size] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 关于我们
private let config_url = "/api/index/config"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * page_no [int]        页码
 * page_size [int]        条数
 */
func configRequest(identity: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = config_url
    let parameters = ["identity": identity] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

