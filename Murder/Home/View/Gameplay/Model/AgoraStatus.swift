//
//  AgoraStatus.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/6.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import AgoraRtcKit

class AgoraStatus: NSObject {
    
    static let agoraStatus = AgoraStatus()
    
    var muteLocalAudio: Bool = false
    
    var muteAllRemote: Bool = false
    
    static func sharedStatus() -> AgoraStatus {
        return agoraStatus
    }
}

