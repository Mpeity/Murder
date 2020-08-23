//
//  UserAccount.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/7.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class UserAccount : NSObject, NSCoding{

    var key : String?
    var nickname : String?
    var userId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        key = dictionary["key"] as? String
        nickname = dictionary["nickname"] as? String
        userId = dictionary["user_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if key != nil{
            dictionary["key"] = key
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         key = aDecoder.decodeObject(forKey: "key") as? String
         nickname = aDecoder.decodeObject(forKey: "nickname") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if key != nil{
            aCoder.encode(key, forKey: "key")
        }
        if nickname != nil{
            aCoder.encode(nickname, forKey: "nickname")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }

    }

}

//class UserAccount: NSObject , NSCoding {
//
//    @objc var key : String?
//    var user_id : Int?
//
//
////    // 授权token
////    @objc var access_token : String?
////    // 过期时间
////    @objc var expires_in : TimeInterval = 0.0 {
////        didSet {
////            expires_date = Date(timeIntervalSinceNow: expires_in)
////        }
////    }
////    // 用户id
////    @objc var uid : String?
////
////    // 过期日期
////    @objc var expires_date : Date?
////
////    // 昵称
////    @objc var screen_name : String?
////    // 用户的头像地址
////    @objc var avatar_large : String?
//
//
//    // 构造函数
//    init(dic : [String : AnyObject]) {
//        super.init()
//        setValuesForKeys(dic)
//    }
//
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//
//    }
//
//    // 重写 description属性
//    override var description: String {
////        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid","screen_name", "avatar_large"]).description
//
//        return dictionaryWithValues(forKeys: ["key","user_id"]).description
//    }
//
//
//
//    // 解档
//    required init?(coder: NSCoder) {
//        key = coder.decodeObject(forKey: "key") as? String
//        user_id = coder.decodeObject(forKey: "user_id") as? Int
//
//    }
//
//    // 归档
//    func encode(with coder: NSCoder) {
//        coder.encode(key, forKey: "key")
//        coder.encode(user_id, forKey: "user_id")
//
//    }
//
//
//}
