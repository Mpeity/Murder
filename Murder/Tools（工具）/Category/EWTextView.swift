//
//  EWTextView.swift
//  Murder
//
//  Created by m.a.c on 2020/9/13.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
class EWTextView: UITextView {
    
    
    fileprivate lazy var placeHolderLabel: UILabel = {
         $0.font = UIFont.systemFont(ofSize: 12)
         $0.text = "请输入内容~"
         $0.textColor = UIColor.lightGray
         $0.numberOfLines = 0
         return $0
     }(UILabel())
     
     
      var placeHolder: String? {
         didSet {
             
             placeHolderLabel.text = placeHolder
         }
     }
     
     
     override var font: UIFont? {
         didSet {
             if font != nil {
                 // 让在属性哪里修改的字体,赋给给我们占位label
                 placeHolderLabel.font = font
             }
         }
     }
     
     // 重写text
     override var text: String? {
         didSet {
             // 根据文本是否有内容而显示占位label
             placeHolderLabel.isHidden = hasText
         }
     }
     
     // frame
     override init(frame: CGRect, textContainer: NSTextContainer?) {
         super.init(frame: frame, textContainer: textContainer)
         setupUI()
     }
     // xib
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         setupUI()
     }
     
     // 添加控件,设置约束
     fileprivate func setupUI() {
         // 监听内容的通知
        NotificationCenter.default.addObserver(self, selector: #selector(EWTextView.valueChange), name: UITextView.textDidChangeNotification, object: nil)
         
         // 添加控件
         addSubview(placeHolderLabel)
         
         // 设置约束,使用系统的约束
         placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
         
         addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -10))
     }
     
     // 内容改变的通知方法
     @objc fileprivate func valueChange() {
         //占位文字的显示与隐藏
         placeHolderLabel.isHidden = hasText
     }
     // 移除通知
     deinit {
         NotificationCenter.default.removeObserver(self)
     }
     
     // 子控件布局
     override func layoutSubviews() {
         super.layoutSubviews()
         // 设置占位文字的坐标
         placeHolderLabel.frame.origin.x = 5
         placeHolderLabel.frame.origin.y = 7
     }
    
    
//    /// setNeedsDisplay调用drawRect
//    var placeHolder: String = ""{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//    var placeHolderColor: UIColor = UIColor.gray{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//    override var font: UIFont?{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//    override var text: String!{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//    override var attributedText: NSAttributedString!{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        /// default字号
//        self.font = UIFont.systemFont(ofSize: 14)
//        NotificationCenter.default.addObserver(self, selector: #selector(textDidChanged(noti:)), name: UITextView.textDidChangeNotification, object: self)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    @objc func textDidChanged(noti: NSNotification)  {
//        self.setNeedsDisplay()
//    }
//    override func draw(_ rect: CGRect) {
//        if self.hasText {
//            return
//        }
//        var newRect = CGRect()
//        newRect.origin.x = 5
//        newRect.origin.y = 7
//        let size = self.placeHolder.getStringSize(rectSize: rect.size, font: self.font ?? UIFont.systemFont(ofSize: 14))
//        newRect.size.width = size.width
//        newRect.size.height = size.height
//        /// 将placeHolder画在textView上
//        (self.placeHolder as NSString).draw(in: newRect, withAttributes: [NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: self.placeHolderColor])
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.setNeedsDisplay()
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
//    }
//
//}
//
//extension String {
//    /// 计算字符串的尺寸
//    ///
//    /// - Parameters:
//    ///   - text: 字符串
//    ///   - rectSize: 容器的尺寸
//    ///   - fontSize: 字体
//    /// - Returns: 尺寸
//    ///
//    public func getStringSize(rectSize: CGSize,font: UIFont) -> CGSize {
//        let str: NSString = self as NSString
//        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
//    }
}
