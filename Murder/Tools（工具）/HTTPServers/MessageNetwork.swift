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
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
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
    
    let urlString = msg_list_url
    let parameters = ["page_no": page_no, "page_size": page_size] as [String : AnyObject]
    NetworkTools.shareInstance.request(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}
