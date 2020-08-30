//
//  PopMenuView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let PopMenuViewCellId = "PopMenuViewCellId"

protocol PopMenuViewDelegate {
    func cellDidSelected(index: Int, model: AnyObject?)
}


class PopMenuView: UIView {
    // type   place-地点背景图片  script-剧本
    
    
    var delegate : PopMenuViewDelegate?
    
    var type : String? = "script"
    var imageName: String?
    var bgImgView: UIImageView!
    var cellRowHeight : CGFloat = 55
    var lineColor: UIColor = UIColor.white
    var contentTextColor : UIColor = UIColor.white
    var contentTextFont : CGFloat = 15
    var isHideImg: Bool = false
    
    var titleArray = [AnyObject]() {
        didSet {
            if !titleArray.isEmpty {
                let count = titleArray.count
                tableView.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().offset(5)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(count*55)
                }
                tableView.reloadData()
            }
            
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
        bgImgView.isUserInteractionEnabled = true
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
            make.height.equalTo(55)
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
        
        if type == "place" {
            let model = titleArray[indexPath.row] as! GPNodeMapListModel
            cell.contentLabel.text = model.name! as String
            if model.see == 0 {
                cell.point.isHidden = false
            } else {
                cell.point.isHidden = true
            }
        }
        
        if type == "script" {
            let model = titleArray[indexPath.row] as! GPChapterModel
            // 是否查看【1是0否】
            if model.see == 0 {
                cell.point.isHidden = false
            } else {
                cell.point.isHidden = true
            }
            cell.contentLabel.text = model.name! as String
        }
        
        if type == "truth" {
            let model = titleArray[indexPath.row] as! ScriptLogChapterModel
            // 是否查看【1是0否】
            cell.contentLabel.text = model.name! as String
        }
        
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            switch type! {
            case "place":
                let model = titleArray[indexPath.row] as! GPNodeMapListModel
                delegate?.cellDidSelected(index: indexPath.row, model: model)

                
            case "script":
                let model = titleArray[indexPath.row]
                delegate?.cellDidSelected(index: indexPath.row, model: model)
            default:
                break
            }
        }
    }
    
    
}




extension PopMenuView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
}

