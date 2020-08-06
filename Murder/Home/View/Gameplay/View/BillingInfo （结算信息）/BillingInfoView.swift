//
//  BillingInfoView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let BillingInfoCellId = "BillingInfoCellId"

class BillingInfoView: UIView {

    private lazy var tableView: UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension BillingInfoView {
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
        label.text = "決算情報"
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
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BillingInfoViewCell", bundle: nil), forCellReuseIdentifier: BillingInfoCellId)
        
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 100
        tableView.backgroundColor = HexColor("#F5F5F5")
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(537)
        }
    }
}


extension BillingInfoView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BillingInfoCellId, for: indexPath) as! BillingInfoViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = HexColor("#F5F5F5")
        if indexPath.row <= 2 {
            cell.iconLabel.isHidden = true
            cell.iconImgView.isHidden = false
            switch indexPath.row {
            case 0:
                cell.iconImgView.image = UIImage(named: "jinpai")
                break
            case 1:
                cell.iconImgView.image = UIImage(named: "yinpai")
                break

            case 2:
                cell.iconImgView.image = UIImage(named: "tongpai")
                break
                
            default:
                break
            }

        } else {
            cell.iconImgView.isHidden = true
            cell.iconLabel.text = String(indexPath.row+1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    
}


extension BillingInfoView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
    
    
    
    
}

extension BillingInfoView {
    
}


