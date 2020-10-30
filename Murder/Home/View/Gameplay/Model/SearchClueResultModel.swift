//
//  SearchClueResultModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class SearchClueResultModel : NSObject {

    var attachment : String?
    var attachmentId : String?
    var childId : Int?
    var isGoing : Int?
    var isOpen : Int?
    var name : String?
    var scriptClueId : Int?
    var scriptPlaceId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attachment = dictionary["attachment"] as? String
        attachmentId = dictionary["attachment_id"] as? String
        childId = dictionary["child_id"] as? Int
        isGoing = dictionary["is_going"] as? Int
        isOpen = dictionary["is_open"] as? Int
        name = dictionary["name"] as? String
        scriptClueId = dictionary["script_clue_id"] as? Int
        scriptPlaceId = dictionary["script_place_id"] as? Int
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
        if childId != nil{
            dictionary["child_id"] = childId
        }
        if isGoing != nil{
            dictionary["is_going"] = isGoing
        }
        if isOpen != nil{
            dictionary["is_open"] = isOpen
        }
        if name != nil{
            dictionary["name"] = name
        }
        if scriptClueId != nil{
            dictionary["script_clue_id"] = scriptClueId
        }
        if scriptPlaceId != nil{
            dictionary["script_place_id"] = scriptPlaceId
        }
        return dictionary
    }

}

