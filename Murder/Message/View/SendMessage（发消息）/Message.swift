//
//  Message.swift
//  Agora-RTM-Tutorial
//
//  Created by SRS on 2020/4/2.
//  Copyright © 2020 Agora. All rights reserved.
//

import UIKit

enum CellType {
    case left, right
}

//{
//"type":1, //1文字 2 剧本详情 3 剧本邀请
//"content":"内容",
//"script_id":1,
//"script_name":"剧本名字",
//"script_cover":"剧本封面",
//"script_des":"剧本简介",
//"room_id":"房间id",
//"send_id":"发送者id",
//"target_id":"接受者id",
//"time_ms":"1587009745719"//13位时间戳
//}

struct Message {
    //1文字 2 剧本详情 3 剧本邀请
    var type: Int?
    // 内容
    var content: String?
    // script_id
    var script_id: Int?
    // 剧本名字
    var script_name: String?
    // 剧本封面
    var script_cover: String?
    // 剧本简介
    var script_des: String?
    // 房间id
    var room_id: Int?
    // 发送者id
    var send_id: Int?
    // 接受者id
    var target_id: Int?
    // 13位时间戳
    var time_ms: String?
    
    // 
    var typeStr: CellType?
    
    var userId: String
    
    // for text message
    var text: String?
    
    // for image message
    var mediaId: String?
    
    // for thumbnail imagedata
    var thumbnail: Data?
    // 
    var cellHeight: CGFloat?
    // 头像
    var head: String?
}
