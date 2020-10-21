//
//  NodeTypeView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/10/12.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class NodeTypeView: UIView {
    
    private var commonView: UIView?
    
    private var contentView: UIView?
    
    //
    private var textView: UITextView?
    // 确认按钮
    private var commonBtn: UIButton?
    
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
            attStr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)], range: range)
            
            var height = attStr.string.ga_heightForComment(fontSize: 15, width: FULL_SCREEN_WIDTH-30-20)
            
            
            let scaleHeight = 0.65 * FULL_SCREEN_HEIGHT
            var commonHeight = 0.0
            if height >=  scaleHeight {
                height = scaleHeight + 10
                commonHeight = Double(scaleHeight + 15 + 15 + 50 + 20)
            } else {
                commonHeight = Double(height + 15 + 15 + 50 + 20)
                height += 10
            }
            
            commonHeight += 20
            height += 20
            
            textView?.snp.remakeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(10)
                make.height.equalTo(height)
            })
            
            textView?.attributedText = attStr


            contentView?.snp.remakeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(FULL_SCREEN_WIDTH-30)
                make.height.equalTo(commonHeight)
                make.top.equalToSuperview().offset((Double(FULL_SCREEN_HEIGHT)-commonHeight)*0.5)
            })
            
            contentView?.layoutIfNeeded()
            
            textView?.layoutIfNeeded()

            

            
            
            
            
        }
    }
    
    

    // 关闭按钮
    @objc func cancelBtnAction(_ sender: Any) {
//        contentView = nil
//        commonView = nil
//        removeFromSuperview()
        self.isHidden = true
    }
     

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


    

extension NodeTypeView {
   
    //MARK:- 设置UI
    private func setUI() {
        self.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        if commonView == nil {
            commonView = UIView()
            self.addSubview(commonView!)
            commonView?.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            commonView?.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })

        }
        if contentView == nil {
            contentView = UIView()
            contentView?.backgroundColor = UIColor.white
            contentView?.layer.cornerRadius = 10
            contentView?.layer.masksToBounds = true
            commonView?.addSubview(contentView!)
            contentView?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(FULL_SCREEN_WIDTH-30)
                make.height.equalTo(0)
                make.top.equalToSuperview().offset(0)
            })
        }
        
        if textView == nil {
            textView = UITextView()
            textView?.backgroundColor = UIColor.white
            textView?.isEditable = false
            contentView?.addSubview(textView!)
            textView?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(10)
                make.height.equalTo(30)
            })
        }
        
        
        if commonBtn == nil {
            commonBtn = UIButton()
            commonBtn?.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
            commonBtn?.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
            commonBtn?.setTitle("確認", for: .normal)
            contentView?.addSubview(commonBtn!)
            commonBtn?.snp.makeConstraints({ (make) in
                commonBtn?.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(25)
                    make.width.equalTo(FULL_SCREEN_WIDTH-30-50)
                    make.bottom.equalToSuperview().offset(-15)
                    make.height.equalTo(50)
                })
            })
        }
    }
}

