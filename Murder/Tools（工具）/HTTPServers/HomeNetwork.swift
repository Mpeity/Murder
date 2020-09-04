//
//  HomeNetwork.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/7.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


//MARK:- 首页列表接口
private let home_page_url = "/api/index/home_page"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* page_no  [int]        页码
* page_size [int]        条数
*/
func loadHomeData(page_no: Int, page_size: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = home_page_url
    let parameters = ["page_no" : page_no, "page_size": page_size] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 进入房间接口
private let join_room_url = "/api/room/join_room"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* room_id [int]    是    房间
* room_password复制 [string]    是    房间密码
*/
func joinRoomRequest(room_id: Int, room_password: String?, hasPassword: Bool, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = join_room_url
    var parameters = [String : AnyObject]()
    if hasPassword {
        parameters = ["room_id" : room_id, "room_password": room_password!] as [String : AnyObject]
    } else {
        parameters = ["room_id" : room_id] as [String : AnyObject]
    }
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 检测房间是否需要密码
private let room_check_password_url = "/api/room/room_check_password"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* room_id [int]    是    房间ID
*/
func roomCheckPassword(room_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = room_check_password_url
    let parameters = ["room_id" : room_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 剧本详情
private let script_url = "/api/script/script"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* script_id [int]    是    剧本ID
*/
func scriptDetail(script_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = script_url
    let parameters = ["script_id" : script_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 免费获得剧本
private let user_get_script_url = "/api/script/user_get_script"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* script_id [int]    是    剧本ID
*/
func getScriptRequest(script_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = user_get_script_url
    let parameters = ["script_id" : script_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 创建房间
private let add_room_url = "/api/room/add_room"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* script_id [int]    是    剧本ID
* room_password [string]    否    4未纯数字密码
*/
func addRoomRequest(script_id: Int, hasPassword: Bool, room_password: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = add_room_url
    var parameters = [String : AnyObject]()
    if hasPassword {
        parameters = ["script_id" : script_id, "room_password": room_password] as [String : AnyObject]
    } else {
        parameters = ["script_id" : script_id] as [String : AnyObject]
    }
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 房间准备阶段
private let room_ready_url = "/api/room/room_ready"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* room_id [int]    是    房间ID
*/
func roomReadyRequest(room_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = room_ready_url
    let parameters = ["room_id" : room_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 房间加密/取消密码
private let room_password_url = "/api/room/room_password"
/** 验证验证码
* @params [参数名] [类型] [是否必传]
* room_id [int]    是    房间ID
* status [int]    是    状态【0加密必须传密码1解密不传密码】
* room_password [string]        房间密码
*/
func roomPasswordRequest(room_id: Int, status: Int, room_password: String?, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = room_password_url
    var parameters = [String : AnyObject]()
    if status == 0 { // 有密码
        parameters = ["room_id" : room_id, "status" : status, "room_password" : room_password!] as [String : AnyObject]
    } else {
        parameters = ["room_id" : room_id, "status" : status] as [String : AnyObject]
    }
    
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 剧本素材下载
let script_source_url = "/api/script/script_source"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * script_id [int]    是    剧本ID
 */
func scriptSourceRequest(script_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = script_source_url
    let parameters = ["script_id" : script_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 选择角色
private let choice_role_url = "/api/room/choice_role"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * script_role_id [int]    是    选择的角色ID
 */
func choiceRoleRequest(room_id: Int, script_role_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = choice_role_url
    let parameters = ["room_id" : room_id, "script_role_id" : script_role_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 游戏准备
private let game_start_url = "/api/game/game_start"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * status [int]    是    状态【1准备0取消准备】
 */
func gameStartRequest(room_id: Int, status: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = game_start_url
    let parameters = ["room_id" : room_id, "status": status] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 游戏节点数据
private let game_ing_url = "/api/game/game_ing"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * script_node_id [int]    是    剧本节点ID
 */
func gameIngRequest(room_id: Int, script_node_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = game_ing_url
    let parameters = ["room_id" : room_id, "script_node_id": script_node_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 搜证
private let search_clue_url = "/api/game/search_clue"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * script_place_id [int]    是    地点ID
 * script_clue_id [int]      否  线索ID【可深入线索时查看】
 * script_node_id [int]    是    游戏节点ID
 */
func searchClueRequest(room_id: Int, script_place_id: Int, script_clue_id: Int?,script_node_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = search_clue_url
    var parameters = [:] as [String : AnyObject]
    if script_clue_id != nil {
        parameters = ["room_id" : room_id, "script_place_id": script_place_id, "script_clue_id" : script_clue_id, "script_node_id" : script_node_id] as [String : AnyObject]
    } else {
        parameters = ["room_id" : room_id, "script_place_id": script_place_id, "script_node_id" : script_node_id] as [String : AnyObject]
    }
    
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- websocket建立连接
private let bind_url = "/api/gatewaycon/bind"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * scene [int]    是    场景值【1房间准备数据ps:后续会增加】
 * client_id [string]    是    socket连接ID
 * datas [string]    是    json字符串；json字符串格式的 页面接口的请求参数
 */
func bindRequest(scene: Int,client_id: String,datas: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = bind_url
    let parameters = ["scene" : scene, "client_id": client_id, "datas": datas] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 游戏解散投票
private let game_dissolution_url = "/api/game/game_dissolution"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * status [int]    是    房间状态【3解散状态】
 */
func gameDissolutionRequest(room_id: Int, status: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = game_dissolution_url
    let parameters = ["room_id" : room_id, "status" : status] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 退出房间
private let out_room_url = "/api/room/out_room"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * script_place_id [int]    是    地点ID
 * script_clue_id [int]        线索ID【可深入线索时查看】
 */
func outRoomRequest(room_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = out_room_url
    let parameters = ["room_id" : room_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 结算信息
private let game_settlement_url = "/api/game/game_settlement"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 */
func gameSettlementRequest(room_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = game_settlement_url
    let parameters = ["room_id" : room_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}


//MARK:- 线索公开
private let clue_open_url = "/api/game/clue_open"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * script_clue_id [int]    是    线索ID
 * script_place_id [int]    是    地点ID
 * room_id [int]    是    房间ID
 * script_node_id [int]    是    游戏节点ID
 */
func clueOpenRequest(room_id: Int, script_clue_id: Int, script_place_id : Int, script_node_id: Int,  finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = clue_open_url
    let parameters = ["room_id" : room_id, "script_clue_id" : script_clue_id, "script_place_id" : script_place_id, "script_node_id": script_node_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 游戏角色准备
private let game_ready_url = "/api/game/game_ready"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 */
func gameReadyRequest(room_id: Int,current_script_node_id : Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = game_ready_url
    let parameters = ["room_id" : room_id, "current_script_node_id": current_script_node_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 投票
private let game_vote_url = "/api/game/game_vote"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * script_node_id [int]    是    游戏节点ID
 * script_question 复制 [int]    是    问题答案数据【格式额外说明】
 */
func gameVoteRequest(room_id: Int, script_node_id: Int, script_question: String, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = game_vote_url
    let parameters = ["room_id" : room_id, "script_node_id": script_node_id, "script_question" : script_question] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 投票结果
private let game_vote_result_url = "/api/game/game_vote_result"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 */
func gameVoteResultRequest(room_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = game_vote_result_url
    let parameters = ["room_id" : room_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 检测当前登录用户是否在游戏中
private let check_url = "/api/index/check"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 */
func checkUrlRequest(finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    let urlString = check_url
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters:  nil) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}

//MARK:- 游戏倒计时【异步调用】
private let game_countdown_url = "/api/game/game_countdown"
/** 注册接口
 * @params [参数名] [类型] [是否必传]
 * room_id [int]    是    房间ID
 * script_node_id [int]    是    游戏节点ID
 */
func gameCountdownRequest(room_id: Int, script_node_id: Int, finished: @escaping(_ reslut: [String: AnyObject]?, _ error: Error?) -> ()) {
    
    let urlString = game_countdown_url
    let parameters = ["room_id" : room_id, "script_node_id" : script_node_id] as [String : AnyObject]
    NetworkTools.shareInstance.requestWithToken(urlString: urlString, method: .POST, parameters: parameters) { (result, error) in
        finished(result as? [String : AnyObject], error)
    }
}
