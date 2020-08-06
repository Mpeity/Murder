//
//  HomeViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit


let HomeListViewCellId = "HomeListViewCellId"
let HomeListHeaderViewId = "HomeListHeaderViewId"


class HomeViewController: UIViewController,UITextFieldDelegate {
    
    private lazy var tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    private var tableHeaderView: HomeListHeaderView!
    
    private lazy var textInputView : InputTextView! = {
        let inputView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        inputView.delegate = self
        inputView.textFieldView.delegate = self
        inputView.titleLabel.text = "パスワードを入力"
        inputView.commonBtn.setTitle("確認", for: .normal)
        inputView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        return inputView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        setUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}



extension HomeViewController {
    private func setUI() {
        tableHeaderView = HomeListHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: STATUS_BAR_HEIGHT + 260))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeListViewCell", bundle: nil), forCellReuseIdentifier: HomeListViewCellId)
        tableView.register(HomeListTableHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeListHeaderViewId)
        
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 127
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-STATUS_BAR_HEIGHT)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        tableView.tableHeaderView = tableHeaderView
        
        
        
        
//        let headerView = UIView()
//        self.view.addSubview(headerView)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideView))
//        headerView.addGestureRecognizer(tap)
//        headerView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalTo(bgView.snp.top)
//
//        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeListViewCellId, for: indexPath) as! HomeListViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeListTableHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 60))
        header.titleLabel.text = "ホール"
        return header
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commonView = ListPopUpView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.enterBtnTapBlcok = {[weak self](param)->() in
            Log(param)
            if indexPath.row == 0 { // 有密码
                commonView.removeFromSuperview()
                
                self!.textInputView.textFieldView.becomeFirstResponder()
                UIApplication.shared.keyWindow?.addSubview(self!.textInputView)

                
            } else {
                commonView.removeFromSuperview()
                let vc = ScriptDetailsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        UIApplication.shared.keyWindow?.addSubview(commonView)

    }
    
}

extension HomeViewController: InputTextViewDelegate  {
    
    func commonBtnClick() {
        textInputView.removeFromSuperview()
        let vc = ScriptDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
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
