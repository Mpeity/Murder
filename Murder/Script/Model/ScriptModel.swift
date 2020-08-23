//
//  ScriptModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptModel : NSObject {

    var list : [ScriptListModel]?
    var tagList : [ScriptTagModel]?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [ScriptListModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = ScriptListModel(fromDictionary: dic)
                list?.append(value)
            }
        }
        tagList = [ScriptTagModel]()
        if let tagListArray = dictionary["tag_list"] as? [[String:Any]]{
            for dic in tagListArray{
                let value = ScriptTagModel(fromDictionary: dic)
                tagList?.append(value)
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
        if tagList != nil{
            var dictionaryElements = [[String:Any]]()
            for tagListElement in tagList! {
                dictionaryElements.append(tagListElement.toDictionary())
            }
            dictionary["tag_list"] = dictionaryElements
        }
        return dictionary
    }

}
