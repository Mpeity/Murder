//
//  PlacePopMenuView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let PlacePopMenuViewCellId = "PlacePopMenuViewCellId"

protocol PlacePopMenuViewDelegate {
    func cellDidSelected(index: Int, model: AnyObject?)
}


class PlacePopMenuView: UIView {
    
    var delegate : PlacePopMenuViewDelegate?
    
    var imageName: String?
    var bgImgView: UIImageView!
    var cellRowHeight : CGFloat = 55
    var lineColor: UIColor = UIColor.white
    var contentTextColor : UIColor = UIColor.white
    var contentTextFont : CGFloat = 15
    var isHideImg: Bool = false
    // 是否是旁观者 是 隐藏小红点
    var onLooker: Bool? = false
    
    var selectIndexPath: IndexPath = IndexPath(row: 0, section: 0)

    
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
                Log(selectIndexPath)
                tableView.selectRow(at: selectIndexPath, animated: true, scrollPosition: .bottom)
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

extension PlacePopMenuView{
    private func setUI() {
        
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
        tableView.register(UINib(nibName: "PlacePopMenuViewCell", bundle: nil), forCellReuseIdentifier: PlacePopMenuViewCellId)
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


extension PlacePopMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlacePopMenuViewCellId, for: indexPath) as! PlacePopMenuViewCell
        cell.contentLabel.textAlignment = .center
        let model = titleArray[indexPath.row] as! GPNodeMapListModel
        cell.contentLabel.text = model.name! as String
        
        if selectIndexPath == indexPath {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
       
        cell.contentLabel.backgroundColor = UIColor.clear
        cell.contentLabel.textColor = contentTextColor
        cell.backgroundColor = UIColor.clear
        cell.lineView.backgroundColor = lineColor
        
        // 不是旁观者 未读添加小红点
        if onLooker != true {
            if model.see == 0 {
                addPoint(placeStr: model.name!, commonView: cell.contentLabel)
            } else {
                hideRedPoint(commonView: cell.contentLabel)
            }
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
            self.isHidden = true
            let model = titleArray[indexPath.row] as! GPNodeMapListModel
            delegate?.cellDidSelected(index: indexPath.row, model: model)
        }
    }
    
    
}




extension PlacePopMenuView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
    
    
    private func addPoint(placeStr: String, commonView: UIView) {
        // 绘制地图小红点
        let placeStrWidth = placeStr.ga_widthForComment(fontSize: 10.0, height: 21)
        
        Log(placeStrWidth)
        Log((136-placeStrWidth)*0.5 + placeStrWidth)
        addRedPoint(commonView: commonView, x:(136-placeStrWidth)*0.5 + placeStrWidth+10 , y: 15)
    }
    
    /// 添加红点
    private func addRedPoint(commonView: UIView, x: CGFloat, y: CGFloat) {
        
        hideRedPoint(commonView: commonView)
        
        let point = UIView()
        point.tag = 12345
        commonView.addSubview(point)
        point.backgroundColor = HexColor("#ED2828")
        point.layer.cornerRadius = 3.5
        point.snp.makeConstraints { (make) in
            make.width.height.equalTo(7)
            make.left.equalToSuperview().offset(x)
            make.top.equalToSuperview().offset(y)
        }
    }
    
    private func hideRedPoint(commonView: UIView) {
        let point = commonView.viewWithTag(12345)
        if point != nil {
            point?.removeFromSuperview()
        }
    }
}

