//
//  SingletonSocket.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/14.
//  Copyright © 2020 m.a.c. All rights reserved.
//


import UIKit
import Starscream
import Reachability
import SVProgressHUD
 

var reConnectTime = 0 //设置重连次数
let reachability = Reachability()! //判断网络连接
//let hudProgress = AnimateView()

class SingletonSocket: NSObject  {
    let socket : WebSocket = WebSocket(url: NSURL(string: "\(SocketUrl):9090")! as URL)
//    let socket:WebSocket = WebSocket(url: NSURL(string: strScoket) as! URL)

    class var sharedInstance : SingletonSocket{
        struct Static{
            static let instance:SingletonSocket = SingletonSocket()
        }
        if !Static.instance.socket.isConnected{
            Static.instance.socket.connect()
            SVProgressHUD.dismiss()
        }
        return Static.instance
    }
    
//    func websocketDidConnect(socket: WebSocketClient) {
//         //设置重连次数，解决无限重连问题
//        reConnectTime = 0
//    }
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        //执行重新连接方法
//        socketReconnect()
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//    }
//
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print(" WebSocketSingle DidReceiveMessage data:",data)
//    }
    
}


//socket 重连逻辑
func socketReconnect() {
    SVProgressHUD.show(withStatus: "连接中")
    //判断网络情况，如果网络正常，可以执行重连
    if reachability.connection != .none {
        //设置重连次数，解决无限重连问题
        reConnectTime =  reConnectTime + 1
        if reConnectTime < 5 {
            //添加重连延时执行，防止某个时间段，全部执行
            let time: TimeInterval = 2.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                if !SingletonSocket.sharedInstance.socket.isConnected {
                    SingletonSocket.sharedInstance.socket.connect()
                    SingletonSocket.sharedInstance.socket.disconnect()
                    
                }
            }
        } else {
            //提示重连失败
            showToastCenter(msg: "服务器被妖怪抓走了")

        }
    } else {
        //提示无网络
        showToastCenter(msg: "网络开小差了哟")

    }
    SVProgressHUD.dismiss()
}

//socket主动断开，放在app进入后台时，数据进入缓存。app再进入前台，app出现卡死的情况
func socketDisConnect() {
    if SingletonSocket.sharedInstance.socket.isConnected {
        SingletonSocket.sharedInstance.socket.disconnect()
    }
}
