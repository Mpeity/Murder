//
//  PopTipView.swift
//  Murder
//
//  Created by m.a.c on 2020/9/13.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit



class PopTipView: UIView {
    

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var commonView: UIView!
    
    @IBOutlet weak var imgBgView: UIImageView!
    
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var content: String? {
        didSet {
            guard let content = content else {
                return
            }
            
            // 富文本
            guard let news = content.removingPercentEncoding,let data = news.data(using: .unicode) else{return}
            let att = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html]
            guard let attStr = try? NSMutableAttributedString(data: data, options: att, documentAttributes: nil) else{return}
            let range = NSMakeRange(0, attStr.length)
            attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12.0)], range: range)
            

            contentTextView.attributedText = attStr
        }
    }
    
    

    
    
    //初始化时将xib中的view添加进来
       override init(frame: CGRect) {
           super.init(frame: frame)
           contentView = loadViewFromNib()
           addSubview(contentView)
           addConstraints()
           
           setUI()
       }
       
       //初始化时将xib中的view添加进来
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
    
}


// MARK: - setUI
extension PopTipView {
    private func setUI() {
        contentTextView.isEditable = false
//        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        contentView.backgroundColor = UIColor.clear
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
//        contentTextView.addGestureRecognizer(tap)
    }
    
    @objc private func hideView() {
        self.isHidden = true
    }
}


extension PopTipView {

    
}

extension PopTipView {
    //加载xib
     func loadViewFromNib() -> UIView {
         let className = type(of: self)
         let bundle = Bundle(for: className)
         let name = NSStringFromClass(className).components(separatedBy: ".").last
         let nib = UINib(nibName: name!, bundle: bundle)
         let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
         return view
     }
     //设置好xib视图约束
     func addConstraints() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView!, attribute: .leading,
                                             relatedBy: .equal, toItem: self, attribute: .leading,
                                             multiplier: 1, constant: 0)
        addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .trailing,
                                         relatedBy: .equal, toItem: self, attribute: .trailing,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal,
                                         toItem: self, attribute: .top, multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .bottom,
                                         relatedBy: .equal, toItem: self, attribute: .bottom,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
     }
}
