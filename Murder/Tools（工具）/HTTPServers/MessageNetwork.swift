//
//  MessageNetwork.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/28.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

//MARK:- 消息列表
private let msg_list_url = "/api/msg/msg_list"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * page_no [int]    是    页码
 * page_size [int]    是    条数
 */
func msgListRequest(page_no: Int, page_size: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = msg_list_url
    let parameters = ["page_no": page_no, "page_size": page_size] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 好友列表
private let friend_list_url = "/api/friend/friend_list"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * page_no [int]    是    页码
 * page_size [int]    是    条数
 */
func friendListRequest(page_no: Int, page_size: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = friend_list_url
    let parameters = ["page_no": page_no, "page_size": page_size] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 删除好友
private let del_friend_url = "/api/friend/del_friend"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * friend_id [int]    是    好友ID
 */
func deleteFriendRequest(friend_id: Int ,finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = del_friend_url
    let parameters = ["friend_id": friend_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 添加好友时搜索用户
private let user_find_url = "/api/friend/user_find"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * user_id [int]    是    用户ID
 */
func userFindRequest(user_id: Int ,finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = user_find_url
    let parameters = ["user_id": user_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 申请添加好友
private let apply_friend_url = "/api/friend/apply_friend"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * receive_id [int]    是    好友ID
 */
func applyFriendRequest(receive_id: Int ,finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = apply_friend_url
    let parameters = ["receive_id": receive_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 好友申请列表
private let friend_apply_list_url = "/api/friend/friend_apply_list"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * page_no [int]    是    页码
 * page_size [int]    是    条数
 */
func friendApplyListRequest(page_no: Int, page_size: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = friend_apply_list_url
    let parameters = ["page_no": page_no, "page_size": page_size] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 拒绝好友申请
private let refuse_friend_apply_url = "/api/friend/refuse_friend_apply"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * friend_apply_id [int]    是    好友ID
 */
func refuseApplyFriendRequest(friend_apply_id: Int ,finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = refuse_friend_apply_url
    let parameters = ["friend_apply_id": friend_apply_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 通过好友申请
private let adopt_friend_apply_url = "/api/friend/adopt_friend_apply"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * friend_apply_id [int]    是    好友ID
 */
func passApplyFriendRequest(friend_apply_id: Int ,finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = adopt_friend_apply_url
    let parameters = ["friend_apply_id": friend_apply_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 获取历史纪录

/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * friend_apply_id [int]    是    好友ID
 */
func getRTMHistory(friend_apply_id: Int ,finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = "https://api.agora.io/dev/v2/project/<appid>/rtm/message/history/query"
    let parameters = [
        "filter": ["source": "userA","destination": "userB","start_time" : "2019-08-01T01:22:10Z","end_time" : "2019-08-01T01:32:10Z"],"offset" : 100,"limit" : 20,"order" : "asc"] as [String : AnyObject]
    
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}




