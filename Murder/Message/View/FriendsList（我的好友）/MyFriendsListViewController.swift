//
//  MyFriendsListViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import MJRefresh

let MyFriendsListCellId = "MyFriendsListCellId"

class MyFriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var isShare: Bool = false
    
    var shareModel: ScriptDetailModel?
    
    
    private var myTableView: UITableView!
    
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    //
    private var rightBtn: UIButton = UIButton()
    
    private var page_no = 1
    
    private var page_size = 1
    
    private var friendsModel: FriendsModel?
    
    private lazy var textInputView : InputTextView! = {
        let inputView = InputTextView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        inputView.delegate = self
        inputView.textFieldView.delegate = self
        inputView.textFieldView.keyboardType = .numberPad
        inputView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        return inputView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 监听键盘弹出
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillChangeFrame(notif:)) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - LoadData
extension MyFriendsListViewController {
    
    @objc private func loadMore() {
        page_no += 1
        loadData()
    }
    
    @objc private func loadRefresh() {
        page_no = 1
        loadData()
    }
    
    func loadData() {
        friendListRequest(page_no: page_no, page_size: page_size) {[weak self] (result, error) in
            if error != nil {
                self?.myTableView.mj_header.endRefreshing()
                self?.myTableView.mj_footer.endRefreshing()
                return
            }
            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                
                let model = FriendsModel(fromDictionary: data)
                if model.list?.count ?? 0 < 15 { // 最后一页
                    self?.myTableView.mj_header.endRefreshing()
                    self?.myTableView.mj_footer.endRefreshing()
                }
                
                if self?.page_no == 1 {
                    self?.friendsModel = model
                } else {
                    self?.friendsModel?.list?.append(contentsOf: model.list!)
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
extension MyFriendsListViewController {
    
    private func setNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
//        rightBtn.setImage(UIImage(named: "send_message_r_icon"), for: .normal)
//        rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
        
        if !isShare {
            let btn = UIButton()
            btn.setImage(UIImage(named: "message_addbuddy"), for: .normal)
            btn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
            let rightItem = UIBarButtonItem(customView: btn)
            navigationItem.rightBarButtonItem = rightItem
        }

        
        
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "私の友達"
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
        myTableView.register(UINib(nibName: "MyFriendsListCell", bundle: nil), forCellReuseIdentifier: MyFriendsListCellId)
        setupFooterView()
        setupHeaderView()
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
extension MyFriendsListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsModel?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyFriendsListCellId, for: indexPath) as! MyFriendsListCell
        cell.selectionStyle = .none
        let model = friendsModel?.list[indexPath.row]
        cell.itemModel = model
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isShare { // 分享 显示分享card
            let commonView = ShareScriptCard(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
            commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
            
            self.view.addSubview(commonView)
            
        } else {
//            let RecordDetailVC = RecordDetailViewController()
//            self.navigationController?.pushViewController(RecordDetailVC, animated: true)
            
            let vc = SendMessageViewController()
            
            let model = friendsModel?.list[indexPath.row]
            
            let messageListModel = MessageListModel(fromDictionary: [:])
            messageListModel.head = model?.head
            messageListModel.level = model?.level
            messageListModel.sex = model?.sexText == "男" ? 1 : 2
            messageListModel.userId = model?.userId
            messageListModel.nickname = model?.nickname
            
            
            vc.messageListModel = messageListModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

    }

    
    
}

extension MyFriendsListViewController {
    
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBtnAction() {
        textInputView.textFieldView.becomeFirstResponder()
        UIApplication.shared.keyWindow?.addSubview(textInputView)
    }
}

extension MyFriendsListViewController: InputTextViewDelegate  {
    
    func commonBtnClick() {
        textInputView.removeFromSuperview()
        
        let user_id = Int(textInputView.textFieldView.text!)
        userFindRequest(user_id: user_id!) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let resultData = data["result"] as! [String : AnyObject]
                let userFindModel = UserFindModel(fromDictionary: resultData)
                let commonView = ApplyFriendView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
                commonView.userFindModel = userFindModel
                commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
                UIApplication.shared.keyWindow?.addSubview(commonView)
            }
        }
        

        
        
    }
    
    @objc func keyboardWillChangeFrame(notif: Notification) {
        // 获取动画执行的时间
        let duration = notif.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 获取键盘最终Y值
        let endFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 计算工具栏距离底部的间距
        let margin = FULL_SCREEN_HEIGHT - y - HOME_INDICATOR_HEIGHT
        
        // 执行动画
        textInputView.bottomConstraint.constant = margin
        UIView.animate(withDuration: duration) {
            self.textInputView.layoutIfNeeded()
        }
    }
}
