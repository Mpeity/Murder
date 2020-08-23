//
//  ReadyRoomModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class ReadyRoomModel : NSObject {

    var firstScriptNodeId : Int?
    var readyOk : Int?
    var introduction : String?
    var isLock : Int?
    var roomId : Int?
    var roomUserList : [RoomUserModel]?
    var scriptName : String?
    var scriptRoleList : [ScriptRoleModel]?
    var tagText : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        firstScriptNodeId = dictionary["first_script_node_id"] as? Int
        introduction = dictionary["introduction"] as? String
        isLock = dictionary["is_lock"] as? Int
        readyOk = dictionary["ready_ok"] as? Int
        roomId = dictionary["room_id"] as? Int
        roomUserList = [RoomUserModel]()
        if let roomUserListArray = dictionary["room_user_list"] as? [[String:Any]]{
            for dic in roomUserListArray{
                let value = RoomUserModel(fromDictionary: dic)
                roomUserList!.append(value)
            }
        }
        scriptName = dictionary["script_name"] as? String
        scriptRoleList = [ScriptRoleModel]()
        if let scriptRoleListArray = dictionary["script_role_list"] as? [[String:Any]]{
            for dic in scriptRoleListArray{
                let value = ScriptRoleModel(fromDictionary: dic)
                scriptRoleList!.append(value)
            }
        }
        tagText = dictionary["tag_text"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if firstScriptNodeId != nil{
            dictionary["first_script_node_id"] = firstScriptNodeId
        }
        if introduction != nil{
            dictionary["introduction"] = introduction
        }
        if isLock != nil{
            dictionary["is_lock"] = isLock
        }
        if readyOk != nil{
            dictionary["ready_ok"] = readyOk
        }
        if roomId != nil{
            dictionary["room_id"] = roomId
        }
        if roomUserList != nil{
            var dictionaryElements = [[String:Any]]()
            for roomUserListElement in roomUserList! {
                dictionaryElements.append(roomUserListElement.toDictionary())
            }
            dictionary["room_user_list"] = dictionaryElements
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if scriptRoleList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptRoleListElement in scriptRoleList! {
                dictionaryElements.append(scriptRoleListElement.toDictionary())
            }
            dictionary["script_role_list"] = dictionaryElements
        }
        if tagText != nil{
            dictionary["tag_text"] = tagText
        }
        return dictionary
    }

}

