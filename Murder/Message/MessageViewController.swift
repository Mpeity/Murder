//
//  MessageViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let MessageListCellId = "MessageListCellId"

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "トーク"
        setUI()
    }
    
    
        



}


// MARK: - UI
extension MessageViewController {
    
    func setUI() {
        
        let btn = UIButton()
        btn.setTitle("私の友達", for: .normal)
        btn.setTitleColor(HexColor(DarkGrayColor), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: btn)
        navigationItem.rightBarButtonItem = rightItem
        
        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 73
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "MessageListCell", bundle: nil), forCellReuseIdentifier: MessageListCellId)
    }
}

// MARK: - TableView Delegate
extension MessageViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageListCellId, for: indexPath) as! MessageListCell
        cell.avatarImgTapBlcok = {() in
//            let commonView = LookFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
//            commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
//            UIApplication.shared.keyWindow?.addSubview(commonView)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0  {
            let vc = ApplyFriendsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = SendMessageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension MessageViewController {
    @objc func rightBtnAction() {
        let vc = MyFriendsListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
