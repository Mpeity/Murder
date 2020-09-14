//
//  ScriptViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import MJRefresh

let ScriptCellId = "ScriptCellId"

private let Page_Size = 15

class ScriptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!
    
    private var tableHeaderView = ScriptTableHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 3 * 35 + 20))
    
    private var defaultView: UIView = UIView()
    
    private var scriptModel: ScriptModel?
    
    private var page_no = 1
    
    private var people_num = -1
    
    private var difficult = -1
    
    private var tag_id = -1
        
    private var pay_type = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(loadChange(notif:)), name: NSNotification.Name(rawValue: Script_Change_Notif), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "シナリオ"
        setUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: - 数据请求
extension ScriptViewController {
    
    @objc private func loadChange(notif:Notification) {
        
        let obj = notif.object as! [String : AnyObject]
        
        let tagString = obj["tagString"] as! String
        let tag = obj["tag"] as! Int + 1
        
        switch tagString {
            // 人数
        case "people_num":
            people_num = tag
            break
            // 题材
        case "tag_id":
            tag_id = tag
            break
            // 难度
        case "difficult":
            difficult = tag
            // 付费方式
            break
        case "pay_type":
            pay_type = tag
            break
        default:
            break
        }
//        loadScriptList()
        loadRefresh()
    }
    
    @objc private func loadMore() {
        page_no += 1
        loadScriptList()
    }
    
    @objc private func loadRefresh() {
        page_no = 1
        loadScriptList()
    }
    
    private func loadScriptList() {
        scriptListRequest(page_no: page_no, page_size: Page_Size, people_num: people_num, tag_id: tag_id, difficult: difficult, pay_type: pay_type) {[weak self] (result, error) in
            
            if error != nil {
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
                return
            }
            

            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                
                let model = ScriptModel(fromDictionary: data)

                
                if self?.page_no == 1 {
                    self?.scriptModel = model
                } else {
                    self?.scriptModel?.list?.append(contentsOf: model.list!)
                }
                
                if self?.scriptModel!.list != nil {
                    if self?.scriptModel!.list?.count == 0 {
                        self?.defaultView.isHidden = false
                    } else {
                        self?.defaultView.isHidden = true
                    }
                } else {
                    self?.defaultView.isHidden = false
                }
                self?.tableHeaderView.tagList = self?.scriptModel!.tagList!
                
                self?.myTableView.reloadData()
    
                
                if model.list?.count ?? 0 < 15 { // 最后一页
                    //如果提醒他没有更多的数据了
                    self?.myTableView.mj_header.endRefreshing()
                    self?.myTableView.mj_footer.endRefreshing()
                    self?.myTableView.mj_footer.endRefreshingWithNoMoreData()
                    return
                    
                }
                
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
extension ScriptViewController {
    
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
//        myTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
//        //如果提醒他没有更多的数据了
//        myTableView.mj_footer.endRefreshingWithNoMoreData()
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        footer?.setTitle("", for: .idle)
        footer?.setTitle("加载中...", for: .refreshing)
        footer?.setTitle("~ 以上です ~", for: .noMoreData)
        footer?.stateLabel.font = UIFont.systemFont(ofSize: 12)
        footer?.stateLabel.textColor = HexColor("#999999")
        myTableView.mj_footer = footer
    }
    
    func setUI() {
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), style: .plain)
            myTableView.delegate = self
            myTableView.dataSource = self
            myTableView.separatorStyle = .none
            myTableView.rowHeight = 127
            myTableView.register(UINib(nibName: "ScriptTableViewCell", bundle: nil), forCellReuseIdentifier: ScriptCellId)
            myTableView.tableHeaderView = tableHeaderView
        }
        self.view.addSubview(myTableView)
        setupHeaderView()
        setupFooterView()
        
        
        myTableView.addSubview(defaultView)
        defaultView.backgroundColor = UIColor.white
        defaultView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(160)
            make.left.equalTo(0)
            make.width.equalTo(FULL_SCREEN_WIDTH)
            make.bottom.equalToSuperview()
        }
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "script_default_img")        
        defaultView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(95)
            make.top.equalToSuperview().offset(122)
            make.centerX.equalToSuperview()
        }
        
        let tipLabel = UILabel()
        tipLabel.text = "該当シナリオは見つかりませんでした"
        tipLabel.textAlignment = .center
        tipLabel.textColor = HexColor("#CACACA")
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        defaultView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp_bottom).offset(30)
            make.width.equalToSuperview()
        }
        
        defaultView.isHidden = true
    }
}

// MARK: - TableView Delegate
extension ScriptViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptModel?.list!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScriptCellId, for: indexPath) as! ScriptTableViewCell
//        if cell == nil {
//            cell = ScriptTableViewCell(style: .default, reuseIdentifier: ScriptCellId);
//        }
        cell.selectionStyle = .none
        
        cell.scriptListModel = scriptModel?.list![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = scriptModel?.list?[indexPath.row]
        let vc = ScriptDetailsViewController()
        vc.script_id = model?.scriptId
        vc.user_script_text = model?.userScriptText
        navigationController?.pushViewController(vc, animated: true)
    }

    
}

