//
//  GPScriptNodeResultModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class GPScriptNodeResultModel : NSObject {
    
    
    var buttonName : String?
    var describe : String?
    var minExperience : Int?
    var myRoleId : Int?
    var nodeName : String?
    var nodeType : Int?
    var orderNum : Int?
    var readyOk : Int?
    var scriptNodeId : Int?

//    var buttonName : String?
//    var chapter : [GPChapterModel]?
//    var describe : String?
//    var minExperience : Int?
//    var nodeName : String?
//    var nodeType : Int?
//    var orderNum : Int?
//    var scriptNodeId : Int?
//    var scriptNodeMapList : [GPNodeMapListModel]?
//    var scriptPlaceList : [GPPlaceListModel]?
//    var scriptQuestionList : [ScriptQuestionListModel]!
//    var myRoleId : Int!



    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        buttonName = dictionary["button_name"] as? String
//        chapter = [GPChapterModel]()
//        if let chapterArray = dictionary["chapter"] as? [[String:Any]]{
//            for dic in chapterArray{
//                let value = GPChapterModel(fromDictionary: dic)
//                chapter?.append(value)
//            }
//        }
        describe = dictionary["describe"] as? String
        minExperience = dictionary["min_experience"] as? Int
        nodeName = dictionary["node_name"] as? String
        nodeType = dictionary["node_type"] as? Int
        orderNum = dictionary["order_num"] as? Int
        scriptNodeId = dictionary["script_node_id"] as? Int
        myRoleId = dictionary["my_role_id"] as? Int

//        scriptNodeMapList = [GPNodeMapListModel]()
//        if let scriptNodeMapListArray = dictionary["script_node_map_list"] as? [[String:Any]]{
//            for dic in scriptNodeMapListArray{
//                let value = GPNodeMapListModel(fromDictionary: dic)
//                scriptNodeMapList?.append(value)
//            }
//        }
//        if let scriptPlaceListArray = dictionary["script_place_list"] as? [[String:Any]]{
//            for dic in scriptPlaceListArray{
//                let value = GPPlaceListModel(fromDictionary: dic)
//                scriptPlaceList?.append(value)
//            }
//        }
//        scriptQuestionList = [ScriptQuestionListModel]()
//        if let scriptQuestionListArray = dictionary["script_question_list"] as? [[String:Any]]{
//            for dic in scriptQuestionListArray{
//                let value = ScriptQuestionListModel(fromDictionary: dic)
//                scriptQuestionList.append(value)
//            }
//        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if buttonName != nil{
            dictionary["button_name"] = buttonName
        }
//        if chapter != nil{
//            var dictionaryElements = [[String:Any]]()
//            for chapterElement in chapter! {
//                dictionaryElements.append(chapterElement.toDictionary())
//            }
//            dictionary["chapter"] = dictionaryElements
//        }
        if describe != nil{
            dictionary["describe"] = describe
        }
        if minExperience != nil{
            dictionary["min_experience"] = minExperience
        }
        if nodeName != nil{
            dictionary["node_name"] = nodeName
        }
        if myRoleId != nil{
            dictionary["my_role_id"] = myRoleId
        }
        if nodeType != nil{
            dictionary["node_type"] = nodeType
        }
        if orderNum != nil{
            dictionary["order_num"] = orderNum
        }
        if scriptNodeId != nil{
            dictionary["script_node_id"] = scriptNodeId
        }
//        if scriptNodeMapList != nil{
//            var dictionaryElements = [[String:Any]]()
//            for scriptNodeMapListElement in scriptNodeMapList! {
//                dictionaryElements.append(scriptNodeMapListElement.toDictionary())
//            }
//            dictionary["script_node_map_list"] = dictionaryElements
//        }
//        if scriptPlaceList != nil{
//            var dictionaryElements = [[String:Any]]()
//            for scriptPlaceListElement in scriptPlaceList! {
//                dictionaryElements.append(scriptPlaceListElement.toDictionary())
//            }
//            dictionary["script_place_list"] = dictionaryElements
//        }
//        if scriptQuestionList != nil{
//            var dictionaryElements = [[String:Any]]()
//            for scriptQuestionListElement in scriptQuestionList {
//                dictionaryElements.append(scriptQuestionListElement.toDictionary())
//            }
//            dictionary["script_question_list"] = dictionaryElements
//        }
        return dictionary
    }
}
