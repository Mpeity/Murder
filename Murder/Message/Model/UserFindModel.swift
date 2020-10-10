//
//  UserFindModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/31.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class UserFindModel : NSObject {

    var head : String?
    var isApply : Int?
    var isFriend : Int?
    var level : String?
    var nickname : String?
    var sex : Int?
    var userId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        head = dictionary["head"] as? String
        isApply = dictionary["is_apply"] as? Int
        isFriend = dictionary["is_friend"] as? Int
        level = dictionary["level"] as? String
        nickname = dictionary["nickname"] as? String
        sex = dictionary["sex"] as? Int
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
        if isApply != nil{
            dictionary["is_apply"] = isApply
        }
        if isFriend != nil{
            dictionary["is_friend"] = isFriend
        }
        if level != nil{
            dictionary["level"] = level
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if sex != nil{
            dictionary["sex"] = sex
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }

}
