//
//  MineViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let MineListCellId = "MineListCellId"

class MineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myTableView: UITableView!
    
    private var tableHeaderView : MineTableHeaderView = MineTableHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 190+STATUS_BAR_HEIGHT))
    
    // 开局记录 / 反馈 / 设置
    var dataArray: Array = [["imgName":"mine_aboutus","title":"公演履歴"],["imgName":"mine_ feedback","title":"投稿について"],["imgName":"mine_set","title":"設置"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
//        loadUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        loadUserInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - 数据请求
extension MineViewController {
    private func loadUserInfo() {
        mineInfoRequest {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["result"] as! [String : AnyObject]
                self?.tableHeaderView.mineModel = MineModel(fromDictionary: resultData)
                self?.myTableView.reloadData()
            } else {
                
            }
        }
    }
}


// MARK: - UI
extension MineViewController {
    func setUI() {
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: -STATUS_BAR_HEIGHT, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT+STATUS_BAR_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 60
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "MineListCell", bundle: nil), forCellReuseIdentifier: MineListCellId)
        myTableView.tableHeaderView = tableHeaderView
    }
}

// MARK: - TableView Delegate
extension MineViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineListCellId, for: indexPath) as! MineListCell
        cell.selectionStyle = .none
        let item = dataArray[indexPath.row]
        cell.titleLabel.text = item["title"]
        cell.imgView.image = UIImage(named: item["imgName"]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            let recordVC = RecordListViewController()
            self.navigationController?.pushViewController(recordVC, animated: true)
        case 1:
            let vc = ContributeWebViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            let settingVC = SettingViewController()
            self.navigationController?.pushViewController(settingVC, animated: true)
        default:
            break
        }
    }

    
}

