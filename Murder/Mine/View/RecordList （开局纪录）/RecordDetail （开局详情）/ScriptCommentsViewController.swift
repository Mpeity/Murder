//
//  ScriptCommentsViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/10/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class ScriptCommentsViewController: UIViewController {

    // 名称
    var nameLabel: UILabel?

    var starView: StarView?
    
    var textBgView: UIView?
    
    var textView: EWTextView?
    
    var tagButton: UIButton?
        
    var confirmBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUI()
    }

    
    
    

}


extension ScriptCommentsViewController {
    private func setUI() {
        if nameLabel == nil {
            nameLabel = UILabel()
            nameLabel?.textColor = HexColor(DarkGrayColor)
            nameLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            nameLabel?.textAlignment = .center
            self.view.addSubview(nameLabel!)
            
            nameLabel?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(NAVIGATION_BAR_HEIGHT + 20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(27)
            })
            nameLabel?.text = "12222"
            
        }
        
        if starView == nil {
            let x = (FULL_SCREEN_WIDTH - 165) * 0.5
            starView = StarView(count: 9.0, lineSpace: 0, fullImgName: "pinglun_pic_01", halfImgName: "pinglun_pic_03", zeroImgName: "pinglun_pic_02", sizeWidth: 33.0, sizeHeight: 33.0, frame: CGRect(x: x, y: NAVIGATION_BAR_HEIGHT + 58, width: 165, height: 33))
            self.view.addSubview(starView!)
        }
        
        if textBgView == nil {
            textBgView = UIView()
            textBgView?.layer.cornerRadius = 10
            textBgView?.layer.masksToBounds = true
            self.view.addSubview(textBgView!)
            textBgView?.backgroundColor = HexColor("#F5F5F5")
            textBgView?.snp.makeConstraints { (make) in
                make.top.equalTo(starView!.snp_bottom).offset(17)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(200)
            }
        }

        if textView == nil {
            textView = EWTextView()
            textView?.backgroundColor = UIColor.clear
            textView?.placeHolder = "（任意）感想を記入しましょう。"
            textView?.font = UIFont.systemFont(ofSize: 12)
            textView?.textColor = HexColor(DarkGrayColor)
            textView?.delegate = self
            textView?.returnKeyType = .done
            textBgView?.addSubview(textView!)
            textView?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(17)
                make.right.equalToSuperview().offset(-17)
                make.top.equalToSuperview()
                make.height.equalTo(200)
            })
        }


        if tagButton == nil {
            tagButton = UIButton()
            tagButton?.createButton(style: .left, spacing: 3, imageName: "pic_04", title: "ネタバレあり", cornerRadius: 0, color: "#ffffff")
            tagButton?.setTitleColor(HexColor(DarkGrayColor), for: .normal)
            tagButton?.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            tagButton?.setImage(UIImage(named: "pic_04"), for: .normal)
            tagButton?.setImage(UIImage(named: "pic_04_check"), for: .selected)
            tagButton?.isSelected = false
            tagButton?.addTarget(self, action: #selector(tagButtonAction(button:)), for: .touchUpInside)
            self.view.addSubview(tagButton!)
            tagButton?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(90)
                make.top.equalTo(textBgView!.snp_bottom).offset(10)
                make.height.equalTo(25)
            })
        }
        
        

        
        
        
        if confirmBtn == nil {
            confirmBtn = UIButton()
            confirmBtn?.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
            confirmBtn?.setTitle("提出", for: .normal)
            self.view.addSubview(confirmBtn!)
            
            confirmBtn?.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
                } else {
                    make.bottom.equalToSuperview().offset(-12)
                }
            })
        }
        
        
        
    }
}

extension ScriptCommentsViewController {
    @objc func tagButtonAction(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected == true {
            tagButton?.isSelected = true
        } else {
            tagButton?.isSelected = false
        }
        
    }
    
//    @objc func tagButtonAction() {
//
//    }
    
    
    
}


extension ScriptCommentsViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }
    
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       if (text=="\n") {
           textView.resignFirstResponder()
           return false
       }
       return true
   }
}
