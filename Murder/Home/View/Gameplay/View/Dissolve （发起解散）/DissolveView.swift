//
//  DissolveView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

// 点击textViewBlock回掉
// 发起解散
typealias DissolutionBtnTapBlcok = () ->()

// 解散
typealias DissolutionStartTapBlcok = () ->()

// 不解散
typealias DissolutionNoTapBlcok = () ->()

// 取消
typealias DissolutionCancelTapBlcok = () ->()

/// 发起解散
class DissolveView: UIView {

    @IBOutlet var contentView: UIView!
    // 发起解散
    @IBOutlet weak var dissolutionView: UIView!
    // 发起解散提示Label
    @IBOutlet weak var dissolutionLabel: UILabel!
    // 取消
    @IBOutlet weak var dissolutionCandelBtn: UIButton!
    // 发起
    @IBOutlet weak var dissolutionStartBtn: GradienButton!
    // 解散投票
    @IBOutlet weak var votingView: UIView!
    // 解散投票提示Label
    @IBOutlet weak var votingLabel: UILabel!
    // 解散
    @IBOutlet weak var dissolutionBtn: UIButton!
    // 不解散
    @IBOutlet weak var noDissolutionBtn: UIButton!
    
    // 解散
    var dissolutionBtnTapBlcok: DissolutionBtnTapBlcok?
    
    // 不解散
    var dissolutionBtnNoBlcok: DissolutionNoTapBlcok?
    
    // 发起
    var dissolutionBtnStartBlcok: DissolutionStartTapBlcok?
    
    // 取消
    var dissolutionBtnCancelBlcok: DissolutionCancelTapBlcok?
    
    
    //MARK: - 发起解散 - 取消
    @IBAction func dissolutionCancelBtnAvtion(_ sender: Any) {
        // 隐藏视图
        if dissolutionBtnCancelBlcok != nil {
            dissolutionBtnCancelBlcok!()
        }
    }
    
    //MARK: - 发起解散 - 发起
    @IBAction func dissolutionStartAction(_ sender: Any) {
//        dissolutionView.isHidden = false
//        votingView.isHidden = true
        if dissolutionBtnStartBlcok != nil {
            dissolutionBtnStartBlcok!()
        }
    }
    
    
    //MARK: - 解散
    @IBAction func dissolutionBtnAction(_ sender: Any) {
//        dissolutionView.isHidden = true
//        votingView.isHidden = true
         if dissolutionBtnTapBlcok != nil {
            dissolutionBtnTapBlcok!()
        }
    }
    //MARK: - 不解散
    @IBAction func noDissolutionBtnAction(_ sender: Any) {
        // 隐藏视图
//        hideView()
//        dissolutionView.isHidden = true
//        votingView.isHidden = true
        if dissolutionBtnNoBlcok != nil {
            dissolutionBtnNoBlcok!()
        }
    }
    
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        
        dissolutionView.isHidden = true
        votingView.isHidden = true
        
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
  

}

// MARK: - setUI
extension DissolveView {
    private func setUI() {
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)

        dissolutionCandelBtn.layer.borderColor = HexColor(MainColor).cgColor
        dissolutionCandelBtn.layer.borderWidth = 0.5
//        dissolutionStartBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        dissolutionStartBtn.setGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        
        
        dissolutionBtn.layer.borderColor = HexColor(MainColor).cgColor
        dissolutionBtn.layer.borderWidth = 0.5
        noDissolutionBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
    }
    
    private func hideView() {
        dissolutionView = nil
        votingView = nil
        contentView = nil
        self.removeFromSuperview()
    }
}


extension DissolveView {
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
