//
//  CheckUserModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/1.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class Result : NSObject {

    var roomId : Int!
    var roomScriptNodeId : Int!
    var scriptRoleId : Int!
    var status : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        roomId = dictionary["room_id"] as? Int
        roomScriptNodeId = dictionary["room_script_node_id"] as? Int
        scriptRoleId = dictionary["script_role_id"] as? Int
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
        if roomScriptNodeId != nil{
            dictionary["room_script_node_id"] = roomScriptNodeId
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }
}


class CheckUserModel : NSObject {

    var result : Result!
    var stage : Int!

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
                result = Result(fromDictionary: resultData)
            }
            break
        case 2:
            if let resultData = dictionary["result"] as? [String:Any]{
                result = Result(fromDictionary: resultData)
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
        if result != nil{
            dictionary["result"] = result.toDictionary()
        }
        if stage != nil{
            dictionary["stage"] = stage
        }
        return dictionary
    }
}
