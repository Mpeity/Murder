//
//  MineModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/13.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class MineModel : NSObject {

    var head : String?
    var headId : String?
    var level : String?
    var nickname : String?
    var userId : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        head = dictionary["head"] as? String
        headId = dictionary["head_id"] as? String
        level = dictionary["level"] as? String
        nickname = dictionary["nickname"] as? String
        userId = dictionary["user_id"] as? String
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
        if headId != nil{
            dictionary["head_id"] = headId
        }
        if level != nil{
            dictionary["level"] = level
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
}
