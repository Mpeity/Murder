//
//  HomeRoomModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation
import UIKit


class HomeRoomModel : NSObject {

    var commentScore : Double!
    var cover : String!
    var duration : String!
    var durationText : String!
    var isPassword : Int!
    var nickname : String!
    var roomId : Int!
    var scriptId : Int!
    var scriptName : String!
    var scriptRoleNum : Int!
    var star : Int!
    var userNum : Int!
    var userScriptStatus : Int!
    var userScriptText : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        commentScore = dictionary["comment_score"] as? Double
        cover = dictionary["cover"] as? String
        duration = dictionary["duration"] as? String
        durationText = dictionary["duration_text"] as? String
        isPassword = dictionary["is_password"] as? Int
        nickname = dictionary["nickname"] as? String
        roomId = dictionary["room_id"] as? Int
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        scriptRoleNum = dictionary["script_role_num"] as? Int
        star = dictionary["star"] as? Int
        userNum = dictionary["user_num"] as? Int
        userScriptStatus = dictionary["user_script_status"] as? Int
        userScriptText = dictionary["user_script_text"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if commentScore != nil{
            dictionary["comment_score"] = commentScore
        }
        if cover != nil{
            dictionary["cover"] = cover
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if durationText != nil{
            dictionary["duration_text"] = durationText
        }
        if isPassword != nil{
            dictionary["is_password"] = isPassword
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if roomId != nil{
            dictionary["room_id"] = roomId
        }
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if scriptRoleNum != nil{
            dictionary["script_role_num"] = scriptRoleNum
        }
        if star != nil{
            dictionary["star"] = star
        }
        if userNum != nil{
            dictionary["user_num"] = userNum
        }
        if userScriptStatus != nil{
            dictionary["user_script_status"] = userScriptStatus
        }
        if userScriptText != nil{
            dictionary["user_script_text"] = userScriptText
        }
        return dictionary
    }
}

