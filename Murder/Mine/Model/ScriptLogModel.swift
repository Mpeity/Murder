//
//  ScriptLogModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/28.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class ScriptMineListModel : NSObject {

    var cover : String!
    var gameEndTime : Int!
    var gameStartTime : String!
    var roomId : Int!
    var roomUserId : Int!
    var scriptName : String!
    var spentTime : Int!
    var spentTimeText : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cover = dictionary["cover"] as? String
        gameEndTime = dictionary["game_end_time"] as? Int
        gameStartTime = dictionary["game_start_time"] as? String
        roomId = dictionary["room_id"] as? Int
        roomUserId = dictionary["room_user_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        spentTime = dictionary["spent_time"] as? Int
        spentTimeText = dictionary["spent_time_text"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cover != nil{
            dictionary["cover"] = cover
        }
        if gameEndTime != nil{
            dictionary["game_end_time"] = gameEndTime
        }
        if gameStartTime != nil{
            dictionary["game_start_time"] = gameStartTime
        }
        if roomId != nil{
            dictionary["room_id"] = roomId
        }
        if roomUserId != nil{
            dictionary["room_user_id"] = roomUserId
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if spentTime != nil{
            dictionary["spent_time"] = spentTime
        }
        if spentTimeText != nil{
            dictionary["spent_time_text"] = spentTimeText
        }
        return dictionary
    }
}


class ScriptLogModel : NSObject {

    var list : [ScriptMineListModel]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [ScriptMineListModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = ScriptMineListModel(fromDictionary: dic)
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
