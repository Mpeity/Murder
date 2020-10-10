//
//  ApplyFriendsViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/30.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import MJRefresh


let ApplyFriendsListCellId = "ApplyFriendsListCellId"

class ApplyFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!
    
    var isShare: Bool = false
    
    private var page_no = 1
    
    private var page_size = 15
    
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    //
    private var rightBtn: UIButton = UIButton()
    
    private var friendApplyModel: FriendsApplyModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
    }
}

// MARK: - LoadData
extension ApplyFriendsViewController {
    
    @objc private func loadMore() {
        page_no += 1
        loadData()
    }
    
    @objc private func loadRefresh() {
        page_no = 1
        loadData()
    }
    
    func loadData() {
        friendApplyListRequest(page_no: page_no, page_size: page_size) {[weak self] (result, error) in
            if error != nil {
                self?.myTableView.mj_header?.endRefreshing()
                self?.myTableView.mj_footer?.endRefreshing()
                return
            }
            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                
                let model = FriendsApplyModel(fromDictionary: data)
                if model.list?.count ?? 0 < 15 { // 最后一页
                    self?.myTableView.mj_header?.endRefreshing()
                    self?.myTableView.mj_footer?.endRefreshing()
                }
                
                if self?.page_no == 1 {
                    self?.friendApplyModel = model
                } else {
                    self?.friendApplyModel?.list?.append(contentsOf: model.list!)
                }

//                if self?.scriptModel!.list != nil {
//                    if self?.messageModel!.list?.count == 0 {
//                        self?.defaultView.isHidden = false
//                    } else {
//                        self?.defaultView.isHidden = true
//                    }
//                } else {
//                    self?.defaultView.isHidden = false
//                }
//                self?.tableHeaderView.tagList = self?.scriptModel!.tagList!
                
                
                self?.myTableView.reloadData()
                self?.myTableView.mj_header?.endRefreshing()
                self?.myTableView.mj_footer?.endRefreshing()
            } else {
                self?.myTableView.mj_header?.endRefreshing()
                self?.myTableView.mj_footer?.endRefreshing()
            }
        }
    }
}


// MARK: - UI
extension ApplyFriendsViewController {
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadRefresh))
        header?.backgroundColor = UIColor.white
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        // 设置tableview的header
        myTableView.mj_header = header
        
        // 进入刷新状态
        myTableView.mj_header?.beginRefreshing()
    }
    
    private func setupFooterView() {
        myTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
    }
    
    private func setNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "友達申込"
        navigationItem.titleView = titleLabel
        
    }
    
    
    func setUI() {

        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 73
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "ApplyFriendsListCell", bundle: nil), forCellReuseIdentifier: ApplyFriendsListCellId)
        
        setupHeaderView()
        setupFooterView()
    }
}

// MARK: - TableView Delegate
extension ApplyFriendsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendApplyModel?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApplyFriendsListCellId, for: indexPath) as! ApplyFriendsListCell
        cell.selectionStyle = .none
        let model = friendApplyModel?.list[indexPath.row]
        cell.itemModel = model
        
        cell.passBtnTapBlcok = {[weak self] () in
            self!.passBtnTap(friend_apply_id: (model?.friendApplyId)!)
        }
        
        cell.refuseBtnTapBlcok = {[weak self] () in
            self!.refuseBtnTap(friend_apply_id: (model?.friendApplyId)!)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let RecordDetailVC = RecordDetailViewController()
//        self.navigationController?.pushViewController(RecordDetailVC, animated: true)
        
    }

    
    
}

extension ApplyFriendsViewController {
    
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnAction() {
        let commonView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(commonView)
//        self.view.addSubview(commonView)
    }
    
    //MARK: - 拒绝好友申请按钮
    @objc func refuseBtnTap(friend_apply_id: Int) {
        refuseApplyFriendRequest(friend_apply_id: friend_apply_id) {[weak self] (result, error) in
            if error != nil {
                return
            }
            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                self?.loadRefresh()
            }
        }
        
    }
    
    //MARK: - 通过好友申请按钮
    @objc func passBtnTap(friend_apply_id: Int) {
        
        passApplyFriendRequest(friend_apply_id: friend_apply_id) {[weak self] (result, error) in
            if error != nil {
                return
            }
            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                self?.loadRefresh()
            }
        }
    }
    
}

