//
//  RecordListViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import MJRefresh

let RecordListCellId = "RecordListCellId"

class RecordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 标题
     private var titleLabel: UILabel = UILabel()
     // 返回上一层按钮
     private var backBtn: UIButton = UIButton()

    private var myTableView: UITableView!
    
    private var page_no = 1
    
    private var page_size = 15
    
    private var scriptLogModel: ScriptLogModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
//        loadRefresh()
        
    }
    


}

extension RecordListViewController {
    
    // 加载更多
    @objc func loadMore() {
        page_no += 1
        
    }
    // 刷新
    @objc func loadRefresh() {
        page_no = 1
        loadData()
    }
    
    func loadData() {
        scriptLogRequest(page_no: page_no, page_size: page_size) {[weak self] (result, error) in
            if error != nil {
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                
                let model = ScriptLogModel(fromDictionary: data)
                if model.list?.count ?? 0 < 15 { // 最后一页
                    self?.myTableView.mj_header.endRefreshing()
                    self?.myTableView.mj_footer.endRefreshing()
                }
                
                if self?.page_no == 1 {
                    self?.scriptLogModel = model
                } else {
                    self?.scriptLogModel?.list?.append(contentsOf: model.list!)
                }
                
                
                self?.myTableView.reloadData()
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
            } else {
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
            }
        }
    }
}
    




// MARK: - UI
extension RecordListViewController {
    
        private func setNavigationBar() {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            backBtn.setImage(UIImage(named: "back_black"), for: .normal)
            backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
            
            
            titleLabel.textColor = HexColor(DarkGrayColor)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            titleLabel.text = "公演履歴"
            navigationItem.titleView = titleLabel
            
        }
    
    
    
    func setUI() {
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 127
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "RecordListViewCell", bundle: nil), forCellReuseIdentifier: RecordListCellId)
        
        setupHeaderView()
        setupFooterView()
    }
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadRefresh))
        header?.backgroundColor = UIColor.white
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        // 设置tableview的header
        myTableView.mj_header = header
        
        // 进入刷新状态
        myTableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        myTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
    }
}

// MARK: - TableView Delegate
extension RecordListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptLogModel?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordListCellId, for: indexPath) as! RecordListViewCell
        cell.selectionStyle = .none
        let model = scriptLogModel?.list[indexPath.row]
        cell.itemModel = model
        cell.commonBtnTapClick = {[weak self] () in
            self?.gotoVC(model: model)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = scriptLogModel?.list[indexPath.row]
        gotoVC(model: model)
    }
}

extension RecordListViewController {
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }

    private func gotoVC(model: ScriptMineListModel?) {
        let recordDetailVC = RecordDetailViewController()
        recordDetailVC.room_id = model?.roomId
        self.navigationController?.pushViewController(recordDetailVC, animated: true)
    }
}
