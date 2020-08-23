//
//  GamePlayModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class GamePlayRoomModel : NSObject {

    var roomId : Int?
    var scriptId : Int?
    var status : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        roomId = dictionary["room_id"] as? Int
        scriptId = dictionary["script_id"] as? Int
        status = dictionary["status"] as? Int
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
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }
}

class GamePlayModel : NSObject{
    

    var script : GamePlayScriptModel!
    var room : GamePlayRoomModel!
    var scriptNodeResult : GPScriptNodeResultModel!
    var scriptRoleList : [GPScriptRoleListModel]!
    var gameUserClueList : [GameUserClueListModel]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        gameUserClueList = [GameUserClueListModel]()
        if let gameUserClueListArray = dictionary["game_user_clue_list"] as? [[String:Any]]{
            for dic in gameUserClueListArray{
                let value = GameUserClueListModel(fromDictionary: dic)
                gameUserClueList.append(value)
            }
        }
        if let roomData = dictionary["room"] as? [String:Any]{
            room = GamePlayRoomModel(fromDictionary: roomData)
        }
        
        if let scriptData = dictionary["script"] as? [String:Any]{
            script = GamePlayScriptModel(fromDictionary: scriptData)
        }
        if let scriptNodeResultData = dictionary["script_node_result"] as? [String:Any]{
            scriptNodeResult = GPScriptNodeResultModel(fromDictionary: scriptNodeResultData)
        }
        scriptRoleList = [GPScriptRoleListModel]()
        if let scriptRoleListArray = dictionary["script_role_list"] as? [[String:Any]]{
            for dic in scriptRoleListArray{
                let value = GPScriptRoleListModel(fromDictionary: dic)
                scriptRoleList.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if gameUserClueList != nil{
            var dictionaryElements = [[String:Any]]()
            for gameUserClueListElement in gameUserClueList {
                dictionaryElements.append(gameUserClueListElement.toDictionary())
            }
            dictionary["game_user_clue_list"] = dictionaryElements
        }
        
        if room != nil{
            dictionary["room"] = room.toDictionary()
        }
        if script != nil{
            dictionary["script"] = script.toDictionary()
        }
        if scriptNodeResult != nil{
            dictionary["script_node_result"] = scriptNodeResult.toDictionary()
        }
        if scriptRoleList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptRoleListElement in scriptRoleList {
                dictionaryElements.append(scriptRoleListElement.toDictionary())
            }
            dictionary["script_role_list"] = dictionaryElements
        }
        return dictionary
    }
}

