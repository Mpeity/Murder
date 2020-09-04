//
//  SettingViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let SettingListCellId = "SettingListCellId"

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!
    
    private var confirmBtn: UIButton = UIButton()
    // 开局记录 / 反馈 / 设置
    var dataArray: Array = ["バージョン","お問い合わせ","アプリをレビュー"]
    
    // 标题
     private var titleLabel: UILabel = UILabel()
     // 返回上一层按钮
     private var backBtn: UIButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setUI()
    }
    

}


// MARK: - UI
extension SettingViewController {
    
    
       private func setNavigationBar() {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            backBtn.setImage(UIImage(named: "back_black"), for: .normal)
            backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
            
            
            titleLabel.textColor = HexColor(DarkGrayColor)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.text = "設置"
            navigationItem.titleView = titleLabel
            
        }
    
    
    func setUI() {
        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 60
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "SettingListCell", bundle: nil), forCellReuseIdentifier: SettingListCellId)
    
        self.view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
//            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(FULL_SCREEN_WIDTH-30)
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview().offset(-10)
            }
        }
        confirmBtn.layoutIfNeeded()
        confirmBtn.setTitle("ログアウト", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        
        
        

    }
    
    
}

// MARK: - TableView Delegate
extension SettingViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingListCellId, for: indexPath) as! SettingListCell
        cell.selectionStyle = .none
        let item = dataArray[indexPath.row]
        cell.titleLabel.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
//            let recordVC = RecordListViewController()
//            self.navigationController?.pushViewController(recordVC, animated: true)
            let settingVC = AboutUsViewController()
            self.navigationController?.pushViewController(settingVC, animated: true)
            break
        case 1:
            let feedbackVC = FeedbackViewController()
            self.navigationController?.pushViewController(feedbackVC, animated: true)
            break
        case 2:
            break
        default:
            break
        }
    }

    
}

extension SettingViewController {
    
    @objc func confirmBtnAction() {
        UIApplication.shared.keyWindow?.rootViewController =  BaseNavigationViewController(rootViewController: LoginViewController())
        userLogout()
        AgoraRtmLogout()
    }
    

    
}

extension SettingViewController {
    //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
      }
}
