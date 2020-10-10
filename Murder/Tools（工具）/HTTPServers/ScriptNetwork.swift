//
//  ScriptNetwork.swift
//  Murder
//
//  Created by m.a.c on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

//MARK:- 剧本列表
private let script_list_url = "/api/script/script_list"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * page_no [int]        页码
 * page_size [int]        条数【默认15】
 * people_num [int]        人数
 * tag_id [int]    是    题材ID
 * difficult [int]    是    难度【0入门1简单2中等3困难4烧脑-1全部】
 * pay_type [int]    是    料金【0免费1付费-1全部】
 */
func scriptListRequest(page_no: Int, page_size: Int, people_num: Int, tag_id: Int, difficult: Int, pay_type: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = script_list_url
    let parameters = ["page_no" : page_no, "page_size": page_size, "people_num" : people_num, "tag_id": tag_id, "difficult": difficult, "pay_type": pay_type] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 剧本题材列表
private let script_tag_list_url = "/api/script/script_tag_list"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * page_no [int]        页码
 * page_size [int]        条数【默认15】
 */
func scriptTagListRequest(page_no: Int, page_size: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = script_tag_list_url
    let parameters = ["page_no" : page_no, "page_size": page_size] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

