//
//  HomeViewModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
    // 定义属性
    @objc var bannerModelArr : [HomeBannerModel]?
    
    @objc var userModel : HomeUserModel?
    

    
    init(bannerModelArr : [HomeBannerModel], userModel: HomeUserModel  ) {
        self.bannerModelArr = bannerModelArr
        self.userModel = userModel
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    


}
