//
//  HomeUserModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class HomeUserModel : NSObject{

    var head : String!
    var level : String!
    var nickname : String!
    
    // 自定义构造函数
//    init(dic : [String : AnyObject]) {
//        super.init()
//        setValuesForKeys(dic)
//    }
    
    init(fromDictionary dictionary: [String:Any]){
        head = dictionary["head"] as? String
        level = dictionary["level"] as? String
        nickname = dictionary["nickname"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if head != nil{
            dictionary["head"] = head
        }
        if level != nil{
            dictionary["level"] = level
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        return dictionary
    }

    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
