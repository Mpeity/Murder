//
//  LogoutTools.swift
//  Murder
//
//  Created by m.a.c on 2020/9/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation



// 退出账号
func AgoraRtmLogout() {
    guard AgoraRtm.status == .online else {
        return
    }
    AgoraRtm.kit?.logout(completion: { (error) in
        guard error == .ok else {
            return
        }
        AgoraRtm.status = .offline
    })
}


func userLogout() {
    //删除归档文件
    let defaultManager = FileManager.default
    if defaultManager.isDeletableFile(atPath: UserAccountViewModel.shareInstance.accountPath) {
        do {
            try defaultManager.removeItem(atPath: UserAccountViewModel.shareInstance.accountPath)
        } catch  {
            
        }
        
    }
    
}
