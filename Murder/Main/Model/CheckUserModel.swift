//
//  CheckUserModel.swift
//  Murder
//
//  Created by m.a.c on 2020/9/1.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

// 准备阶段
class ReadyResult : NSObject {

    var readyOk : Int?
    var roomId : Int?
    var scriptRoleId : Int?
    var status : Int?
    var scriptId : Int?
    


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        readyOk = dictionary["ready_ok"] as? Int
        roomId = dictionary["room_id"] as? Int
        scriptRoleId = dictionary["script_role_id"] as? Int
        status = dictionary["status"] as? Int
        scriptId = dictionary["script_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if readyOk != nil{
            dictionary["ready_ok"] = readyOk
        }
        if roomId != nil{
            dictionary["room_id"] = roomId
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        if status != nil{
            dictionary["status"] = status
        }
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        return dictionary
    }
}

// 游戏中
class GameResult : NSObject {

    var roomId : Int?
    var roomScriptNodeId : Int?
    var scriptRoleId : Int?
    var status : Int?
    var scriptId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        roomId = dictionary["room_id"] as? Int
        roomScriptNodeId = dictionary["room_script_node_id"] as? Int
        scriptRoleId = dictionary["script_role_id"] as? Int
        status = dictionary["status"] as? Int
        scriptId = dictionary["script_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if roomId != nil{
            dictionary["room_id"] = roomId
        }
        if roomScriptNodeId != nil{
            dictionary["room_script_node_id"] = roomScriptNodeId
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        if status != nil{
            dictionary["status"] = status
        }
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        return dictionary
    }
}


class CheckUserModel : NSObject {

    var readyResult : ReadyResult?
    var gameResult : GameResult?
    var stage : Int?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        stage = dictionary["stage"] as? Int
        
        switch stage {
        case 0:
            
            break
        case 1:
            if let resultData = dictionary["result"] as? [String:Any]{
                readyResult = ReadyResult(fromDictionary: resultData)
            }
            break
        case 2:
            if let resultData = dictionary["result"] as? [String:Any]{
                gameResult = GameResult(fromDictionary: resultData)
            }
            break
        default:
            break
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if readyResult != nil {
            dictionary["result"] = readyResult!.toDictionary()
        }
        if gameResult != nil {
            dictionary["result"] = gameResult!.toDictionary()
        }
//        if result != nil{
//            dictionary["result"] = result.toDictionary()
//        }
        if stage != nil{
            dictionary["stage"] = stage
        }
        return dictionary
    }
}
