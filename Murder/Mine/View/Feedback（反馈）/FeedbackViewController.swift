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
    @IBOutlet weak var textView: UITextView!
    
    // 确认
    @IBOutlet weak var confirmBtn: UIButton!
    
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        confirmBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        
    }
}

extension FeedbackViewController {
    @objc func confirmBtnAction() {
        
    }
}

extension FeedbackViewController {
    //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
      }
}

