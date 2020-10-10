//
//  ThreadView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SVProgressHUD

let ThreadLeftCellId = "ThreadLeftCellId"
let ThreadRightCellId = "ThreadRightCellId"



class ThreadView: UIView {
    
    

    private lazy var leftTableView: UITableView = UITableView()
    private lazy var rightTableView: UITableView = UITableView()
    
    private var isLeftTableView : Bool = true
    
    
    private var selectIndexPath: IndexPath = IndexPath(row: 0, section: 0)

    
    private var clueList : [ClueListModel]? = [ClueListModel]()
    
    var room_id : Int?
    // 我的id
    var script_role_id : Int?
    
    var script_node_id : Int?
    
    var script_id: Int? {
        didSet {
            
        }
    }

        
    var gameUserClueList: [GameUserClueListModel]? {
        didSet {
            if gameUserClueList!.isEmpty {
                return
            }            
            leftTableView.reloadData()
//            let indexPath = IndexPath(row: 0, section: 0)
//            leftTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
//            let model = gameUserClueList![indexPath.row]
            
            let indexPath = selectIndexPath
            leftTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            let model = gameUserClueList![indexPath.row]
            
            clueList =  model.clueList
            rightTableView.reloadData()
        }
    }

        
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
            return gameUserClueList?.count ?? 0
        } else {
            return clueList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ThreadLeftCellId, for: indexPath) as! ThreadLeftCell
            cell.selectionStyle = .none

            let model = gameUserClueList![indexPath.row]
            cell.titleLabel.text = model.scriptPlaceName
            if model.isRead == 0 { // 未读
                cell.pointView.isHidden = false
            } else {
                cell.pointView.isHidden = true
            }
            if indexPath == selectIndexPath {
                cell.isSelected = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ThreadRightCellId, for: indexPath) as! ThreadRightCell
            cell.clueListModel = clueList![indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            
            selectIndexPath = indexPath
            
            let model = gameUserClueList![indexPath.row]
            clueList =  model.clueList
            rightTableView.reloadData()
        } else {
            
//            hideView()
            
            let itemModel = clueList![indexPath.row]
            let threadCardView = ThreadCardDetailView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            threadCardView.script_node_id = script_node_id
            threadCardView.script_id = script_id
            threadCardView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            threadCardView.room_id = room_id
            threadCardView.clueListModel = itemModel

            
            UIApplication.shared.keyWindow?.addSubview(threadCardView)
            
            
            
            let script_clue_id = itemModel.scriptClueId
            let mapData = ["user_id":UserAccountViewModel.shareInstance.account?.userId!,"type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":1,"script_role_id":script_role_id!,"script_clue_id":script_clue_id!,"game_status_type":"clue_is_read","key":(UserAccountViewModel.shareInstance.account?.key!)! as String] as [String : AnyObject]
            
            let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
            SingletonSocket.sharedInstance.socket.write(string: mapJson)

        }
    }
    
    
      
}


extension ThreadView {
    @objc func hideView() {
//        self.removeFromSuperview()
        self.isHidden = true
    }
    
    @objc func bottomBtnAction(button:UIButton) {
        button.isSelected = !button.isSelected
       
    }
    
}

extension ThreadView {
    

}

