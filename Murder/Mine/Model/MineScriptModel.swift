//
//  MineScriptModel.swift
//  Murder
//
//  Created by m.a.c on 2020/10/28.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class MineScriptItemModel : NSObject {

    var cover : String?
    var scriptId : Int?
    var scriptName : String?
    var status : Int?
    var userScriptText : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cover = dictionary["cover"] as? String
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        status = dictionary["status"] as? Int
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
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if status != nil{
            dictionary["status"] = status
        }
        if userScriptText != nil{
            dictionary["user_script_text"] = userScriptText
        }
        return dictionary
    }
}

class MineScriptModel : NSObject {

    var list : [MineScriptItemModel]?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [MineScriptItemModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = MineScriptItemModel(fromDictionary: dic)
                list?.append(value)
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
        return dictionary
    }
}


