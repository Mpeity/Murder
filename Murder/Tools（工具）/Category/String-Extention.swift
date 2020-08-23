//
//  String-Extention.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/7.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

extension String {
   var isEmptyString: Bool {
       let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
       return trimmedStr.isEmpty
   }
    
}
