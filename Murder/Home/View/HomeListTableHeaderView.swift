//
//  HomeListTableHeaderView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class HomeListTableHeaderView: UITableViewHeaderFooterView {
    
    public lazy var titleLabel:UILabel = UILabel()
    
    var font: CGFloat? {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: font!, weight: .bold)
        }
        
        
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.backgroundView = bgView
        bgView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
        }
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(60)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = HexColor(MainColor)
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(5)
            make.left.equalTo(15)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
