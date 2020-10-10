//
//  CreateRoomViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController {
    
    private lazy var textInputView : InputTextView! = {
        let inputView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        inputView.titleLabel.text = "暗証番号を設置"
        inputView.commonBtn.setTitle("確認", for: .normal)
        inputView.delegate = self
        inputView.textFieldView.delegate = self
        inputView.textFieldView.keyboardType = .numberPad
        inputView.textFieldView.placeholder = ""
        inputView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        return inputView
    }()

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // 封面
    @IBOutlet weak var coverImgView: UIImageView!
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setpwView: UIView!
    // 房间密码
    @IBOutlet weak var tipLabel: UILabel!
    // 密码
    @IBOutlet weak var passwordLabel: UILabel!
    
    // 创建房间按钮
    @IBOutlet weak var createBtn: UIButton!
    
    var titleLabel: UILabel = UILabel()
    
    var leftBtn: UIButton = UIButton()
    
    var script_id: Int = 0
    
    var cover: String! {
        didSet {
            guard cover != nil else {
                return
            }
//            coverImgView.setImageWith(URL(string: cover))
//            nameLabel.text = name
        }
    }
    var name: String!
    
    // 是否有密码
    var hasPassword = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension CreateRoomViewController {
    func createRoom(script_id: Int, hasPassword: Bool, room_password: String) {
        addRoomRequest(script_id: script_id, hasPassword: hasPassword, room_password: room_password) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {

                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["result"] as! [String : AnyObject]
                
                let room_id = (resultData["room_id"] as! NSString).intValue
                let vc = PrepareRoomViewController()
                vc.room_id = Int(room_id)
                vc.script_id = script_id
                self!.navigationController?.pushViewController(vc, animated: true)
            } else {
                
            }
        }
    }
}


extension CreateRoomViewController {
    func setUI() {
        
        topConstraint.constant = -STATUS_BAR_HEIGHT
        
        heightConstraint.constant = STATUS_BAR_HEIGHT + 287
        
        titleLabel.text = "ルームを作る"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
        leftBtn.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        setNavigationBar(superView: self.view, titleLabel: titleLabel, leftBtn: leftBtn, rightBtn: nil)
        
        coverImgView.layer.borderWidth = 2
        coverImgView.layer.borderColor = UIColor.white.cgColor
        coverImgView.layer.cornerRadius = 2
        if cover != nil {
            coverImgView.setImageWith(URL(string: cover))
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        if name != nil {
            nameLabel.text = name
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setPasswordTap))
        setpwView.addGestureRecognizer(tap)
        
        passwordLabel.textColor = HexColor(LightGrayColor)
        passwordLabel.font = UIFont.systemFont(ofSize: 14)
        
        createBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        createBtn.addTarget(self, action: #selector(createBtnAction), for: .touchUpInside)

    }
}


extension CreateRoomViewController {
    @objc func leftBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func createBtnAction() {
        createRoom(script_id: script_id, hasPassword: hasPassword, room_password: passwordLabel.text!)
//        let vc = PrepareRoomViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 设置密码
    @objc func setPasswordTap() {
        textInputView.textFieldView.text = nil
        textInputView.textFieldView.becomeFirstResponder()
        self.view.addSubview(textInputView)
    }
    
    
}

extension CreateRoomViewController: InputTextViewDelegate, UITextFieldDelegate  {
    
    func commonBtnClick() {
        textInputView.removeFromSuperview()
        
        if textInputView.textFieldView.text!.count < 4 {
            showToastCenter(msg: "４桁の暗証番号を記入してください")
            return
        }
        
        
        if textInputView.textFieldView.text == "" || textInputView.textFieldView.text == nil {
            passwordLabel.text = "なし"
            hasPassword = false
            
        } else {
            passwordLabel.text = textInputView.textFieldView.text
            hasPassword = true
        }
    }
    
    
    // 利用代理方法控制字符数量
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let text = textField.text else{
               return true
           }
           let textLength = text.count + string.count - range.length

           return textLength<=4
       }

    
    @objc func keyboardWillChangeFrame(notif: Notification) {
        // 获取动画执行的时间
        let duration = notif.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 获取键盘最终Y值
        let endFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 计算工具栏距离底部的间距
        let margin = FULL_SCREEN_HEIGHT - y - HOME_INDICATOR_HEIGHT
        
        // 执行动画
        textInputView.bottomConstraint.constant = margin
        UIView.animate(withDuration: duration) {
            self.textInputView.layoutIfNeeded()
        }
    }
}
