//
//  PrepareOrderView.swift
//  Murder
//
//  Created by m.a.c on 2020/11/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class PrepareOrderView: UIView {

    @IBOutlet var contentView: UIView!
    

    @IBOutlet weak var commonView: UIView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    
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
extension PrepareOrderView {
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        contentLabel.textColor = HexColor(LightOrangeColor)
        contentLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        tipLabel.textColor = HexColor(DarkGrayColor)
        tipLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        confirmBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
    }
    
    private func hideView() {
        contentView = nil
        self.removeFromSuperview()
    }
}

extension PrepareOrderView {
    // 确认
    @objc func confirmBtnAction() {
        
    }
    
}


extension PrepareOrderView {
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



