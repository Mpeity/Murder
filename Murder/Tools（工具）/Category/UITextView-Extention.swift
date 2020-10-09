//
//  UITextView-Extention.swift
//  Murder
//
//  Created by m.a.c on 2020/8/13.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation
import UIKit


//extension UITextView {
//
//    var placeholderLabel:UILabel?{
//        get{
//            var label:UILabel? = objc_getAssociatedObject(self, &"placeholderLabel") as? UILabel
//            if label == nil{
//
//                let originalText:NSAttributedString=self.attributedText
//                self.text=""
//                self.attributedText = originalText
//                label = UILabel()
//                label?.textColor=UIColor.lightGray
//                label?.numberOfLines=0
//                label?.isUserInteractionEnabled=false
//                //关联label属性
//                objc_setAssociatedObject(self, &"placeholderLabel", label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                //KVO监听TextView各属性的变化，并更新placeholderLabel
//                 NotificationCenter.default.addObserver(self, selector: #selector(self.updatePlaceholderLabel), name: NSNotification.Name.UITextViewTextDidChange, object: self)
//                  let observingKeys = ["attributedText",
//
//                                         "bounds",
//
//                                         "font",
//
//                                         "frame",
//
//                                         "textAlignment",
//
//                                         "textContainerInset"]
//
//                    for key in observingKeys {
//
//                        设置监听
//
//                        self.addObserver(self, forKeyPath: key, options: .new, context:nil)
//
//                       }
//
//                    let hooker = DeallocHooker()
//
//                    //通过闭包判断TextView是否dealloc,在dealloc时移除监听
//
//                    hooker.deallocHandle= {
//
//                        NotificationCenter.default.removeObserver(self)
//
//                        for key in observingKeys {
//
//                            self.removeObserver(self, forKeyPath: key)
//
//                        }
//
//                    }
//
//                    objc_setAssociatedObject(self, &AssociatedKeys.deallocHooker,     hooker, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//                }
//
//                returnlabel
//
//            }
//
//        }
//
//}
