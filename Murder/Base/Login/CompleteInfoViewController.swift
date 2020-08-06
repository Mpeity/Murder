//
//  CompleteInfoViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class CompleteInfoViewController: UIViewController, UITextFieldDelegate {

    // 头像按钮
    @IBOutlet weak var photoBtn: UIButton!
    
    // tip
    @IBOutlet weak var tipLabel: UILabel!
    
    // 女子
    @IBOutlet weak var womanBtn: UIButton!
    
    // 男子
    @IBOutlet weak var manBtn: UIButton!
    // 昵称视图
    @IBOutlet weak var nicknameView: UIView!
    // 昵称输入
    @IBOutlet weak var nicknameTextfield: UITextField!
    // 立即体验
    @IBOutlet weak var commonBtn: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "情報を充実させる"
        setupNavigaitonBar()
        setUI()

        
    }



}


extension CompleteInfoViewController {
    
    private func setUI() {
        photoBtn.addTarget(self, action: #selector(photoBtnAction), for: .touchUpInside)
        
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textColor = HexColor(LightGrayColor)
        
        womanBtn.createButton(style: .left, spacing: 23, imageName: "logo_woman", title: "女の子", cornerRadius: 25, color: "#FFFFFF")
        womanBtn.layer.borderColor = HexColor("#CACACA").cgColor
        womanBtn.layer.borderWidth = 0.5
        womanBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        womanBtn.addTarget(self, action: #selector(womanBtnAction), for: .touchUpInside)
        
        manBtn.createButton(style: .left, spacing: 10, imageName: "logo_man", title: "男の子", cornerRadius: 25, color: "#FFFFFF")
        manBtn.layer.borderColor = HexColor("#CACACA").cgColor
        manBtn.layer.borderWidth = 0.5
        manBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        manBtn.addTarget(self, action: #selector(manBtnAction), for: .touchUpInside)
//        imageWithRenderingMode;:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal
        
        nicknameView.layer.cornerRadius = 25
        nicknameView.layer.borderWidth = 0.5
        nicknameView.layer.borderColor = HexColor("#CCCCCC").cgColor
        nicknameTextfield.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)

        commonBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.setTitle("スタット", for: .normal)
        commonBtn.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)
        
    }
    
    private func setupNavigaitonBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(leftBtnAction))
    }
}

extension CompleteInfoViewController {
    @objc func leftBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 头像选择
    @objc func photoBtnAction() {
        // 选择照片
    }
    
    //MARK:- 女 womanBtn
    @objc func womanBtnAction() {
        womanBtn.setTitleColor(HexColor(MainColor), for: .normal)
        manBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        womanBtn.layer.borderColor = HexColor(MainColor).cgColor
        manBtn.layer.borderColor = HexColor("#CACACA").cgColor
        womanBtn.setImage(UIImage(named: "logo_woman_selected"), for: .normal)
        manBtn.setImage(UIImage(named: "logo_man"), for: .normal)

        
    }
    
    //MARK:- 男manBtn
    @objc func manBtnAction() {
        womanBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        womanBtn.layer.borderColor = HexColor("#CACACA").cgColor
        womanBtn.setImage(UIImage(named: "logo_woman"), for: .normal)

        manBtn.setTitleColor(HexColor(MainColor), for: .normal)
        manBtn.layer.borderColor = HexColor(MainColor).cgColor
        manBtn.setImage(UIImage(named: "logo_man_selected"), for: .normal)
    }
    
    //MARK:- 完善信息
    @objc func commonBtnAction() {
        UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    
    
    
}


extension CompleteInfoViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if nicknameTextfield.text?.count != 0 {
            nicknameTextfield.textColor = HexColor(MainColor)
            nicknameView.layer.borderColor = HexColor(MainColor).cgColor

        } else {
            nicknameView.layer.borderColor = HexColor("#CCCCCC").cgColor
        }
    }
}
