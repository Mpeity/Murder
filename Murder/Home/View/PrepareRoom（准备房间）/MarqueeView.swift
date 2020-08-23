//
//  MarqueeView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/3.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let MarqueeViewCellId = "MarqueeViewCellId"

class MarqueeView: UIView {
    
    var iconImgView: UIImageView = UIImageView()
    
    var titleLabel: UILabel = UILabel()

    private var myTableView: UITableView!
    
    // 开局记录 / 反馈 / 设置
//    var dataArray: Array = ["バージョン","お問い合わせ","アプリをレビュー"]
    var dataArray = [[String: AnyObject]]()  {
        didSet {            
            if !dataArray.isEmpty {
                myTableView.reloadData()
                let indexPath = IndexPath(row: dataArray.count-1, section: 0)
                myTableView?.scrollToRow(at: indexPath, at:.bottom, animated: true)
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


// MARK: - UI
extension MarqueeView {
    func setUI() {
    
        self.addSubview(iconImgView)
        iconImgView.image = UIImage(named: "notif_icon")
        iconImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        
        self.addSubview(titleLabel)
        titleLabel.text = "システムメッセージ"
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textColor = HexColor("#FC3859")
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgView.snp_right).offset(5)
            make.top.equalToSuperview()
        }
        
        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 19, width: FULL_SCREEN_WIDTH-30, height: 58), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 17
        myTableView.backgroundColor = HexColor("#27025E")
        self.addSubview(myTableView)
        myTableView.register(UINib(nibName: "MarqueeViewCell", bundle: nil), forCellReuseIdentifier: MarqueeViewCellId)
    }
    
    
}

// MARK: - TableView Delegate
extension MarqueeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarqueeViewCellId, for: indexPath) as! MarqueeViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = HexColor("#27025E")

        let item = dataArray[indexPath.row]
        cell.nameLabel.text = item["name"] as? String
        cell.statusLabel.text = item["status"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
}
