//
//  OrderTimeView.swift
//  Murder
//
//  Created by m.a.c on 2020/11/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

protocol OrderTimeViewDelegate {
    // 确认时间
    func comfirmBtnAction()
}


class OrderTimeView: UIView {
    
    var delegate: OrderTimeViewDelegate?

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var commonView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var comfirmBtn: UIButton!
   
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension OrderTimeView {
    private func setUI() {
        
        heightConstraint.constant = 300 + HOME_INDICATOR_HEIGHT
        
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.viewWithCorner(byRoundingCorners: [UIRectCorner.topRight,UIRectCorner.topLeft], radii: 20)
        
        
        pickerView.backgroundColor = UIColor.clear
        
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        
        
        comfirmBtn.addTarget(self, action: #selector(comfirmBtnTap), for: .touchUpInside)
    }
}

extension OrderTimeView {
    @objc private func comfirmBtnTap() {
        if delegate != nil {
            delegate?.comfirmBtnAction()
        }
    }
}

extension OrderTimeView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 2 {
            return ":"
        }
        let str = "\(component)\(row)"
        return str
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            self.pickerView(pickerView, didSelectRow: row, inComponent: 2)
        }
    }
     
}



extension OrderTimeView {
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


