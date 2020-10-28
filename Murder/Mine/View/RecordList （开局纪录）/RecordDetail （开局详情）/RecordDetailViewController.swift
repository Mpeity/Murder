//
//  RecordDetailViewController.swift
//  Murder
//
//  Created by mac on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit


let RecordDetailCellId = "RecordDetailCellId"

class RecordDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var room_id : Int?
    
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    // 分享按钮
    private var shareBtn: UIButton = UIButton()

    private var myTableView: UITableView!
    private var tableHeaderView: RecordDetailHeaderView = RecordDetailHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 190+STATUS_BAR_HEIGHT))
    // 评价剧本
    private var evaluateBtn: UIButton = UIButton()
    // 查看真相
    private var truthBtn: UIButton = UIButton()
    
    private var scriptLogDetailModel: ScriptLogDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
        



}

//MARK:- 数据请求
extension RecordDetailViewController {
    func loadData() {
        roomLogInfoRequest(room_id: room_id!) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                self?.scriptLogDetailModel = ScriptLogDetailModel(fromDictionary: data)
                self?.myTableView.reloadData()
                self?.tableHeaderView.scriptLogDetail = self!.scriptLogDetailModel?.script
            }
        }
    }
}


// MARK: - UI
extension RecordDetailViewController {
    func setUI() {
        

        
        let bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.white
        bottomView.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.height.equalTo(60)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview()
            }
        }
        
        
        let buttonWidth = (FULL_SCREEN_WIDTH-30-10) * 0.5
        
        bottomView.addSubview(evaluateBtn)
        evaluateBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(44)
            make.width.equalTo(buttonWidth)
            make.top.equalToSuperview().offset(8)
        }
        evaluateBtn.layoutIfNeeded()
        evaluateBtn.setTitle("シナリオ評価", for: .normal)
        evaluateBtn.setTitleColor(HexColor(MainColor), for: .normal)
        evaluateBtn.layer.borderColor = HexColor(MainColor).cgColor
        evaluateBtn.layer.borderWidth = 0.5
        evaluateBtn.layer.cornerRadius = 22
        evaluateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        evaluateBtn.addTarget(self, action: #selector(evaluateBtnAction), for: .touchUpInside)
//        evaluateBtn.isHidden = true
        
        
        bottomView.addSubview(truthBtn)
        truthBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(buttonWidth)
//            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        truthBtn.layoutIfNeeded()
        truthBtn.setTitle("真相をチェック", for: .normal)
        truthBtn.setTitleColor(UIColor.white, for: .normal)
        truthBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)
        truthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        truthBtn.addTarget(self, action: #selector(truthBtnAction), for: .touchUpInside)

        
        
        
        if myTableView == nil {
            myTableView = UITableView(frame:  CGRect(x: 0, y: -STATUS_BAR_HEIGHT, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT+STATUS_BAR_HEIGHT-60-HOME_INDICATOR_HEIGHT), style: .plain)
        }
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        myTableView.rowHeight = 100
        myTableView.backgroundColor = HexColor("#F5F5F5")
        self.view.addSubview(myTableView)
        myTableView.register(UINib(nibName: "RecordDetailViewCell", bundle: nil), forCellReuseIdentifier: RecordDetailCellId)
        myTableView.tableHeaderView = tableHeaderView
        
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        titleLabel.text = "公演履歴"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
        setNavigationBar(superView: self.view, titleLabel: titleLabel, leftBtn: backBtn, rightBtn: nil)
        
    }
}

// MARK: - TableView Delegate
extension RecordDetailViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptLogDetailModel?.roomUserList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordDetailCellId, for: indexPath) as! RecordDetailViewCell
        cell.selectionStyle = .none
        let model = scriptLogDetailModel?.roomUserList![indexPath.row]
        cell.itemModel = model
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
    
}

extension RecordDetailViewController {
    
    // 返回
    @objc func evaluateBtnAction() {
//        showToastCenter(msg: "暂未开通～")
        let vc = ScriptCommentsViewController()
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    // 查看真相
    @objc func truthBtnAction() {
//        let readScriptView = ReadScriptView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        let readScriptView = ReadScriptView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT),type: "truth")
        readScriptView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)

        readScriptView.type = "truth"
        readScriptView.scriptData = scriptLogDetailModel?.chapterList
        readScriptView.room_id = Int((scriptLogDetailModel?.script?.roomId!)!)
        readScriptView.roleResultModel = scriptLogDetailModel?.roleResult
        
//        readScriptView.script_role_id = scriptLogDetailModel?.scriptNodeResult.myRoleId
//        readScriptView.script_node_id = scriptLogDetailModel?.scriptNodeResult.scriptNodeId
        
        self.view.addSubview(readScriptView)
    }
    
    // 返回
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

