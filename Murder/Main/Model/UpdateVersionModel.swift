//
//  UpdateVersionModel.swift
//  Murder
//
//  Created by m.a.c on 2020/10/26.
//  Copyright © 2020 m.a.c. All rights reserved.

import Foundation


class UpdateVersionModel : NSObject {

    var code : String?
    var content : String?
    var createTime : Int?
    var fieldName : String?
    var forcedUpdates : Int?
    var id : Int?
    var name : String?
    var updateTime : Int?
    var url : String?
    var version : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? String
        content = dictionary["content"] as? String
        createTime = dictionary["create_time"] as? Int
        fieldName = dictionary["field_name"] as? String
        forcedUpdates = dictionary["forced_updates"] as? Int
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        updateTime = dictionary["update_time"] as? Int
        url = dictionary["url"] as? String
        version = dictionary["version"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if content != nil{
            dictionary["content"] = content
        }
        if createTime != nil{
            dictionary["create_time"] = createTime
        }
        if fieldName != nil{
            dictionary["field_name"] = fieldName
        }
        if forcedUpdates != nil{
            dictionary["forced_updates"] = forcedUpdates
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if updateTime != nil{
            dictionary["update_time"] = updateTime
        }
        if url != nil{
            dictionary["url"] = url
        }
        if version != nil{
            dictionary["version"] = version
        }
        return dictionary
    }
}
