//
//  ScriptLocalData.swift
//  Murder
//
//  Created by m.a.c on 2020/8/19.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class ScriptLocalData: NSObject {
    // 线程安全
    static let shareInstance: ScriptLocalData = {
        let tool = ScriptLocalData()
        return tool
    }()
}

extension ScriptLocalData {
    /** 储存
      * - parameter key:   key
      * - parameter value: value
      */
     func setNormalDefault(key:String, value:AnyObject?){
         if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
         } else{
            UserDefaults.standard.set(value, forKey: key)
            // 同步
            UserDefaults.standard.synchronize()
         }
     }
     
     /** 通过对应的key移除储存
      * - parameter key: 对应key
      */
     func removeNormalUserDefault(key:String?){
         if key != nil {
            UserDefaults.standard.removeObject(forKey: key!)
            UserDefaults.standard.synchronize()
         }
     }
     
     /** 通过key找到储存的value
      * - parameter key: key
      * - returns: AnyObject
      */
     func getNormalDefult(key:String)->AnyObject?{
        return UserDefaults.standard.value(forKey: key) as AnyObject?
     }
}
