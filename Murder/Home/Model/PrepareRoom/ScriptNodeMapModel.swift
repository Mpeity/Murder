//
//  ScriptNodeMapModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/18.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptNodeMapModel : NSObject {

    var attachment : String!
    var attachmentId : String!
    var scriptNodeMapId : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attachment = dictionary["attachment"] as? String
        attachmentId = dictionary["attachment_id"] as? String
        scriptNodeMapId = dictionary["script_node_map_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if attachment != nil{
            dictionary["attachment"] = attachment
        }
        if attachmentId != nil{
            dictionary["attachment_id"] = attachmentId
        }
        if scriptNodeMapId != nil{
            dictionary["script_node_map_id"] = scriptNodeMapId
        }
        return dictionary
    }

}
