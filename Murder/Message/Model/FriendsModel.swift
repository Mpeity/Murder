//
//  FriendsModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/31.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class FriendListModel : NSObject {

    var gameStatus : Int?
    var gameText : String?
    var head : String?
    var level : String?
    var nickname : String?
    var sex : Int?
    var sexText : String?
    var userId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        gameStatus = dictionary["game_status"] as? Int
        gameText = dictionary["game_text"] as? String
        head = dictionary["head"] as? String
        level = dictionary["level"] as? String
        nickname = dictionary["nickname"] as? String
        sex = dictionary["sex"] as? Int
        sexText = dictionary["sex_text"] as? String
        userId = dictionary["user_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if gameStatus != nil{
            dictionary["game_status"] = gameStatus
        }
        if gameText != nil{
            dictionary["game_text"] = gameText
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
        if sexText != nil{
            dictionary["sex_text"] = sexText
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
}

class FriendsModel : NSObject {

    var list : [FriendListModel]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [FriendListModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = FriendListModel(fromDictionary: dic)
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
