//
//  ScriptTableHeaderView.swift
//  Murder
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let ScriptTableHeaderCellId = "ScriptTableHeaderCell"

class ScriptTableHeaderView: UIView {
    
    private var myTableView: UITableView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI
extension ScriptTableHeaderView {
    func setUI() {
        
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = HexColor(hex: "#E1E1E1", alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 5;
        
        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 125), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 35
        self.addSubview(myTableView)
        myTableView.register(ScriptTableHeaderCell.self, forCellReuseIdentifier: ScriptTableHeaderCellId)
    }
}

// MARK: - TableView Delegate
extension ScriptTableHeaderView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ScriptTableHeaderCellId, for: indexPath) as! ScriptTableHeaderCell
        if cell == nil{
            cell = ScriptTableHeaderCell(style: .default, reuseIdentifier: ScriptTableHeaderCellId)
        }
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.titleLabel.text = "人数"
            cell.dataArr = ["1人","2人","3人","4人","5人"]
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "題材"
            cell.dataArr = ["現実","武侠","心霊","テロ","キャンパス"]
        } else {
            cell.dataArr = ["初心者","簡単","中等","困難"]
            cell.titleLabel.text = "難易度"
        }
        return cell
    }

    
}
