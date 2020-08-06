//
//  Date-Extention.swift
//  Swift_WB
//
//  Created by mac on 2020/7/3.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

extension Date {
    static func createDateString(createAtStr : String) -> String {
        // 创建时间
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale
        
        // 将字符串时间 专为NSDate类型
        guard let createDate = formatter.date(from: createAtStr) else {
            return ""
        }
        
        // 创建当前时间
        let nowDate = Date()
        
        // 计算时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 对时间间隔处理
        
        // 刚刚
        if interval < 60 {
            return "刚刚"
        }
        
        // 59分钟前
        if interval < 60 * 60  {
            return "\(interval / (60*60))" + "分钟前"
        }
        
        // 11小时前
        if interval <  60 * 60 * 24 {
            return "\(interval / (60*60))" + "小时前"
        }
        
        // 处理昨天的数据
        // 创建日历
        let calender = NSCalendar.current
        
        if calender.isDateInYesterday(createDate) {
            formatter.dateFormat = "昨天 HH:mm"
            let timeStr = formatter.string(from: createDate)
            return timeStr
        }
        
        // 处理一年之内： 02-22 12:23
        let componse = calender.dateComponents([.year], from: createDate, to: nowDate)
        if componse.year! < 1 {
            formatter.dateFormat = "MM-dd HH:mm"
            let timeStr = formatter.string(from: createDate)
            return timeStr
        }
        
        // 处理超过一年的 2017-02-09 12:11
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = formatter.string(from: createDate)
        return timeStr
    }
    

}
