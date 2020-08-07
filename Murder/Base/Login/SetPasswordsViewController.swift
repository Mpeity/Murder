//
//  SetPasswordsViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/31.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class SetPasswordsViewController: UIViewController {
    
    var titleString: String?
    
    var isResetPassword: Bool = false
    
    var email: String!
    
    var captcha: String!
        
    // 输入密码视图
    @IBOutlet weak var oneView: UIView!
    // 输入密码输入框
    @IBOutlet weak var passwordTextField: UITextField!
    
    // 再次输入密码
    @IBOutlet weak var moreView: UIView!
    
    @IBOutlet weak var moreTextField: UITextField!
    
    // 确认密码
    @IBOutlet weak var confirmBtn: UIButton!
    
    
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
        oneView.layer.cornerRadius = 25
        oneView.layer.borderWidth = 0.5
        oneView.layer.borderColor = HexColor("#CCCCCC").cgColor
        
        moreView.layer.cornerRadius = 25
        moreView.layer.borderWidth = 0.5
        moreView.layer.borderColor = HexColor("#CCCCCC").cgColor

        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirmBtn.gradientColor(start: "#3522f2", end: "#934BFE", cornerRadius: 25)
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
                    if resultDic["code"]!.isEqual(1) {
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
                        UserAccount.init(dic: data)
                        
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


extension SetPasswordsViewController:UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTextField.text?.count != 0 && moreTextField.text?.count != 0 {
            confirmBtn.backgroundColor = UIColor.lightGray
            confirmBtn.isHighlighted = true
            confirmBtn.isEnabled = false
        } else {
            confirmBtn.isHighlighted = false
            confirmBtn.isEnabled = true
        }

    }
    
    
}
