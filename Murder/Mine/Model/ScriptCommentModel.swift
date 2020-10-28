//
//  ScriptCommentModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/10/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptCommentModel : NSObject {

    var content : String?
    var createTime : Int?
    var id : Int?
    var leak : Int?
    var scriptId : Int?
    var star : Int?
    var status : Int?
    var updateTime : Int?
    var userId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        content = dictionary["content"] as? String
        createTime = dictionary["create_time"] as? Int
        id = dictionary["id"] as? Int
        leak = dictionary["leak"] as? Int
        scriptId = dictionary["script_id"] as? Int
        star = dictionary["star"] as? Int
        status = dictionary["status"] as? Int
        updateTime = dictionary["update_time"] as? Int
        userId = dictionary["user_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if content != nil{
            dictionary["content"] = content
        }
        if createTime != nil{
            dictionary["create_time"] = createTime
        }
        if id != nil{
            dictionary["id"] = id
        }
        if leak != nil{
            dictionary["leak"] = leak
        }
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if star != nil{
            dictionary["star"] = star
        }
        if status != nil{
            dictionary["status"] = status
        }
        if updateTime != nil{
            dictionary["update_time"] = updateTime
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
}
