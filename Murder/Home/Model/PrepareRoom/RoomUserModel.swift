//
//  RoomUserModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class RoomUserModel : NSObject {
    
    var head : String?
    var isHomeowner : Int?
    var level : String?
    var nickname : String?
    var scriptRoleId : Int?
    var sex : Int?
    var status : Int?
    var userId : Int?

    


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        head = dictionary["head"] as? String
        isHomeowner = dictionary["is_homeowner"] as? Int
        level = dictionary["level"] as? String
        nickname = dictionary["nickname"] as? String
        scriptRoleId = dictionary["script_role_id"] as? Int
        sex = dictionary["sex"] as? Int
        status = dictionary["status"] as? Int
        userId = dictionary["user_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if head != nil{
            dictionary["head"] = head
        }
        if isHomeowner != nil{
            dictionary["is_homeowner"] = isHomeowner
        }
        if level != nil{
            dictionary["level"] = level
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        if sex != nil{
            dictionary["sex"] = sex
        }
        if status != nil{
            dictionary["status"] = status
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
}


