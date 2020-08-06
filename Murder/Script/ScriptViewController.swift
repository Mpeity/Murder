//
//  ScriptViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let ScriptCellId = "ScriptCellId"

class ScriptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "シナリオ"
        setUI()
    }
    
    
        



}


// MARK: - UI
extension ScriptViewController {
    func setUI() {
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 127
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "ScriptTableViewCell", bundle: nil), forCellReuseIdentifier: ScriptCellId)
        myTableView.tableHeaderView = ScriptTableHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 125))
    }
}

// MARK: - TableView Delegate
extension ScriptViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScriptCellId, for: indexPath) as! ScriptTableViewCell
//        if cell == nil {
//            cell = ScriptTableViewCell(style: .default, reuseIdentifier: ScriptCellId);
//        }
        cell.textLabel?.text = "123"
        return cell
    }

    
}
