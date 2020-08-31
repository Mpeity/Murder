//
//  GPScriptRoleListModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation



class GPScriptRoleListModel : NSObject {

    var applyDismiss : Int?
    var describe : String?
    var endStory : String?
    var head : String?
    var headId : Int?
    var isMine : Int?
    var mute : Int?
    var readyOk : Int?
    var scriptRoleId : Int?
    var scriptRoleName : String?
    var secretTalkId : String?
    var user : GPScriptRoleUserModel?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        applyDismiss = dictionary["apply_dismiss"] as? Int
        describe = dictionary["describe"] as? String
        endStory = dictionary["end_story"] as? String
        head = dictionary["head"] as? String
        headId = dictionary["head_id"] as? Int
        isMine = dictionary["is_mine"] as? Int
        mute = dictionary["mute"] as? Int
        readyOk = dictionary["ready_ok"] as? Int
        scriptRoleId = dictionary["script_role_id"] as? Int
        scriptRoleName = dictionary["script_role_name"] as? String
        secretTalkId = dictionary["secret_talk_id"] as? String

        if let userData = dictionary["user"] as? [String:Any]{
            user = GPScriptRoleUserModel(fromDictionary: userData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if applyDismiss != nil{
            dictionary["apply_dismiss"] = applyDismiss
        }
        if describe != nil{
            dictionary["describe"] = describe
        }
        if endStory != nil{
            dictionary["end_story"] = endStory
        }
        if head != nil{
            dictionary["head"] = head
        }
        if headId != nil{
            dictionary["head_id"] = headId
        }
        if isMine != nil{
            dictionary["is_mine"] = isMine
        }
        if mute != nil{
            dictionary["mute"] = mute
        }
        if readyOk != nil{
            dictionary["ready_ok"] = readyOk
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        if scriptRoleName != nil{
            dictionary["script_role_name"] = scriptRoleName
        }
        if secretTalkId != nil{
            dictionary["secret_talk_id"] = secretTalkId
        }
        if user != nil{
            dictionary["user"] = user!.toDictionary()
        }
        return dictionary
    }
}
