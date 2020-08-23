//
//  ScriptTagModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class ScriptTagModel : NSObject {

    var name : String!
    var tagId : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        name = dictionary["name"] as? String
        tagId = dictionary["tag_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if tagId != nil{
            dictionary["tag_id"] = tagId
        }
        return dictionary
    }
}
