//
//  RoleModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class RoleModel : NSObject{

    var describe : String!
    var head : String!
    var headId : Int!
    var name : String!
    var scriptRoleId : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        describe = dictionary["describe"] as? String
        head = dictionary["head"] as? String
        headId = dictionary["head_id"] as? Int
        name = dictionary["name"] as? String
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
        if head != nil{
            dictionary["head"] = head
        }
        if headId != nil{
            dictionary["head_id"] = headId
        }
        if name != nil{
            dictionary["name"] = name
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        return dictionary
    }
}
