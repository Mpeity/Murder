//
//  ApplyFriendsViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/30.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit


let ApplyFriendsListCellId = "ApplyFriendsListCellId"

class ApplyFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!
    
    var isShare: Bool = false
    
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    //
    private var rightBtn: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
    }
    
    
        



}


// MARK: - UI
extension ApplyFriendsViewController {
    
        private func setNavigationBar() {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            backBtn.setImage(UIImage(named: "back_black"), for: .normal)
            backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
            
            
            titleLabel.textColor = HexColor(DarkGrayColor)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.text = "友達申込"
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
        myTableView.register(UINib(nibName: "ApplyFriendsListCell", bundle: nil), forCellReuseIdentifier: ApplyFriendsListCellId)
    }
}

// MARK: - TableView Delegate
extension ApplyFriendsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApplyFriendsListCellId, for: indexPath) as! ApplyFriendsListCell
        cell.selectionStyle = .none
        if indexPath.row%2 == 0 {
            if indexPath.row == 0 {
                cell.refuseBtn.isHidden = false
                cell.passBtn.isHidden = false
                cell.statusLabel.isHidden = true
            }
            cell.sexImgView.image = UIImage(named: "sex_man")
            cell.nicknameLabel.text = "ユミ"
        } else {
            cell.sexImgView.image = UIImage(named: "sex_woman")
            cell.nicknameLabel.text = "かのん"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let RecordDetailVC = RecordDetailViewController()
        self.navigationController?.pushViewController(RecordDetailVC, animated: true)
    }

    
    
}

extension ApplyFriendsViewController {
    
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnAction() {
        let commonView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(commonView)
//        self.view.addSubview(commonView)
    }
}

