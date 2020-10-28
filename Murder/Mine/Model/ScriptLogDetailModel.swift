//
//  ScriptLogDetailModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/28.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class ScriptRoleResult : NSObject {
    var headId : String?
    var name : String?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        headId = dictionary["head_id"] as? String
        name = dictionary["name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if headId != nil{
            dictionary["head_id"] = headId
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
}


class ScriptLogDetail : NSObject {

    var author : String?
    var commentPeopleText : String?
    var commentScore : Double?
    var cover : String?
    var roomId : String?
    var scriptId : Int?
    var scriptName : String?
    var scriptStar : Int?
    var truthContent : String?
    var truthName : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        author = dictionary["author"] as? String
        commentPeopleText = dictionary["comment_people_text"] as? String
        commentScore = dictionary["comment_score"] as? Double
        cover = dictionary["cover"] as? String
        roomId = dictionary["room_id"] as? String
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        scriptStar = dictionary["script_star"] as? Int
        truthContent = dictionary["truth_content"] as? String
        truthName = dictionary["truth_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if author != nil{
            dictionary["author"] = author
        }
        if commentPeopleText != nil{
            dictionary["comment_people_text"] = commentPeopleText
        }
        if commentScore != nil{
            dictionary["comment_score"] = commentScore
        }
        if cover != nil{
            dictionary["cover"] = cover
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
        if scriptStar != nil{
            dictionary["script_star"] = scriptStar
        }
        if truthContent != nil{
            dictionary["truth_content"] = truthContent
        }
        if truthName != nil{
            dictionary["truth_name"] = truthName
        }
        return dictionary
    }

}

class ScriptLogDetailUserModel : NSObject {

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
    var isFriend : Int?



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
        isFriend = dictionary["is_friend"] as? Int

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
        if isFriend != nil{
            dictionary["is_friend"] = isFriend
        }
        return dictionary
    }

}


class ScriptLogChapterModel : NSObject {

    var content : String?
    var h5Url : String?
    var name : String?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        content = dictionary["content"] as? String
        h5Url = dictionary["h5_url"] as? String
        name = dictionary["name"] as? String
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
        if h5Url != nil{
            dictionary["h5_url"] = h5Url
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
}


class ScriptLogDetailModel : NSObject {
    var chapterList : [ScriptLogChapterModel]?
    var roomUserList : [ScriptLogDetailUserModel]?
    var script : ScriptLogDetail?
    var roleResult : ScriptRoleResult?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        chapterList = [ScriptLogChapterModel]()
        
        if let roleResultData = dictionary["role_result"] as? [String:Any]{
            roleResult = ScriptRoleResult(fromDictionary: roleResultData)
        }
        
        if let chapterListArray = dictionary["chapter_list"] as? [[String:Any]]{
            for dic in chapterListArray{
                let value = ScriptLogChapterModel(fromDictionary: dic)
                chapterList?.append(value)
            }
        }
        roomUserList = [ScriptLogDetailUserModel]()
        if let roomUserListArray = dictionary["room_user_list"] as? [[String:Any]]{
            for dic in roomUserListArray{
                let value = ScriptLogDetailUserModel(fromDictionary: dic)
                roomUserList?.append(value)
            }
        }
        if let scriptData = dictionary["script"] as? [String:Any]{
            script = ScriptLogDetail(fromDictionary: scriptData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if chapterList != nil{
            var dictionaryElements = [[String:Any]]()
            for chapterListElement in chapterList! {
                dictionaryElements.append(chapterListElement.toDictionary())
            }
            dictionary["chapter_list"] = dictionaryElements
        }
        if roomUserList != nil{
            var dictionaryElements = [[String:Any]]()
            for roomUserListElement in roomUserList! {
                dictionaryElements.append(roomUserListElement.toDictionary())
            }
            dictionary["room_user_list"] = dictionaryElements
        }
        if roleResult != nil{
            dictionary["role_result"] = roleResult!.toDictionary()
        }
        if script != nil{
            dictionary["script"] = script?.toDictionary()
        }
        return dictionary
    }
}
