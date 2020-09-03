//
//  CreateRoomHeaderView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class CreateRoomHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    // 时长/字数
    @IBOutlet weak var commonLabel: UILabel!
    // 作者
    @IBOutlet weak var authorLabel: UILabel!
    
    // 人数
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var numLabel: UILabel!
    
    // 题材
    @IBOutlet weak var border2View: UIView!
    
    @IBOutlet weak var themeLabel: UILabel!
    // 难度
    @IBOutlet weak var border3View: UIView!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    var model: ScriptDetailModel! {
        didSet {
            guard let model = model else {
                return
            }
            if model.cover != nil{
                coverImgView.setImageWith(URL(string: model.cover!))
            }
            if model.name != nil {
                nameLabel.text = model.name!
            }
            
            commonLabel.text = "\(String(model.duration!)) | \(String(model.wordNum!))"
            
            authorLabel.text = model.author
            
            numLabel.text = String(model.peopleNum!) + "人"
            if !model.tag!.isEmpty {
                let item1 = model.tag![0]
                if item1 != nil {
                    themeLabel.text = item1.tagName
                }
                
                let item2 = model.tag![1]
                if item2 != nil {
                    difficultyLabel.text = item2.tagName
                }
            }
            
        }
    }

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

extension CreateRoomHeaderView {
    private func setUI() {
        borderView.backgroundColor = UIColor.clear
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = UIColor.white.cgColor
        borderView.layer.cornerRadius = 8.5
        
        border2View.backgroundColor = UIColor.clear
        border2View.layer.borderWidth = 0.5
        border2View.layer.borderColor = UIColor.white.cgColor
        border2View.layer.cornerRadius = 8.5
        
        border3View.backgroundColor = UIColor.clear
        border3View.layer.borderWidth = 0.5
        border3View.layer.borderColor = UIColor.white.cgColor
        border3View.layer.cornerRadius = 8.5
    }
    

}

extension CreateRoomHeaderView {
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


