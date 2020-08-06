//
//  VoteCommonView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let VoteCommonCellId = "VoteCommonCellId"

class VoteCommonView: UIView {
    
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

extension VoteCommonView {
    private func setUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "VotePlayerCell", bundle: nil), forCellReuseIdentifier: VoteCommonCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(-.pi*0.5))
        tableView.rowHeight = 65
        tableView.backgroundColor = HexColor("#F5F5F5")
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
           make.top.equalToSuperview()
           make.left.equalToSuperview()
           make.width.equalToSuperview()
           make.bottom.equalToSuperview()
        }

    }
}



extension VoteCommonView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        let cell = tableView.dequeueReusableCell(withIdentifier: VoteCommonCellId, for: indexPath) as! VotePlayerCell
        cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(.pi*0.5))
        cell.selectionStyle = .none
        cell.backgroundColor = HexColor("#F5F5F5")
        cell.isSelected = false
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
      
}
