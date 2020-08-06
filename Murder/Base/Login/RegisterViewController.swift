//
//  RegisterViewController.swift
//  Murder
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    var titleString: String?
    var isResetPassword: Bool?
    

    // 邮箱图片
    @IBOutlet weak var iconImgView: UIImageView!
    // 邮箱视图
    @IBOutlet weak var nameView: UIView!
    // 邮箱输入
    @IBOutlet weak var nameTextField: UITextField!
    
    
    // 验证码视图
    @IBOutlet weak var codeView: UIView!
    // 验证码图片
    @IBOutlet weak var codeImgView: UIImageView!
    // 验证码输入
    @IBOutlet weak var codeTextField: UITextField!
    // 再发一次
    @IBOutlet weak var oneMoreBtn: UIButton!
    
    
    
    // 下一步
    @IBOutlet weak var nextBtn: UIButton!
    // 
    @IBOutlet weak var nextBtnTopConstraint: NSLayoutConstraint!
    // 提示
    @IBOutlet weak var tipLabel: UILabel!
    
    
    // 下一步
    @IBAction func nextBtnAction(_ sender: Any) {
        if nameTextField.text == email {
            nextBtnTopConstraint.constant = 100
            codeView.isHidden = false
            self.view.layoutIfNeeded()

            //  倒计时开始
        }
        
        
        if nameTextField.text == email && codeTextField.text == email {
            let vc = SetPasswordsViewController()
            vc.titleString = titleString
            vc.isResetPassword = isResetPassword ?? false
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新規登録"
        setupNavigaitonBar()
        setUI()
    }

    



}

extension RegisterViewController {
    private func setUI() {
        nameView.layer.cornerRadius = 25
        nameView.layer.borderWidth = 0.5
        nameView.layer.borderColor = HexColor("#CCCCCC").cgColor
        nameTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        

        
        codeView.layer.cornerRadius = 25
        codeView.layer.borderWidth = 0.5
        codeView.layer.borderColor = HexColor("#CCCCCC").cgColor
        codeTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        codeView.isHidden = true
        oneMoreBtn.setTitleColor(HexColor("#FE2126"), for: .normal)
        
        nextBtnTopConstraint.constant = 25
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.gradientColor(start: "#3522F2", end: "934BFE", cornerRadius: 25)
        tipLabel.attributedText = getNSAttributedString(str: "利用規約」に同意してログインする 拷贝", color: LightGrayColor)
        
    }
    
    private func setupNavigaitonBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(leftBtnAction))
    }
}

extension RegisterViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if nameTextField.text?.count != 0 {
            iconImgView.image = UIImage(named: "login_name_highlight")
        } else {
            iconImgView.image = UIImage(named: "login_name")
        }
        
        if codeTextField.text?.count != 0 {
            codeImgView.image = UIImage(named: "login_password_highlight")
        } else {
            codeImgView.image = UIImage(named: "login_password")
        }
    }
    
    
    @objc func leftBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    

    
    
    
}
