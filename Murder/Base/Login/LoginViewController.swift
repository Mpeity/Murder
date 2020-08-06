//
//  LoginViewController.swift
//  Murder
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import CLToast

let email = "123"
let password = "123"

class LoginViewController: UIViewController,UITextFieldDelegate {
    // 邮箱图片
    @IBOutlet weak var nameIcon: UIImageView!
    // 密码图片
    @IBOutlet weak var passwordIcon: UIImageView!
    // 邮箱
    @IBOutlet weak var nameTextField: UITextField!
    // 密码
    @IBOutlet weak var passwordTextField: UITextField!
    // 注册
    @IBOutlet weak var registerBtn: UIButton!
    // 登录
    @IBOutlet weak var loginBtn: UIButton!
    
    // 用户协议
    @IBOutlet weak var userAgreementLabel: UILabel!
    // 忘记密码
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    
    
    // MARK: - 注册按钮响应事件
    @IBAction func registerBtnAction(_ sender: Any) {
        Log("registerBtnAction")
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
        
        
    }
    // MARK: - 登录按钮响应事件
    @IBAction func loginBtnAction(_ sender: Any) {
        
        if nameTextField.text == email && passwordTextField.text == password {
//            self.navigationController?.pushViewController(GameplayViewController(), animated: true)
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            
        } else {
            CLToastManager.share.cornerRadius = 25
            CLToastManager.share.bgColor = HexColor(hex: "#000000", alpha: 0.6)
            CLToast.cl_show(msg: "パスワードが正しくありません")
            
        }
        
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }


}

// MARK: - setUI
extension LoginViewController {
    
    private func setUI() {
        
        nameTextField.textColor = HexColor(DarkGrayColor)
        nameTextField.font = UIFont.systemFont(ofSize: 15)
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        passwordTextField.textColor = HexColor(DarkGrayColor)
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)

        nameTextField.text = email
        passwordTextField.text = email
        
        // 注册
        registerBtn.title(for: .normal)
        registerBtn.titleColor(for: .normal)
        registerBtn.titleLabel?.text = "新規登録"
        registerBtn.titleLabel?.textColor = HexColor(MainColor)
        registerBtn.layer.cornerRadius = 25
        registerBtn.layer.borderColor = HexColor(MainColor).cgColor
        registerBtn.layer.borderWidth = 0.5

        
        // 登录
        loginBtn.setTitleColor(UIColor.white, for: .normal)
//        loginBtn.titleLabel?.text = "ログイン"
        loginBtn.gradientColor(start: "#3522f2", end: "#934BFE", cornerRadius: 25)
        
        userAgreementLabel.attributedText = getNSAttributedString(str: "利用規約」に同意してログインする", color: LightGrayColor)

        // 忘记密码
        forgetPasswordLabel.attributedText = getNSAttributedString(str: "パスワードを忘れた", color: LightGrayColor)
        forgetPasswordLabel.isUserInteractionEnabled = true
        let forgetPasswordTap = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordTapAction))
        forgetPasswordLabel.addGestureRecognizer(forgetPasswordTap)
        
    }
}


extension LoginViewController {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if nameTextField.text?.count != 0 {
            nameIcon.image = UIImage(named: "login_name_highlight")
        } else {
            nameIcon.image = UIImage(named: "login_name")
        }
        
        if passwordTextField.text?.count != 0 {
            passwordIcon.image = UIImage(named: "login_password_highlight")
        } else {
            passwordIcon.image = UIImage(named: "login_password")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}


extension LoginViewController {
    
    @objc private func forgetPasswordTapAction() {
        let vc = RegisterViewController()
        vc.isResetPassword = true
        vc.titleString = "新規登録"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}





