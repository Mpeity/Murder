//
//  FeedbackViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    // 邮箱输入
    @IBOutlet weak var textFieldView: UITextField!
    // 文字输入
    @IBOutlet weak var textView: EWTextView!
    
    // 确认
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var confirmWidth: NSLayoutConstraint!
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        setUI()

        // Do any additional setup after loading the view.
    }
}

extension FeedbackViewController {
    
    private func setNavigationBar() {
      navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
      backBtn.setImage(UIImage(named: "back_black"), for: .normal)
      backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
      
      
      titleLabel.textColor = HexColor(DarkGrayColor)
      titleLabel.textAlignment = .center
      titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
      titleLabel.text = "お問い合わせ"
      navigationItem.titleView = titleLabel
    }
    
    private func setUI() {
        confirmBtn.setTitle("確認", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        
        confirmWidth.constant = FULL_SCREEN_WIDTH - 30
        
        confirmBtn.layoutIfNeeded()
        confirmBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        
        
        textView.placeHolder = "お問い合わせ内容を入力"
//        textView.placeHolder
//        textView.placeHolderColor = HexColor(LightGrayColor)
        textView.font = UIFont.systemFont(ofSize: 12)
    }
}

extension FeedbackViewController {
    @objc func confirmBtnAction() {
        let email = textFieldView.text!
        let content = textView.text!
        feedbackRequest(email: email, content: content) { (result, error) in
            
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                showToastCenter(msg: "提出完了")
            } else {
                showToastCenter(msg: "提出失敗しました、再度試してください")
            }
        }
    }
}

extension FeedbackViewController {
    //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
      }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFieldView.resignFirstResponder()
        textView.resignFirstResponder()
    }
}

