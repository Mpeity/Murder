//
//  HomeBannerModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation
import UIKit



class HomeBannerModel : NSObject{

    var bannerType : Int!
    @objc var datas : String!
    @objc var img : String!
    
    // 自定义构造函数
    init(fromDictionary dictionary: [String:Any]){
        bannerType = dictionary["banner_type"] as? Int
        datas = dictionary["datas"] as? String
        img = dictionary["img"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bannerType != nil{
            dictionary["banner_type"] = bannerType
        }
        if datas != nil{
            dictionary["datas"] = datas
        }
        if img != nil{
            dictionary["img"] = img
        }
        return dictionary
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
