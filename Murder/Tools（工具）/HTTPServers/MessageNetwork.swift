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


//MARK:- 消息新增
private let add_msg_url = "/api/msg/add_msg"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * type [int]    是    消息类型【0text1剧本邀请2剧本3好友申请】
 * content [string]    是    消息内容
 * receive_id [int]    是    接收用户ID
 */
func addMsgRequest(type: Int, receive_id: Int, content: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = add_msg_url
    let parameters = ["type": type, "receive_id": receive_id, "content": content] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 当前登录用户是否有新消息
private let msg_no_read_num_url = "/api/msg/msg_no_read_num"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 */
func msgNoReadRequest(finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = msg_no_read_num_url
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: nil) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 消息对话
private let msg_talk_url = "/api/msg/msg_talk"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * receive_id [string]    是    对方用户ID
 * page_no [int]    是    页码
 * page_size [int]    是    条数
 */
func msgTalkListRequest(receive_id: Int, page_no: Int, page_size: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {    
    let urlString = msg_talk_url
//    let parameters = ["receive_id": receive_id,"page_no": page_no, "page_size": page_size] as [String : AnyObject]
    
    let parameters = ["receive_id": receive_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 消息对话
private let update_is_read_url = "/api/msg/update_is_read"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * receive_id [string]    是    对方用户ID
 */
func updateIsReadRequest(receive_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = update_is_read_url
    let parameters = ["receive_id": receive_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 获取历史纪录
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * friend_apply_id [int]    是    好友ID
 */
func getRTMHistory(source: String , destination: String, start_time: String, end_time: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = "https://api.agora.io/dev/v2/project/\(AgoraKit_AppId)/rtm/message/history/query"
    let parameters = [
        "filter": ["source": source,"destination": destination,"start_time" : start_time,"end_time" : end_time],"offset" : 100,"limit" : 20,"order" : "asc"] as [String : AnyObject]
    
    NetworkTools.shareInstance.requestOther(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}








func getRTMHistoryQuery(handle: String ,finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = "https://api.agora.io/dev/v2/project/\(AgoraKit_AppId)/rtm/message/history/query"    
    let parameters = ["handle": handle] as [String : AnyObject]
    
    NetworkTools.shareInstance.requestOther(urlString: urlString, method: .GET, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}






//MARK:- 举报
private let friend_report_url = "/api/friend/report"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * report_id [int]    是    被举报用户ID
 * report_type [string]    是    举报理由
 * report_content [string]    是    内容
 * report_images [string]    是    图片：json 数组格式
 */
func friendReportRequest(report_id: Int, report_type: String, report_content: String, report_images: String?, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = friend_report_url
    var parameters = [ : ] as! [String : AnyObject]
    if report_images != nil, report_images != "" {
         parameters = ["report_id": report_id,"report_type": report_type, "report_content": report_content, "report_images": report_images!] as [String : AnyObject]
    } else {
         parameters = ["report_id": report_id,"report_type": report_type, "report_content": report_content] as [String : AnyObject]
    }
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters ) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 拉黑
private let friend_block_url = "/api/friend/block"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * friend_id [int]    是    拉黑的用户ID
 */
func friendBlockRequest(friend_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = friend_block_url
    let parameters = ["friend_id": friend_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 判断用户是否已被我拉黑
private let friend_is_block_url = "/api/friend/is_block"
/** 消息列表
 * @params [参数名] [类型] [是否必传]
 * friend_id [int]    是    拉黑的用户ID
 */
func friendIsBlockRequest(friend_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = friend_is_block_url
    let parameters = ["friend_id": friend_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}







