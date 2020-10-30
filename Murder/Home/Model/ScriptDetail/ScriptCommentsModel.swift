//
//  ScriptCommentsModel.swift
//  Murder
//
//  Created by m.a.c on 2020/10/28.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptCommentsModel : NSObject {

    var list : [ScriptCommentsItemModel]!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [ScriptCommentsItemModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = ScriptCommentsItemModel(fromDictionary: dic)
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

class ScriptCommentsItemModel : NSObject {
    
    var cellHeight: CGFloat?

    var content : String?
    var createTime : Int?
    var createTimeText : String?
    var duration : String?
    var durationText : String?
    var head : String?
    var nickname : String?
    var star : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        content = dictionary["content"] as? String
        createTime = dictionary["create_time"] as? Int
        createTimeText = dictionary["create_time_text"] as? String
        duration = dictionary["duration"] as? String
        durationText = dictionary["duration_text"] as? String
        head = dictionary["head"] as? String
        nickname = dictionary["nickname"] as? String
        star = dictionary["star"] as? Int
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
        if createTimeText != nil{
            dictionary["create_time_text"] = createTimeText
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if durationText != nil{
            dictionary["duration_text"] = durationText
        }
        if head != nil{
            dictionary["head"] = head
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if star != nil{
            dictionary["star"] = star
        }
        return dictionary
    }

}
