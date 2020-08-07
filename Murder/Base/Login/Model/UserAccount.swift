//
//  UserAccount.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/7.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class UserAccount: NSObject , NSCoding {
    
    @objc var key : String?
    @objc var user_id : String?
    
    
    // 授权token
    @objc var access_token : String?
    // 过期时间
    @objc var expires_in : TimeInterval = 0.0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    // 用户id
    @objc var uid : String?
    
    // 过期日期
    @objc var expires_date : Date?
    
    // 昵称
    @objc var screen_name : String?
    // 用户的头像地址
    @objc var avatar_large : String?
    
    
    // 构造函数
    init(dic : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 重写 description属性
    override var description: String {
//        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid","screen_name", "avatar_large"]).description
        
        return dictionaryWithValues(forKeys: ["key","user_id"]).description
    }
    
    
    
    // 解档
    required init?(coder: NSCoder) {
        access_token = coder.decodeObject(forKey: "access_token") as? String
        uid = coder.decodeObject(forKey: "uid") as? String
        expires_date = coder.decodeObject(forKey: "expires_date") as? Date
        avatar_large = coder.decodeObject(forKey: "avatar_large") as? String
        screen_name = coder.decodeObject(forKey: "screen_name") as? String

    }
    
    // 归档
    func encode(with coder: NSCoder) {
        coder.encode(access_token, forKey: "access_token")
        coder.encode(uid, forKey: "uid")
        coder.encode(expires_date, forKey: "expires_date")
        coder.encode(screen_name, forKey: "screen_name")
        coder.encode(avatar_large, forKey: "avatar_large")

    }
    
    
}
