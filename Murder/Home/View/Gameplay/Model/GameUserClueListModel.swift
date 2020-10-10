//
//  GameUserClueListModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class ClueListModel : NSObject {

    var attachmentId : String?
    var attachment : String?
    var childId : Int?
    var isGoing : Int?
    var isOpen : Int?
    var isPrivate : Int?
    var isRead : Int?
    var scriptClueDetail : String?
    var scriptClueId : Int?
    var scriptClueName : String?
    var scriptNodeId : Int?
    var scriptPlaceId : Int?
    var scriptPlaceName : String?
    var scriptRoleId : Int?
    var userId : Int?
    var userOpen : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attachmentId = dictionary["attachment_id"] as? String

        attachment = dictionary["attachment"] as? String
        childId = dictionary["child_id"] as? Int
        isGoing = dictionary["is_going"] as? Int
        isOpen = dictionary["is_open"] as? Int
        isPrivate = dictionary["is_private"] as? Int
        isRead = dictionary["is_read"] as? Int
        scriptClueDetail = dictionary["script_clue_detail"] as? String
        scriptClueId = dictionary["script_clue_id"] as? Int
        scriptClueName = dictionary["script_clue_name"] as? String
        scriptNodeId = dictionary["script_node_id"] as? Int
        scriptPlaceId = dictionary["script_place_id"] as? Int
        scriptPlaceName = dictionary["script_place_name"] as? String
        scriptRoleId = dictionary["script_role_id"] as? Int
        userId = dictionary["user_id"] as? Int
        userOpen = dictionary["user_open"] as? Int
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
        
        if attachment != nil{
            dictionary["attachment"] = attachment
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
        if isPrivate != nil{
            dictionary["is_private"] = isPrivate
        }
        if isRead != nil{
            dictionary["is_read"] = isRead
        }
        if scriptClueDetail != nil{
            dictionary["script_clue_detail"] = scriptClueDetail
        }
        if scriptClueId != nil{
            dictionary["script_clue_id"] = scriptClueId
        }
        if scriptClueName != nil{
            dictionary["script_clue_name"] = scriptClueName
        }
        if scriptNodeId != nil{
            dictionary["script_node_id"] = scriptNodeId
        }
        if scriptPlaceId != nil{
            dictionary["script_place_id"] = scriptPlaceId
        }
        if scriptPlaceName != nil{
            dictionary["script_place_name"] = scriptPlaceName
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userOpen != nil{
            dictionary["user_open"] = userOpen
        }
        return dictionary
    }

}


class GameUserClueListModel : NSObject {

    var clueList : [ClueListModel]?
    var isRead : Int?
    var scriptPlaceId : Int?
    var scriptPlaceName : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        clueList = [ClueListModel]()
        if let clueListArray = dictionary["clue_list"] as? [[String:Any]]{
            for dic in clueListArray{
                let value = ClueListModel(fromDictionary: dic)
                clueList!.append(value)
            }
        }
        isRead = dictionary["is_read"] as? Int
        scriptPlaceId = dictionary["script_place_id"] as? Int
        scriptPlaceName = dictionary["script_place_name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if clueList != nil{
            var dictionaryElements = [[String:Any]]()
            for clueListElement in clueList! {
                dictionaryElements.append(clueListElement.toDictionary())
            }
            dictionary["clue_list"] = dictionaryElements
        }
        if isRead != nil{
            dictionary["is_read"] = isRead
        }
        if scriptPlaceId != nil{
            dictionary["script_place_id"] = scriptPlaceId
        }
        if scriptPlaceName != nil{
            dictionary["script_place_name"] = scriptPlaceName
        }
        return dictionary
    }
}
