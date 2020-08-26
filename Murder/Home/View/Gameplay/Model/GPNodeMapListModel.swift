//
//  GPNodeMapListModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class GPNodeMapListModel : NSObject {

    var attachmentId : String!
    var name : String!
    var scriptMapPlaceList : [GPMapPlaceListModel]!
    var scriptNodeId : String!
    var scriptNodeMapId : Int!
    var see : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attachmentId = dictionary["attachment_id"] as? String
        name = dictionary["name"] as? String
        scriptMapPlaceList = [GPMapPlaceListModel]()
        if let scriptMapPlaceListArray = dictionary["script_map_place_list"] as? [[String:Any]]{
            for dic in scriptMapPlaceListArray{
                let value = GPMapPlaceListModel(fromDictionary: dic)
                scriptMapPlaceList.append(value)
            }
        }
        scriptNodeId = dictionary["script_node_id"] as? String
        scriptNodeMapId = dictionary["script_node_map_id"] as? Int
        see = dictionary["see"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if attachmentId != nil{
            dictionary["attachment_id"] = attachmentId
        }
        if name != nil{
            dictionary["name"] = name
        }
        if scriptMapPlaceList != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptMapPlaceListElement in scriptMapPlaceList {
                dictionaryElements.append(scriptMapPlaceListElement.toDictionary())
            }
            dictionary["script_map_place_list"] = dictionaryElements
        }
        if scriptNodeId != nil{
            dictionary["script_node_id"] = scriptNodeId
        }
        if scriptNodeMapId != nil{
            dictionary["script_node_map_id"] = scriptNodeMapId
        }
        if see != nil{
            dictionary["see"] = see
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         attachmentId = aDecoder.decodeObject(forKey: "attachment_id") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         scriptMapPlaceList = aDecoder.decodeObject(forKey :"script_map_place_list") as? [GPMapPlaceListModel]
         scriptNodeId = aDecoder.decodeObject(forKey: "script_node_id") as? String
         scriptNodeMapId = aDecoder.decodeObject(forKey: "script_node_map_id") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if attachmentId != nil{
            aCoder.encode(attachmentId, forKey: "attachment_id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if scriptMapPlaceList != nil{
            aCoder.encode(scriptMapPlaceList, forKey: "script_map_place_list")
        }
        if scriptNodeId != nil{
            aCoder.encode(scriptNodeId, forKey: "script_node_id")
        }
        if scriptNodeMapId != nil{
            aCoder.encode(scriptNodeMapId, forKey: "script_node_map_id")
        }

    }

}
