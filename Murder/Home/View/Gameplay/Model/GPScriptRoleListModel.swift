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
    var chapter : [GPChapterModel]?
    var describe : String?
    var endStory : String?
    var gameUserClueList : [GameUserClueListModel]?
    var head : String?
    var headId : Int?
    var isMine : Int?
    var mute : Int?
    var readyOk : Int?
    
    var scriptMapPlaceList : [GPMapPlaceListModel]?
    var scriptNodeMapList : [GPNodeMapListModel]?
    var scriptQuestionList : [ScriptQuestionListModel]?
    
    var scriptRoleId : Int?
    var scriptRoleName : String?
    var secretTalkId : Int?
    var user : GPScriptRoleUserModel!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]){
        applyDismiss = dictionary["apply_dismiss"] as? Int
        chapter = [GPChapterModel]()
        if let chapterArray = dictionary["chapter"] as? [[String:Any]]{
            for dic in chapterArray{
                let value = GPChapterModel(fromDictionary: dic)
                chapter!.append(value)
            }
        }
        describe = dictionary["describe"] as? String
        endStory = dictionary["end_story"] as? String

        gameUserClueList = [GameUserClueListModel]()
        if let gameUserClueListArray = dictionary["game_user_clue_list"] as? [[String:Any]]{
            for dic in gameUserClueListArray{
                let value = GameUserClueListModel(fromDictionary: dic)
                gameUserClueList!.append(value)
            }
        }
        
        scriptNodeMapList = [GPNodeMapListModel]()
        if let scriptNodeMapListArray = dictionary["script_node_map_list"] as? [[String:Any]]{
            for dic in scriptNodeMapListArray{
                let value = GPNodeMapListModel(fromDictionary: dic)
                scriptNodeMapList!.append(value)
            }
        }
        
        head = dictionary["head"] as? String
        headId = dictionary["head_id"] as? Int
        isMine = dictionary["is_mine"] as? Int
        mute = dictionary["mute"] as? Int
        readyOk = dictionary["ready_ok"] as? Int
        
        
        scriptMapPlaceList = [GPMapPlaceListModel]()
        if let scriptNodeMapListArray = dictionary["script_map_place_list"] as? [[String:Any]]{
            for dic in scriptNodeMapListArray{
                let value = GPMapPlaceListModel(fromDictionary: dic)
                scriptMapPlaceList!.append(value)
            }
        }
        
        scriptNodeMapList = [GPNodeMapListModel]()
        if let scriptNodeMapListArray = dictionary["script_node_map_list"] as? [[String:Any]]{
            for dic in scriptNodeMapListArray{
                let value = GPNodeMapListModel(fromDictionary: dic)
                scriptNodeMapList!.append(value)
            }
        }
        scriptQuestionList = [ScriptQuestionListModel]()
        if let scriptQuestionListArray = dictionary["script_question_list"] as? [[String:Any]]{
            for dic in scriptQuestionListArray{
                let value = ScriptQuestionListModel(fromDictionary: dic)
                scriptQuestionList!.append(value)
            }
        }
        scriptRoleId = dictionary["script_role_id"] as? Int
        scriptRoleName = dictionary["script_role_name"] as? String
        secretTalkId = dictionary["secret_talk_id"] as? Int
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
        if chapter != nil{
            var dictionaryElements = [[String:Any]]()
            for chapterElement in chapter! {
                dictionaryElements.append(chapterElement.toDictionary())
            }
            dictionary["chapter"] = dictionaryElements
        }
        if describe != nil{
            dictionary["describe"] = describe
        }
        if endStory != nil{
            dictionary["end_story"] = endStory
        }
        if gameUserClueList != nil{
            dictionary["game_user_clue_list"] = gameUserClueList
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
        if scriptMapPlaceList != nil{
            dictionary["script_map_place_list"] = scriptMapPlaceList
        }
        if scriptNodeMapList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptNodeMapListElement in scriptNodeMapList! {
                dictionaryElements.append(scriptNodeMapListElement.toDictionary())
            }
            dictionary["script_node_map_list"] = dictionaryElements
        }
        if scriptQuestionList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptQuestionListElement in scriptQuestionList! {
                dictionaryElements.append(scriptQuestionListElement.toDictionary())
            }
            dictionary["script_question_list"] = dictionaryElements
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
            dictionary["user"] = user.toDictionary()
        }
        return dictionary
    }

}
