//
//  ScriptSourceModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/18.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class Script : NSObject {

    var scriptId : Int?
    var scriptName : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
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
        return dictionary
    }
}

class ScriptSourceModel : NSObject {

//    var script : Script?
//    var scriptNodeMapList : [ScriptNodeMapModel]?
    
    var script : Script!
    var scriptClueList : [ScriptNodeMapModel]?
    var scriptNodeMapList : [ScriptNodeMapModel]?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
       if let scriptData = dictionary["script"] as? [String:Any]{
           script = Script(fromDictionary: scriptData)
       }
       scriptClueList = [ScriptNodeMapModel]()
       if let scriptClueListArray = dictionary["script_clue_list"] as? [[String:Any]]{
           for dic in scriptClueListArray{
               let value = ScriptNodeMapModel(fromDictionary: dic)
            scriptClueList?.append(value)
           }
       }
       scriptNodeMapList = [ScriptNodeMapModel]()
       if let scriptNodeMapListArray = dictionary["script_node_map_list"] as? [[String:Any]]{
           for dic in scriptNodeMapListArray{
               let value = ScriptNodeMapModel(fromDictionary: dic)
            scriptNodeMapList?.append(value)
           }
       }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if script != nil{
            dictionary["script"] = script.toDictionary()
        }
        if scriptClueList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptClueListElement in scriptClueList! {
                dictionaryElements.append(scriptClueListElement.toDictionary())
            }
            dictionary["script_clue_list"] = dictionaryElements
        }
        if scriptNodeMapList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptNodeMapListElement in scriptNodeMapList! {
                dictionaryElements.append(scriptNodeMapListElement.toDictionary())
            }
            dictionary["script_node_map_list"] = dictionaryElements
        }
        return dictionary
    }
}
