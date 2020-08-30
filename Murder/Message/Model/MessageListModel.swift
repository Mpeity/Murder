//
//  MessageListModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/28.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class MessageListModel : NSObject {
    var content : String?
    var createTime : String?
    var head : String?
    var level : String?
    var nickname : String?
    var noReadNum : Int?
    var type : Int?
    var userId : Int?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        content = dictionary["content"] as? String
        createTime = dictionary["create_time"] as? String
        head = dictionary["head"] as? String
        level = dictionary["level"] as? String
        nickname = dictionary["nickname"] as? String
        noReadNum = dictionary["no_read_num"] as? Int
        type = dictionary["type"] as? Int
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
        if head != nil{
            dictionary["head"] = head
        }
        if level != nil{
            dictionary["level"] = level
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if noReadNum != nil{
            dictionary["no_read_num"] = noReadNum
        }
        if type != nil{
            dictionary["type"] = type
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}



class MessageModel : NSObject {

    var list : [MessageListModel]?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [MessageListModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = MessageListModel(fromDictionary: dic)
                list!.append(value)
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
            for listElement in list! {
                dictionaryElements.append(listElement.toDictionary())
            }
            dictionary["list"] = dictionaryElements
        }
        return dictionary
    }

}


