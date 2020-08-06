//
//  AnswerView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let VoteChoiceCellId = "VoteChoiceCellId"
class AnswerView: UIView {
    
    // 题目选项
    private lazy var tableView: UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AnswerView {
    private func setUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "VoteChoiceCell", bundle: nil), forCellReuseIdentifier: VoteChoiceCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(-.pi*0.5))
        tableView.rowHeight = 100
        tableView.backgroundColor = HexColor("#F5F5F5")
        tableView.center = CGPoint(x: tableView.frame.size.width / 2, y: tableView.frame.size.height / 2)
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(25)
            
        }

    }
}



extension AnswerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        let cell = tableView.dequeueReusableCell(withIdentifier: VoteChoiceCellId, for: indexPath) as! VoteChoiceCell
        cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(.pi*0.5))
        cell.selectionStyle = .none
        cell.backgroundColor = HexColor("#F5F5F5")
        cell.isSelected = false
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
      
}

