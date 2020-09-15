//
//  MessageContentModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/2.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

import UIKit


class MessageContentModel : NSObject {

    var list : [MsgList]?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [MsgList]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = MsgList(fromDictionary: dic)
                list!.append(value)
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

class MsgTalkModel : NSObject {
    
    var showTime: Bool? = false
    
    var cellType: CellType?

    // for text message
    var text: String?
    
    // for image message
    var mediaId: String?
    
    // for thumbnail imagedata
    var thumbnail: Data?
    //
    var cellHeight: CGFloat?
    // 头像
    var head: String?
    

    var content : String?
    var roomId : Int?
    var scriptCover : String?
    var scriptDes : String?
    var scriptId : Int?
    var scriptName : String?
    var sendId : Int?
    var targetId : Int?
    var timeMs : String?
    var type : Int?
    
    



    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        content = dictionary["content"] as? String
        roomId = dictionary["room_id"] as? Int
        scriptCover = dictionary["script_cover"] as? String
        scriptDes = dictionary["script_des"] as? String
        scriptId = dictionary["script_id"] as? Int
        scriptName = dictionary["script_name"] as? String
        sendId = dictionary["send_id"] as? Int
        targetId = dictionary["target_id"] as? Int
        timeMs = dictionary["time_ms"] as? String
        type = dictionary["type"] as? Int
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
        if roomId != nil{
            dictionary["room_id"] = roomId
        }
        if scriptCover != nil{
            dictionary["script_cover"] = scriptCover
        }
        if scriptDes != nil{
            dictionary["script_des"] = scriptDes
        }
        if scriptId != nil{
            dictionary["script_id"] = scriptId
        }
        if scriptName != nil{
            dictionary["script_name"] = scriptName
        }
        if sendId != nil{
            dictionary["send_id"] = sendId
        }
        if targetId != nil{
            dictionary["target_id"] = targetId
        }
        if timeMs != nil{
            dictionary["time_ms"] = timeMs
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
}



class MsgList : NSObject {
    var content : String?

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        content = dictionary["content"] as? String
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
        return dictionary
    }
}
