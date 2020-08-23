//
//  VoteResultView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let VoteResultViewCellId = "VoteResultViewCellId"

class VoteResultView: UIView {
    
    var room_id: Int? {
        didSet {
            if room_id != nil {
                loadData()
            }
        }
    }
    
    // 题目选项
    private lazy var tableView: UITableView = UITableView()
    
    private var gameVoteResultModel: GameVoteResultModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension VoteResultView {
    
    private func loadData() {

        gameVoteResultRequest(room_id: room_id!) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                self!.gameVoteResultModel = GameVoteResultModel(fromDictionary: data)
                self!.tableView.reloadData()
            }
        }
    }
    
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
        label.text = "投票結果"
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
        tableView.register(UINib(nibName: "VoteResultViewCell", bundle: nil), forCellReuseIdentifier: VoteResultViewCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 255
        tableView.backgroundColor = HexColor("#F5F5F5")
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(0)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
        }
        
    }
}


extension VoteResultView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gameVoteResultModel?.list!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VoteResultViewCellId, for: indexPath) as! VoteResultViewCell
        cell.backgroundColor = HexColor("#F5F5F5")
        cell.selectionStyle = .none
//        if indexPath.row == 0 {
//            cell.isSelected = true
//        }
        let model = gameVoteResultModel?.list![indexPath.row]
        cell.resultListModel = model
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    
      
}


extension VoteResultView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
    
    @objc func bottomBtnAction(button:UIButton) {
        button.isSelected = !button.isSelected
       
    }
    
    
    
}

extension VoteResultView {
    

}


