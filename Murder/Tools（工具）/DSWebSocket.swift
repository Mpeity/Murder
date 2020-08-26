//
//  DSWebSocket.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import Starscream

 @objc public protocol DSWebSocketDelegate: NSObjectProtocol{
  /** websocket 连接成功*/
    @objc optional func websocketDidConnect(sock: DSWebSocket)
  /** websocket 连接失败*/
    @objc optional  func websocketDidDisconnect(socket: DSWebSocket, error: Error?)
  /** websocket 接受文字信息*/
    @objc func websocketDidReceiveMessage(socket: DSWebSocket, text: String)
  /** websocket 接受二进制信息*/
    @objc optional  func  websocketDidReceiveData(socket: DSWebSocket, data: NSData)
  }

public class DSWebSocket: NSObject,WebSocketDelegate {
 
  var socket:WebSocket!
    
  weak var webSocketDelegate: DSWebSocketDelegate?
  //单例
  class func sharedInstance() -> DSWebSocket {
      return manger
  }
  static let manger: DSWebSocket = {
      return DSWebSocket()
  }()

  //MARK:- 链接服务器
func connectSever(){
    let socket : WebSocket = WebSocket(url: NSURL(string: "\(SocketUrl):9090")! as URL)
    socket.delegate = self
    socket.connect()
 }

//发送文字消息
func sendBrandStr(brandID:String){
    socket.write(string: brandID)
}
//MARK:- 关闭消息
func disconnect(){
    socket.disconnect()
}

//MARK: - WebSocketDelegate
//客户端连接到服务器时，websocketDidConnect将被调用。
public func websocketDidConnect(socket: WebSocketClient) {
     debugPrint("连接成功了")
    webSocketDelegate?.websocketDidConnect!(sock: self)
 }
 
//客户端与服务器断开连接后，将立即调用 websocketDidDisconnect。
 public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    debugPrint("连接失败了: \(String(describing: error?.localizedDescription))")
    webSocketDelegate?.websocketDidDisconnect!(socket: self, error: error as NSError?)
 }
 
//当客户端从连接获取一个文本框时，调用 websocketDidReceiveMessage。
//注：一般返回的都是字符串
 public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    
    debugPrint("接受到消息了: \(text)")
    webSocketDelegate?.websocketDidReceiveMessage(socket: self, text: text)
 }
 
 public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    
    debugPrint("data数据")
    webSocketDelegate?.websocketDidReceiveData!(socket: self, data: data as NSData)
     }
 }
    
