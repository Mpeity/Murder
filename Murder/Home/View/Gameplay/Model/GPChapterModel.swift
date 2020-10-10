//
//  GPChapterModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class GPChapterModel : NSObject {

    var content : String?
    var name : String?
    var scriptRoleChapterId : Int?
    var see : Int?
    var h5Url : String?



    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        content = dictionary["content"] as? String
        name = dictionary["name"] as? String
        scriptRoleChapterId = dictionary["script_role_chapter_id"] as? Int
        see = dictionary["see"] as? Int
        h5Url = dictionary["h5_url"] as? String

    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if content != nil{
            dictionary["content"] = content
        }
        if name != nil{
            dictionary["name"] = name
        }
        if scriptRoleChapterId != nil{
            dictionary["script_role_chapter_id"] = scriptRoleChapterId
        }
        if see != nil{
            dictionary["see"] = see
        }
        if h5Url != nil{
            dictionary["h5_url"] = h5Url
        }
        return dictionary
    }
}
