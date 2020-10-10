//
//  FriendsApplyModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/31.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class FriendsApplyListModel : NSObject {

    var createTime : String?
    var friendApplyId : Int?
    var head : String?
    var level : String?
    var nickname : String?
    var sex : Int?
    var status : Int?
    var userId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createTime = dictionary["create_time"] as? String
        friendApplyId = dictionary["friend_apply_id"] as? Int
        head = dictionary["head"] as? String
        level = dictionary["level"] as? String
        nickname = dictionary["nickname"] as? String
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
        if createTime != nil{
            dictionary["create_time"] = createTime
        }
        if friendApplyId != nil{
            dictionary["friend_apply_id"] = friendApplyId
        }
        if head != nil{
            dictionary["head"] = head
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
        if status != nil{
            dictionary["status"] = status
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
}


class FriendsApplyModel : NSObject {

    var list : [FriendsApplyListModel]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [FriendsApplyListModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = FriendsApplyListModel(fromDictionary: dic)
                list.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if list != nil{
            var dictionaryElements = [[String:Any]]()
            for listElement in list {
                dictionaryElements.append(listElement.toDictionary())
            }
            dictionary["list"] = dictionaryElements
        }
        return dictionary
    }
}
