//
//  RecordListViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let RecordListCellId = "RecordListCellId"

class RecordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 标题
     private var titleLabel: UILabel = UILabel()
     // 返回上一层按钮
     private var backBtn: UIButton = UIButton()

    private var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
    }
    
    
        



}


// MARK: - UI
extension RecordListViewController {
    
        private func setNavigationBar() {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            backBtn.setImage(UIImage(named: "back_black"), for: .normal)
            backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
            
            
            titleLabel.textColor = HexColor(DarkGrayColor)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.text = "開局記録"
            navigationItem.titleView = titleLabel
            
        }
    
    
    
    func setUI() {
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 127
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "RecordListViewCell", bundle: nil), forCellReuseIdentifier: RecordListCellId)
    }
}

// MARK: - TableView Delegate
extension RecordListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordListCellId, for: indexPath) as! RecordListViewCell
//        if cell == nil {
//            cell = ScriptTableViewCell(style: .default, reuseIdentifier: ScriptCellId);
//        }
//        cell.textLabel?.text = "123"
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let RecordDetailVC = RecordDetailViewController()
        self.navigationController?.pushViewController(RecordDetailVC, animated: true)
    }

    
    
}

extension RecordListViewController {
    //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
      }
}
