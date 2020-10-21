//
//  SetPasswordsViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/31.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class SetPasswordsViewController: UIViewController,UITextFieldDelegate {
    
    var titleString: String?
    
    var isResetPassword: Bool = false
    
    var email: String!
    
    var captcha: String!
        
    @IBOutlet weak var commonView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    // 输入密码视图
    @IBOutlet weak var oneView: UIView!
    // 输入密码输入框
    @IBOutlet weak var passwordTextField: UITextField!
    
    // 再次输入密码
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet weak var moreTextField: UITextField!
    
    // 确认密码
    @IBOutlet weak var confirmBtn: GradienButton!
    
    @IBOutlet weak var confiemBtnWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isResetPassword {
            titleString = "パスワードをレセット"
        } else {
            titleString = "暗証番号確認"
        }
        
        self.title = titleString
        setupNavigaitonBar()
        setUI()
    }



}


extension SetPasswordsViewController {
    private func setUI() {

        commonView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideFunc))
        commonView.addGestureRecognizer(tap)
        
        passwordTextField.delegate = self
        moreTextField.delegate = self

        
        
        
        passwordTextField.isSecureTextEntry = true
//        passwordTextField.keyboardType = .asciiCapable

        moreTextField.isSecureTextEntry = true
        moreTextField.keyboardType = .asciiCapable
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        
        moreTextField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        
       
        
        oneView.layer.cornerRadius = 25
        oneView.layer.borderWidth = 0.5
        oneView.layer.borderColor = HexColor("#CCCCCC").cgColor
        
        moreView.layer.cornerRadius = 25
        moreView.layer.borderWidth = 0.5
        moreView.layer.borderColor = HexColor("#CCCCCC").cgColor

        confiemBtnWidth.constant = (FULL_SCREEN_WIDTH - 37.5*2)
        confirmBtn.layoutIfNeeded()
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//        confirmBtn.gradientColor(start: "#3522f2", end: "#934BFE", cornerRadius: 25)
//        confirmBtn.layer.cornerRadius = 25
        
        confirmBtn.setOtherGradienButtonColor(start: "#CACACA", end: "#CACACA", cornerRadius: 25)
        confirmBtn.isUserInteractionEnabled = false
        
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
    }
    
    private func setupNavigaitonBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(leftBtnAction))
    }
}


extension SetPasswordsViewController {
    @objc func confirmBtnAction() {
        let password = passwordTextField.text!
        let more = moreTextField.text!
        
        if !password.isEmptyString && !more.isEmptyString {
            if isResetPassword { //重置密码
                findPassword(email: email, password: password, repassword: more, captcha: captcha) {[weak self] (result, error) in
                    if error != nil {
                        return
                    }
                    // 取到结果
                    guard  let resultDic :[String : AnyObject] = result else { return }
                    if resultDic["code"]!.isEqual(1) { // 重置密码成功
                        showToastCenter(msg: "パスワードがレセットされました", 25)

                        // 跳登录
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                    
                }
                
            } else { // 设置密码
                
                
                loadRegister(email: email, password: password, repassword: more, captcha: captcha) {[weak self] (result, error) in
                    if error != nil {
                        return
                    }
                    // 取到结果
                    guard  let resultDic :[String : AnyObject] = result else { return }
                    
                    if resultDic["code"]!.isEqual(1) {
                        let data = resultDic["data"] as! [String : AnyObject]
                        // 将字典转成模型对象
                        let account = UserAccount(fromDictionary: data)
                        // 将account对象保存
                        // 获取沙盒路径
                        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                        
                        accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
                        // 保存对象
                        NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
                        
                        // 将account对象设置到单例对象中
                        UserAccountViewModel.shareInstance.account = account
                        
                        // 跳完善信息
                        let vc = CompleteInfoViewController()
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
        } 
    }
    
    @objc func leftBtnAction() {
        navigationController?.popViewController(animated: true)
    }
}


extension SetPasswordsViewController {
    // 限制输入数字和字母
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ALPHANUM = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let cs = NSCharacterSet.init(charactersIn: ALPHANUM).inverted
        //按cs分离出数组,数组按@""分离出字符串
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return string.elementsEqual(filtered)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        
        if (passwordTextField.text?.count != 0 && moreTextField.text?.count != 0) {
            confirmBtn.setOtherGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
            confirmBtn.isUserInteractionEnabled = true

        } else {
            confirmBtn.setOtherGradienButtonColor(start: "#CACACA", end: "#CACACA", cornerRadius: 25)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordTextField.resignFirstResponder()
        moreTextField.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        passwordTextField.resignFirstResponder()
        moreTextField.resignFirstResponder()
    }
    
    @objc func hideFunc() {
        passwordTextField.resignFirstResponder()
        moreTextField.resignFirstResponder()
    }


    
}

extension SetPasswordsViewController {
    
}


