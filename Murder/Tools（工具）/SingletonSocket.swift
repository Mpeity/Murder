//
//  SingletonSocket.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/14.
//  Copyright © 2020 m.a.c. All rights reserved.
//


import UIKit
import Starscream
 
 
class SingletonSocket {
    let socket : WebSocket = WebSocket(url: NSURL(string: "\(SocketUrl):9090")! as URL)
//    let socket:WebSocket = WebSocket(url: NSURL(string: strScoket) as! URL)
    
    class var sharedInstance : SingletonSocket{
        struct Static{
            static let instance:SingletonSocket = SingletonSocket()
        }
        if !Static.instance.socket.isConnected{
            Static.instance.socket.connect()
        }
        return Static.instance
    }
}
