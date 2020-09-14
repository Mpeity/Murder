//
//  ScriptTableHeaderView.swift
//  Murder
//
//  Created by mac on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let ScriptTableHeaderCellId = "ScriptTableHeaderCell"


let count = 3

class ScriptTableHeaderView: UIView {
    
    var tagList: [ScriptTagModel]? {
        didSet {
            guard let tagList = tagList else {
                return
            }
            var arr = ["すべて"]
            for item in tagList {
                arr.append(item.name!)
            }
            themeData = arr
            myTableView.reloadData()
        }
    }
    
    private var themeData: [String]? 

    var myTableView: UITableView!

    
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
            let height = count * 35 + 20
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: Int(FULL_SCREEN_WIDTH), height: height), style: .plain)
            myTableView.delegate = self
            myTableView.dataSource = self
            myTableView.separatorStyle = .none
            myTableView.rowHeight = 35
            myTableView.register(ScriptTableHeaderCell.self, forCellReuseIdentifier: ScriptTableHeaderCellId)
        }

        self.addSubview(myTableView)
    }
}

// MARK: - TableView Delegate
extension ScriptTableHeaderView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScriptTableHeaderCellId, for: indexPath) as! ScriptTableHeaderCell
        
//        if cell == nil{
//            cell = ScriptTableHeaderCell(style: .default, reuseIdentifier: ScriptTableHeaderCellId)
//        }
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        if indexPath.row == 0 {
            cell.titleLabel.text = "人数"
            cell.dataArr = ["すべて","1人","2人","3人","4人","5人"]
            cell.tagString = "people_num"
        } else if indexPath.row == 1 {
            cell.titleLabel.text = "題材"
            if themeData != nil {
                cell.dataArr = themeData!
            } else {
                cell.dataArr = ["すべて"]
            }
//            cell.dataArr = ["すべて","現実","武侠","心霊","テロ","キャンパス"]
            cell.tagString = "tag_id"

        } else if indexPath.row == 2 {
            cell.dataArr = ["すべて","初心者","簡単","中等","困難"]
            cell.titleLabel.text = "難易度"
            cell.tagString = "difficult"

        } else {
            cell.dataArr = ["すべて","無料","有料"]
            cell.titleLabel.text = "料金"
            cell.tagString = "pay_type"
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
