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

    @objc var cover : String!
    var duration : Int!
    @objc var durationText : String!
    @objc var nickname : String?
    var roomId : Int!
    @objc var roomPassword : String!
    var scriptId : Int!
    @objc var scriptName : String!
    var scriptRoleNum : Int!
    var userNum : Int!
    var userScriptStatus : Int!
    var userScriptText : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cover = dictionary["cover"] as? String
        duration = dictionary["duration"] as? Int
        durationText = dictionary["duration_text"] as? String
        nickname = dictionary["nickname"] as? String
        roomId = dictionary["room_id"] as? Int
        roomPassword = dictionary["room_password"] as? String
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        scriptRoleNum = dictionary["script_role_num"] as? Int
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
        if cover != nil{
            dictionary["cover"] = cover
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if durationText != nil{
            dictionary["duration_text"] = durationText
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if roomId != nil{
            dictionary["room_id"] = roomId
        }
        if roomPassword != nil{
            dictionary["room_password"] = roomPassword
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
    
//    // 自定义构造函数
//    init(dic : [String : AnyObject]) {
//        super.init()
//        setValuesForKeys(dic)
//    }
//
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//
//    }

}
