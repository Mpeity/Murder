//
//  ReadyRoomModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class ReadyRoomModel : NSObject {

    var firstScriptNodeId : Int?
    var introduction : String?
    var isLock : Int?
    var readyOk : Int?
    var roomId : Int?
    var roomUserList : [RoomUserModel]?
    var scriptId : Int?
    var scriptName : String?
    var scriptRoleList : [ScriptRoleModel]?
    var status : Int?
    var tagText : String?
    var scriptCover : String?


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
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        scriptRoleList = [ScriptRoleModel]()
        if let scriptRoleListArray = dictionary["script_role_list"] as? [[String:Any]]{
            for dic in scriptRoleListArray{
                let value = ScriptRoleModel(fromDictionary: dic)
                scriptRoleList!.append(value)
            }
        }
        status = dictionary["status"] as? Int
        tagText = dictionary["tag_text"] as? String
        
        scriptCover = dictionary["script_cover"] as? String

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
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if scriptCover != nil{
            dictionary["script_cover"] = scriptCover
        }
        if scriptRoleList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptRoleListElement in scriptRoleList! {
                dictionaryElements.append(scriptRoleListElement.toDictionary())
            }
            dictionary["script_role_list"] = dictionaryElements
        }
        if status != nil{
            dictionary["status"] = status
        }
        if tagText != nil{
            dictionary["tag_text"] = tagText
        }
        return dictionary
    }
}


