//
//  ThreadView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let ThreadLeftCellId = "ThreadLeftCellId"
let ThreadRightCellId = "ThreadRightCellId"


class ThreadView: UIView {

    private lazy var leftTableView: UITableView = UITableView()
    private lazy var rightTableView: UITableView = UITableView()
    
    private var isLeftTableView : Bool = true

        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension ThreadView {
    private func setUI() {
        

        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            if #available(iOS 11.0, *) {
                let height = 537 + 34
                make.height.equalTo(height)
            } else {
                make.height.equalTo(537)
            }
           
        }
        bgView.layoutIfNeeded()
        bgView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: 15)
        
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        bgView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.height.equalTo(45)
            make.top.equalToSuperview()
        }
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label.text = "手掛かり"
        label.textColor = HexColor("#333333")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let cancelBtn = UIButton()
        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        cancelBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "cancel_readscript"), for: .normal)
        
        

        
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.register(UINib(nibName: "ThreadLeftCell", bundle: nil), forCellReuseIdentifier: ThreadLeftCellId)
        // 隐藏cell系统分割线
        leftTableView.separatorStyle = .none;
        leftTableView.rowHeight = 50
        leftTableView.backgroundColor = UIColor.white
        bgView.addSubview(leftTableView)
        leftTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(492)
        }
        
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.register(UINib(nibName: "ThreadRightCell", bundle: nil), forCellReuseIdentifier: ThreadRightCellId)
        // 隐藏cell系统分割线
        rightTableView.separatorStyle = .none;
        rightTableView.rowHeight = 100
        rightTableView.backgroundColor = HexColor("#F5F5F5")
        bgView.addSubview(rightTableView)
        rightTableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.left.equalTo(leftTableView.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(492)
        }
        
    }
}


extension ThreadView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == leftTableView {
            return 5
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ThreadLeftCellId, for: indexPath) as! ThreadLeftCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.isSelected = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ThreadRightCellId, for: indexPath) as! ThreadRightCell
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            
                   
        } else {
            
            hideView()
                        
            let threadCardView = ThreadCardView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            threadCardView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            UIApplication.shared.keyWindow?.addSubview(threadCardView)

        }
    }
    
    
      
}


extension ThreadView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
    
    @objc func bottomBtnAction(button:UIButton) {
        button.isSelected = !button.isSelected
       
    }
    
    
    
}

extension ThreadView {
    

}

