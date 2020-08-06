//
//  PopMenuView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let PopMenuViewCellId = "PopMenuViewCellId"


class PopMenuView: UIView {
    
    var imageName: String?
    var bgImgView: UIImageView!
    var cellRowHeight : CGFloat = 55
    var lineColor: UIColor = UIColor.white
    var contentTextColor : UIColor = UIColor.white
    var contentTextFont : CGFloat = 15
    var isHideImg: Bool = false
    
    var titleArray : Array<String> = Array() {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {
        bgImgView.image = UIImage(named: imageName ?? "")
    }
    

    
}

extension PopMenuView {
    private func setUI() {
        

//        let bgView = UIView()
//        bgView.backgroundColor = UIColor.white
//        self.addSubview(bgView)
//
//        bgView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//            if #available(iOS 11.0, *) {
//                make.height.equalTo(339)
//
//            } else {
//                make.height.equalTo(305)
//            }
//
//        }
//        bgView.layoutIfNeeded()
//        bgView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: 15)
        
        bgImgView = UIImageView()
        self.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }

                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PopMenuViewCell", bundle: nil), forCellReuseIdentifier: PopMenuViewCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = cellRowHeight
        tableView.backgroundColor = UIColor.clear
        bgImgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(155)
        }
    }
}


extension PopMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopMenuViewCellId, for: indexPath) as! PopMenuViewCell
        cell.contentLabel.textAlignment = .center
        cell.contentLabel.text = titleArray[indexPath.row]
        cell.contentLabel.backgroundColor = UIColor.clear
        cell.contentLabel.textColor = contentTextColor
        cell.backgroundColor = UIColor.clear
        cell.lineView.backgroundColor = lineColor
        if isHideImg {
             cell.imgView.isHidden = true
        } else {
             cell.imgView.isHidden = false
        }

        if indexPath.row == titleArray.count-1 {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false

        }
        cell.contentLabel.font = UIFont.systemFont(ofSize: contentTextFont)
        cell.selectionStyle = .none
        return cell
    }
    
    
}


extension PopMenuView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
}

