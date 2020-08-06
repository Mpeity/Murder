//
//  MyFriendsListViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let MyFriendsListCellId = "MyFriendsListCellId"

class MyFriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    private var myTableView: UITableView!
    
    var isShare: Bool = false
    
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    //
    private var rightBtn: UIButton = UIButton()
    
    private lazy var textInputView : InputTextView! = {
        let inputView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        inputView.delegate = self
        inputView.textFieldView.delegate = self
        inputView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        return inputView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        setNavigationBar()
        setUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
        



}


// MARK: - UI
extension MyFriendsListViewController {
    
    private func setNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
//        rightBtn.setImage(UIImage(named: "send_message_r_icon"), for: .normal)
//        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        
        if !isShare {
            let btn = UIButton()
            btn.setImage(UIImage(named: "message_addbuddy"), for: .normal)
            btn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
            let rightItem = UIBarButtonItem(customView: btn)
            navigationItem.rightBarButtonItem = rightItem
        }

        
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "私の友達"
        navigationItem.titleView = titleLabel
        
    }
    
    func setUI() {
        
        
        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 73
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "MyFriendsListCell", bundle: nil), forCellReuseIdentifier: MyFriendsListCellId)
    }
}

// MARK: - TableView Delegate
extension MyFriendsListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsListCellId, for: indexPath) as! MyFriendsListCell
        cell.selectionStyle = .none
        if indexPath.row%2 == 0 {
            cell.sexImgView.image = UIImage(named: "sex_man")
            cell.nicknameLabel.text = "ユミ"
        } else {
            cell.sexImgView.image = UIImage(named: "sex_woman")
            cell.nicknameLabel.text = "かのん"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isShare { // 分享 显示分享card
            let commonView = ShareScriptCard(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            self.view.addSubview(commonView)
            
        } else {
            let RecordDetailVC = RecordDetailViewController()
            self.navigationController?.pushViewController(RecordDetailVC, animated: true)
        }
        

    }

    
    
}

extension MyFriendsListViewController {
    
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnAction() {
//        let commonView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
//        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
//        UIApplication.shared.keyWindow?.addSubview(commonView)
////        self.view.addSubview(commonView)
                
        textInputView.textFieldView.becomeFirstResponder()
        UIApplication.shared.keyWindow?.addSubview(textInputView)
    }
}

extension MyFriendsListViewController: InputTextViewDelegate  {
    
    func commonBtnClick() {
        textInputView.removeFromSuperview()
//        let vc = ScriptDetailsViewController()
//        navigationController?.pushViewController(vc, animated: true)
        
        let commonView = ApplyFriendView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(commonView)
//        self.view.addSubview(commonView)
        
        
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
