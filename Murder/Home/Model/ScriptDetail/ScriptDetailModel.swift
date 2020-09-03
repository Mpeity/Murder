//
//  ScriptDetailModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptDetailModel : NSObject{
    
    var roomId: Int?

    
    var author : String?
    var cover : String?
    var difficult : Int?
    var difficultText : String?
    var duration : Int?
    var durationText : String?
    var introduction : String?
    var name : String?
    var peopleNum : Int?
    var role : [RoleModel]?
    var scriptId : Int?
    var tag : [TagModel]?
    var wordNum : Int?
    
    
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        author = dictionary["author"] as? String
        cover = dictionary["cover"] as? String
        difficult = dictionary["difficult"] as? Int
        difficultText = dictionary["difficult_text"] as? String
        duration = dictionary["duration"] as? Int
        durationText = dictionary["duration_text"] as? String
        introduction = dictionary["introduction"] as? String
        name = dictionary["name"] as? String
        peopleNum = dictionary["people_num"] as? Int
        role = [RoleModel]()
        if let roleArray = dictionary["role"] as? [[String:Any]]{
            for dic in roleArray{
                let value = RoleModel(fromDictionary: dic)
                role?.append(value)
            }
        }
        scriptId = dictionary["script_id"] as? Int
        tag = [TagModel]()
        if let tagArray = dictionary["tag"] as? [[String:Any]]{
            for dic in tagArray{
                let value = TagModel(fromDictionary: dic)
                tag?.append(value)
            }
        }
        wordNum = dictionary["word_num"] as? Int
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
        if introduction != nil{
            dictionary["introduction"] = introduction
        }
        if name != nil{
            dictionary["name"] = name
        }
        if peopleNum != nil{
            dictionary["people_num"] = peopleNum
        }
        if role != nil{
            var dictionaryElements = [[String:Any]]()
            for roleElement in role! {
                dictionaryElements.append(roleElement.toDictionary())
            }
            dictionary["role"] = dictionaryElements
        }
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if tag != nil{
            var dictionaryElements = [[String:Any]]()
            for tagElement in tag! {
                dictionaryElements.append(tagElement.toDictionary())
            }
            dictionary["tag"] = dictionaryElements
        }
        if wordNum != nil{
            dictionary["word_num"] = wordNum
        }
        return dictionary
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
