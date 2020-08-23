//
//  RegisterViewController.swift
//  Murder
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import CLToast

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    var titleString: String? = "新規登録"
    
    var isResetPassword: Bool? = false
    

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
    
    // 倒计时
    var timer:Timer?
    var count: Int = 0
    // 获取验证码
    var getCode: Bool = true
    
    
    // 下一步
    @IBAction func nextBtnAction(_ sender: Any) {
        
        
//        let vc = SetPasswordsViewController()
//        vc.titleString = self.titleString
//        vc.captcha = self.codeTextField.text!
//        vc.isResetPassword = self.isResetPassword ?? false
//        self.navigationController?.pushViewController(vc, animated: true)
//        return
        
        var scene = 1
        // 重置密码
        if isResetPassword! {
            scene = 2
        }
        
        let email = nameTextField.text!
        let code = codeTextField.text!
    
        // 获取验证码
        if !email.isEmptyString && getCode  {
            // 获取验证码
            loadCaptcha(email: String(email), scene: String(scene)) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
            
                if resultDic["code"]!.isEqual(1) {
                    self?.nextBtnTopConstraint.constant = 100
                    self?.codeView.isHidden = false
                    self?.view.layoutIfNeeded()
                    //  倒计时开始
                    self?.timerFunc()
                    self?.getCode = false
                    
//                    showToastCenter(msg:"認証コードは発送済です")

                } else {
                    showToastCenter(msg: "メールアドレスのフォーマットが正しくありません、再度入力してくさい")
                }
            }
            
            
        }
        
        
        // 验证 验证码是否正确
        if !email.isEmptyString && !code.isEmptyString {
            checkCaptcha(email: String(email), scene: String(scene), captcha: String(code)) {[weak self] (result, error) in
            
                if error != nil {
                    return
                }
                               
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
                    let vc = SetPasswordsViewController()
                    vc.titleString = self?.titleString
                    vc.captcha = self?.codeTextField.text!
                    vc.email  = self?.nameTextField.text!
                    vc.isResetPassword = self!.isResetPassword ?? false
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        setupNavigaitonBar()
        setUI()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
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

//MARK:- 倒计时
extension RegisterViewController {
    
    private func timerFunc() {
        count = 300
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, block: {[weak self] (_) in
            self?.countDown()
        }, repeats: true)
    }
    
    private func countDown() {
        count -= 1
        if count == 0 {
            oneMoreBtn.isEnabled = true
            oneMoreBtn.setTitle("再一次", for: .normal)
            timer?.invalidate()
            timer = nil
        } else {
            oneMoreBtn.setTitle(String("\(count)s"), for: .normal)
            oneMoreBtn.isEnabled = false
        }
    }
}

