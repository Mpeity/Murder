//
//  SendMessageViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/29.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let MessageTextCellId = "MessageTextCellId"

class SendMessageViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private lazy var tableView: UITableView = UITableView()

    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    // 
    private var rightBtn: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}


extension SendMessageViewController {
    
    private func setUI() {
        setNavigationBar()
        
        inputTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageTextCell", bundle: nil), forCellReuseIdentifier: MessageTextCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.backgroundColor = HexColor("F5F5F5")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(FULL_SCREEN_WIDTH)
            make.bottom.equalTo(bottomView.snp_top)
        }
    }
    
    
    private func setNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        rightBtn.setImage(UIImage(named: "send_message_r_icon"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "ユミ"
        navigationItem.titleView = titleLabel
        
    }
}

extension SendMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: MessageTextCellId, for: indexPath) as! MessageTextCell
//        if cell == nil {
//            cell = MessageTextCell(style: .default, reuseIdentifier: MessageTextCellId)
//        }
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none

        if indexPath.row < 6 {
//            cell.isLeft = true
            cell.rightView.isHidden = true
            cell.leftView.isHidden = false
            cell.leftTextLabel.text = "こんにちは"
        } else {
//            cell.isLeft = false
            cell.rightView.isHidden = false
            cell.leftView.isHidden = true
            cell.rightTextLabel.text = "こんにちはこんにちはこんにちは"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}


extension SendMessageViewController {
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - 右侧按钮
    @objc func rightBtnAction() {
        
        let commonView = LookFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
}

extension SendMessageViewController: UITextFieldDelegate {
    @objc func keyboardWillChangeFrame(notif: Notification) {
        // 获取动画执行的时间
        let duration = notif.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 获取键盘最终Y值
        let endFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 计算工具栏距离底部的间距
        var margin = FULL_SCREEN_HEIGHT - y - HOME_INDICATOR_HEIGHT
        
        if margin < 0 {
            margin = 0
        }
        
        // 执行动画
        bottomConstraint.constant = margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputTextField.resignFirstResponder()
    }
}
