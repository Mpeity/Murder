//
//  GPSettlementModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/21.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class SettlementModel : NSObject {

    var expScore : Int?
    var roleHead : String?
    var roleHeadId : Int?
    var roleName : String?
    var score : Int?
    var scriptRoleId : Int?
    var userHead : String?
    var userHeadId : String?
    var userId : Int?
    var userNickname : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        expScore = dictionary["exp_score"] as? Int
        roleHead = dictionary["role_head"] as? String
        roleHeadId = dictionary["role_head_id"] as? Int
        roleName = dictionary["role_name"] as? String
        score = dictionary["score"] as? Int
        scriptRoleId = dictionary["script_role_id"] as? Int
        userHead = dictionary["user_head"] as? String
        userHeadId = dictionary["user_head_id"] as? String
        userId = dictionary["user_id"] as? Int
        userNickname = dictionary["user_nickname"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if expScore != nil{
            dictionary["exp_score"] = expScore
        }
        if roleHead != nil{
            dictionary["role_head"] = roleHead
        }
        if roleHeadId != nil{
            dictionary["role_head_id"] = roleHeadId
        }
        if roleName != nil{
            dictionary["role_name"] = roleName
        }
        if score != nil{
            dictionary["score"] = score
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        if userHead != nil{
            dictionary["user_head"] = userHead
        }
        if userHeadId != nil{
            dictionary["user_head_id"] = userHeadId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userNickname != nil{
            dictionary["user_nickname"] = userNickname
        }
        return dictionary
    }

}



class GPSettlementModel : NSObject {

    var list : [SettlementModel]?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [SettlementModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = SettlementModel(fromDictionary: dic)
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

