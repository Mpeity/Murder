//
//  GamePlayScriptModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class GamePlayScriptModel : NSObject {

    var scriptId : Int?
    var scriptName : String?
    var secretTalkRoomNum : Int? 


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        secretTalkRoomNum = dictionary["secret_talk_room_num"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if secretTalkRoomNum != nil{
            dictionary["secret_talk_room_num"] = secretTalkRoomNum
        }
        return dictionary
    }

}
