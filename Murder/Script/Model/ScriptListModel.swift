//
//  ScriptListModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptListModel : NSObject {

    var cover : String?
    var difficult : Int?
    var difficultText : String?
    var duration : Int?
    var durationText : String?
    var peopleNum : Int?
    var scriptId : Int?
    var scriptName : String?
    var tag : [ScriptTagNameModel]!
    var userScriptText : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cover = dictionary["cover"] as? String
        difficult = dictionary["difficult"] as? Int
        difficultText = dictionary["difficult_text"] as? String
        duration = dictionary["duration"] as? Int
        durationText = dictionary["duration_text"] as? String
        peopleNum = dictionary["people_num"] as? Int
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        tag = [ScriptTagNameModel]()
        if let tagArray = dictionary["tag"] as? [[String:Any]]{
            for dic in tagArray{
                let value = ScriptTagNameModel(fromDictionary: dic)
                tag.append(value)
            }
        }
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
        if difficult != nil{
            dictionary["difficult"] = difficult
        }
        if difficultText != nil{
            dictionary["difficult_text"] = difficultText
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if durationText != nil{
            dictionary["duration_text"] = durationText
        }
        if peopleNum != nil{
            dictionary["people_num"] = peopleNum
        }
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if tag != nil{
            var dictionaryElements = [[String:Any]]()
            for tagElement in tag {
                dictionaryElements.append(tagElement.toDictionary())
            }
            dictionary["tag"] = dictionaryElements
        }
        if userScriptText != nil{
            dictionary["user_script_text"] = userScriptText
        }
        return dictionary
    }    
}
