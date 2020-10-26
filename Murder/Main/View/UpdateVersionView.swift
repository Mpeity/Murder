//
//  UpdateVersionView.swift
//  Murder
//
//  Created by m.a.c on 2020/10/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class UpdateVersionView: UIView {
    
//    @IBOutlet var contentView: UIView!
//
//    @IBOutlet weak var commonView: UIView!
    
//    // 底部约束
//    @IBOutlet weak var topConstraint: NSLayoutConstraint!
//    // 高度约束
//    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
//
//    @IBOutlet weak var contentHeight: NSLayoutConstraint!
//    // 头部
//    @IBOutlet weak var headerImgView: UIImageView!
//    // 内容
//    @IBOutlet weak var contentLabel: UILabel!
//
//    // 更新按钮
//    @IBOutlet weak var updateButton: UIButton!
    
    
    var contentView: UIView?
    
    var commonView: UIView?
    
    var whiteBgView: UIView?
    
    var headerImgView: UIImageView?
    
    var contentLabel: UILabel?
    
    var updateButton: UIButton?
    
    
    var model: UpdateVersionModel? {
        didSet {
            guard let model = model else {
                return
            }
                        
            if model.content != nil {
                
                headerImgView?.sizeToFit()
                
                var viewHeight = 0.0
                
                let content = model.content
                
                let imgHeight = headerImgView?.image?.size.height

                let myMutableString = try! NSMutableAttributedString(data: (content!.data(using: String.Encoding.unicode))!, options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType:NSMutableAttributedString.DocumentType.html], documentAttributes: nil)
//                let range = NSMakeRange(0, myMutableString.length)
//                myMutableString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)], range: range)
                
                
                let size = stringSizeWithString(text: myMutableString.string, width: (FULL_SCREEN_WIDTH-75*2), font: UIFont.systemFont(ofSize: 14))

                viewHeight = Double(imgHeight!  + size.height + 109 + 50)
                let top = (FULL_SCREEN_HEIGHT - CGFloat(viewHeight))*0.4
                
                contentLabel?.layoutIfNeeded()
                
                self.layoutIfNeeded()
                
               
                
                contentLabel?.snp.remakeConstraints { (make) in
                    make.top.equalTo(imgHeight!+35)
                    make.height.equalTo(size.height + 50)
                    make.width.equalTo(FULL_SCREEN_WIDTH-75*2)
                    make.left.equalToSuperview().offset(38)
                    make.right.equalToSuperview().offset(-38)
                }
                
                commonView?.snp.remakeConstraints { (make) in
                    make.top.equalTo(top)
                    make.height.equalTo(viewHeight)
                    make.width.equalTo(FULL_SCREEN_WIDTH-75)
                    make.centerX.equalToSuperview()
                }
                
                contentLabel?.attributedText = myMutableString
            }
            
            
        }
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView = loadViewFromNib()
//        addSubview(contentView)
//        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
//        addConstraints()
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UpdateVersionView {
    private func setUI() {
        
        if contentView == nil {
            contentView = UIView()
            contentView?.frame = self.bounds
            contentView?.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            self.addSubview(contentView!)
        }
        
        if commonView == nil {
            commonView = UIView()
            commonView?.backgroundColor = UIColor.clear
            contentView?.addSubview(commonView!)
            commonView?.snp.makeConstraints({ (make) in
                make.top.equalTo(145)
                make.left.equalToSuperview().offset(37.5)
                make.right.equalToSuperview().offset(-37.5)
                make.height.equalTo(335)
            })
        }
        
        if whiteBgView == nil {
            whiteBgView = UIView()
            whiteBgView?.backgroundColor = UIColor.white
            commonView?.addSubview(whiteBgView!)
            whiteBgView?.layer.cornerRadius = 5
            whiteBgView?.layer.masksToBounds = true
            whiteBgView?.snp.makeConstraints({ (make) in
                make.top.equalTo(30)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            })

        }
        
        if headerImgView == nil {
            headerImgView = UIImageView()
            headerImgView?.image = UIImage(named: "tc_head")
            commonView?.addSubview(headerImgView!)
        }
        
        if contentLabel == nil {
            contentLabel = UILabel()
            contentLabel?.numberOfLines = 0
            contentLabel?.textColor = HexColor(DarkGrayColor)
            contentLabel?.font = UIFont.systemFont(ofSize: 14)
            commonView?.addSubview(contentLabel!)
            contentLabel?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(180)
                make.left.equalToSuperview().offset(38)
                make.right.equalToSuperview().offset(-38)
            })
        }
        
        if updateButton == nil {
            updateButton = UIButton()
            updateButton?.setTitle("今すぐ更新", for: .normal)
            updateButton?.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
            commonView?.addSubview(updateButton!)
            updateButton?.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview().offset(-15)
                make.left.equalToSuperview().offset(25)
                make.right.equalToSuperview().offset(-25)
                make.height.equalTo(44)
            })
        }
  
        updateButton?.addTarget(self, action: #selector(updateButtonAction), for: .touchUpInside)
    }
    
    //MARK:- 获取文本高度
    private func getHeight(string: String, width:CGFloat)-> CGSize {
        let label = UILabel()
        label.backgroundColor = UIColor.gray
        label.text = string
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = HexColor("#666666")
        label.textAlignment = .left
        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        return size
    }
}


extension UpdateVersionView {
    @objc func updateButtonAction() {
        // 跳转到应用页面
        let str = "itms-apps://itunes.apple.com/app/id1535883814"
        UIApplication.shared.openURL(URL(string: str)!)
    }
}

extension UpdateVersionView {
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

//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        var constraint = NSLayoutConstraint(item: contentView!, attribute: .leading,
//                                             relatedBy: .equal, toItem: self, attribute: .leading,
//                                             multiplier: 1, constant: 0)
//        addConstraint(constraint)
//         constraint = NSLayoutConstraint(item: contentView!, attribute: .trailing,
//                                         relatedBy: .equal, toItem: self, attribute: .trailing,
//                                         multiplier: 1, constant: 0)
//         addConstraint(constraint)
//         constraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal,
//                                         toItem: self, attribute: .top, multiplier: 1, constant: 0)
//         addConstraint(constraint)
//         constraint = NSLayoutConstraint(item: contentView!, attribute: .bottom,
//                                         relatedBy: .equal, toItem: self, attribute: .bottom,
//                                         multiplier: 1, constant: 0)
//         addConstraint(constraint)
     }
}

