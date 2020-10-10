//
//  TagModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class TagModel : NSObject{

    var tagId : Int!
    var tagName : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        tagId = dictionary["tag_id"] as? Int
        tagName = dictionary["tag_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if tagId != nil{
            dictionary["tag_id"] = tagId
        }
        if tagName != nil{
            dictionary["tag_name"] = tagName
        }
        return dictionary
    }
}
