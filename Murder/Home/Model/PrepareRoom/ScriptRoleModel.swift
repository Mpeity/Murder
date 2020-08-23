//
//  ScriptRoleModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptRoleModel : NSObject {

    var describe : String?
    var endStory : String?
    var head : String?
    var headId : Int?
    var roleName : String?
    var scriptRoleId : Int?
    
    // 该角色是否已经有玩家选择
    var hasPlayer : Bool! = false


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        describe = dictionary["describe"] as? String
        endStory = dictionary["end_story"] as? String
        head = dictionary["head"] as? String
        headId = dictionary["head_id"] as? Int
        roleName = dictionary["role_name"] as? String
        scriptRoleId = dictionary["script_role_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if describe != nil{
            dictionary["describe"] = describe
        }
        if endStory != nil{
            dictionary["end_story"] = endStory
        }
        if head != nil{
            dictionary["head"] = head
        }
        if headId != nil{
            dictionary["head_id"] = headId
        }
        if roleName != nil{
            dictionary["role_name"] = roleName
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        return dictionary
    }
    
}
