//
//  ScriptDetailsViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

private let Page_Size = 15



let SynopsisViewCellId = "SynopsisViewCellId"

class ScriptDetailsViewController: UIViewController {
    
    
    /// 自定义导航栏
    private lazy var customNavigationBar = UIView()
    /// 自定义导航栏完全不透明时的偏移量边界(根据需求设定)
    
    private let alphaChangeBoundary = FULL_SCREEN_WIDTH * (212 / 375) - NAVIGATION_BAR_HEIGHT
    
    var script_id: Int!
    
    private var page_no = 1

    
    var user_script_text: String? {
        didSet {
            
        }
    }
    
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    // 分享按钮
    private var shareBtn: UIButton = UIButton()
    
    
    
    private lazy var tableView: UITableView = UITableView()
    private var tableHeaderView: CreateRoomHeaderView!
    // 创建房间
    private var createBtn: UIButton = UIButton()
    
    private var scriptDetailModel: ScriptDetailModel!
    
    private var scriptCommentsModel: ScriptCommentsModel?
    
    private var contentSelected: Bool? = false{
        didSet {
            tableView.reloadData()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        navigationController?.view.insertSubview(customNavigationBar, at: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false

        customNavigationBar.removeFromSuperview()
        performSelector(onMainThread: #selector(delayHidden), with: animated, waitUntilDone: false)
    }
    
    @objc func delayHidden(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUI()
        
//        loadDataFun()
    }
    
}

//MARK:- 数据请求
extension ScriptDetailsViewController {
    
    func loadDataFun() {
        let myQueue:DispatchQueue = DispatchQueue.init(label: "textQueue")
        let group = DispatchGroup()
        group.enter() //把该任务添加到组队列中执行
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            self.scriptDetailsFun()
            group.leave()//执行完之后从组队列中移除
        })
         group.enter()
        myQueue.async(group: group, qos: .default, flags: [], execute: {
            self.scriptCommentsFun()
            group.leave()
        })

        //当上面所有的任务执行完之后通知
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        }
    }
    
    // MARK: - 获取详情
    func scriptDetailsFun() {
        if script_id != nil {
            SVProgressHUD.show()
            scriptDetail(script_id: script_id) { [weak self] (result, error) in
                SVProgressHUD.dismiss()
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    let data = resultDic["data"] as! [String : AnyObject]
                    let resultData = data["result"] as! [String : AnyObject]
                    let model = ScriptDetailModel(fromDictionary: resultData)
                    if model.isHave == 1 {
                        self?.createBtn.setTitle("ルームを作る", for: .normal)
                    }
                    self?.scriptDetailModel = model
                    self?.tableHeaderView.model = model
                    self?.tableView.reloadData()
                } else {
                    
                }
            }
        }
    }
    
    // MARK: - 获取评论
    func scriptCommentsFun() {
        if script_id != nil {
            getScriptCommentList(script_id: script_id, page_no: page_no, page_size: Page_Size) { [weak self] (result, error) in
                if error != nil {
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                    return
                }
                
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
                    let data = resultDic["data"] as! [String : AnyObject]
                    let model = ScriptCommentsModel(fromDictionary: data)

                    if self?.page_no == 1 {
                        self?.scriptCommentsModel = model
                    } else {
                        self?.scriptCommentsModel?.list?.append(contentsOf: model.list!)
                    }
                    self?.tableView.reloadData()


                    if model.list?.count ?? 0 < Page_Size { // 最后一页
                        //如果提醒他没有更多的数据了
                        self?.tableView.mj_header.endRefreshing()
                        self?.tableView.mj_footer.endRefreshing()
                        
                        if self?.page_no != 1 {
                            self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }
                        return
                    }
                    
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                    
                } else {
                    self?.tableView.mj_header.endRefreshing()
                    self?.tableView.mj_footer.endRefreshing()
                }
            }
        }
    }
    
    @objc private func loadMore() {
        page_no += 1
        scriptCommentsFun()
    }
    
    @objc private func loadRefresh() {
        page_no = 1
        loadDataFun()
    }
}


extension ScriptDetailsViewController {
    
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadRefresh))
        header?.backgroundColor = UIColor.white
        header?.lastUpdatedTimeLabel.isHidden = true  // 隐藏时间
        header?.stateLabel.isHidden = true // 隐藏文字
        header?.isAutomaticallyChangeAlpha = true //自动更改透明度
        
        // 设置tableview的header
        tableView.mj_header = header
        
        // 进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        footer?.setTitle("", for: .idle)
        footer?.setTitle("ローディング中...", for: .refreshing)
        footer?.setTitle("~ 以上です ~", for: .noMoreData)
        footer?.stateLabel.font = UIFont.systemFont(ofSize: 12)
        footer?.stateLabel.textColor = HexColor("#999999")
        tableView.mj_footer = footer
    }
    
    private func setUI() {

        self.view.addSubview(createBtn)
        createBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-7)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview().offset(-7)
            }
        }
        createBtn.layoutIfNeeded()
        createBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 22)

        createBtn.setTitle("無料ゲット", for: .normal)

        
        createBtn.setTitleColor(UIColor.white, for: .normal)
        createBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        createBtn.addTarget(self, action: #selector(createBtnAction), for: .touchUpInside)
        
        
        tableHeaderView = CreateRoomHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: STATUS_BAR_HEIGHT + 190))
        
        
//        tableView.frame = CGRect(x: 0, y: -STATUS_BAR_HEIGHT, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT-HOME_INDICATOR_HEIGHT-createBtn.bounds.size.height-10)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeListTableHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeListHeaderViewId)
        tableView.register(UINib.init(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: CommentsCellId)
        
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.sectionHeaderHeight = 63
        tableView.backgroundColor = UIColor.white

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-STATUS_BAR_HEIGHT)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(createBtn.snp.top).offset(-10)
        }
                
        tableView.tableHeaderView = tableHeaderView
        
        setNavigationBar()

        setupHeaderView()
        setupFooterView()
    }
    
    
    private func setNavigationBar() {
        
//        let navView = UIView()
//        navView.backgroundColor = UIColor(patternImage: UIImage(named: "mine_header_bg")!)
//        self.view.addSubview(navView)
//
//        navView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.height.equalTo(NAVIGATION_BAR_HEIGHT)
//            make.left.right.equalToSuperview()
//        }
        
        customNavigationBar.frame = CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: NAVIGATION_BAR_HEIGHT)
//        customNavigationBar.backgroundColor = UIColor(patternImage: UIImage(named: "mine_header_bg")!)
        
        customNavigationBar.backgroundColor = HexColor(MainColor)
        self.view.addSubview(customNavigationBar)
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                // Fallback on earlier versions
                make.top.equalToSuperview()
            }
            make.left.right.equalToSuperview()
            
        }
        
        bgView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(47)
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        backBtn.setImage(UIImage(named: "back_white"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        
        bgView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.width.equalTo(47)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        shareBtn.setImage(UIImage(named: "share_icon"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareBtnAction), for: .touchUpInside)
        
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.equalTo(backBtn.snp_right).offset(10)
            make.right.equalTo(shareBtn.snp_left).offset(-10)
            make.top.equalToSuperview()
        }
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "シナリオ詳細"
    }
}


extension ScriptDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                let count = scriptCommentsModel?.list.count ?? 0
                return count+1

            default:
                return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // 剧情简介
            let nibView = Bundle.main.loadNibNamed("SynopsisViewCell", owner: nil, options: nil)
            let cell = nibView!.first as! SynopsisViewCell
            if scriptDetailModel != nil {
                
                cell.content = scriptDetailModel!.introduction
            }
            cell.selectionStyle = .none
            cell.isSelected = contentSelected!
            if cell.isSelected {
                cell.boultBtn.setImage(UIImage(named: "jiantou_up"), for: .normal)
            } else {
                cell.boultBtn.setImage(UIImage(named: "jiantou_down"), for: .normal)
            }
            cell.boultBtnBlock = {[weak self](param) in
                Log(param)
                self?.contentSelected = !self!.contentSelected!
                self?.tableView.rectForRow(at: IndexPath(row: 0, section: 0))
            }
            return cell

        } else if indexPath.section == 1 {
            
            let cell = RoleIntroductionCell(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 82))
            if scriptDetailModel != nil {
                cell.role = scriptDetailModel!.role!
            }
            cell.selectionStyle = .none
            return cell
        }
        else {
            if indexPath.row == 0 {
                let nibView = Bundle.main.loadNibNamed("CommentsHeaderCell", owner: nil, options: nil)
                let cell = nibView!.first as! CommentsHeaderCell
                
                cell.selectionStyle = .none
                if scriptDetailModel != nil {
                    cell.userScriptStatus = scriptDetailModel.userScriptStatus
                    if scriptDetailModel.commentScore != nil {
                        let count = "\(scriptDetailModel.commentScore!)"
                        cell.countLabel.text = count
                    }
                    if scriptDetailModel.commentStar != nil {
                        let starView = StarView(count: CGFloat(scriptDetailModel.commentStar!), lineSpace: 0, fullImgName: "pinglun_pic_01", halfImgName: "pinglun_pic_03", zeroImgName: "pinglun_pic_02", sizeWidth: 25.0, sizeHeight: 25.0, frame: CGRect(x: 0, y: 0, width: 125, height: 25))
                        cell.commonStarView.addSubview(starView)
                    }
                    if scriptDetailModel.commentPeopleText != nil {
                        cell.contentLabel.text = scriptDetailModel.commentPeopleText!
                    }
                }
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCellId, for: indexPath) as! CommentsCell
            let itemModel = scriptCommentsModel?.list[indexPath.row-1]
            cell.itemModel = itemModel
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeListTableHeaderView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 60))
        
        switch section {
        case 0:
            header.titleLabel.text = "物語紹介"
        case 1:
            header.titleLabel.text = "キャラクター紹介"
        case 2:
            header.titleLabel.text = "カスタマーレビュー"
        default:
            break
        }

        return header
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath) as? SynopsisViewCell
            contentSelected = !contentSelected!
            if contentSelected!  {
                cell!.isSelected = contentSelected!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let height =  getContentHeight()
            return height
        } else if indexPath.section == 1 {
            return 82 + 30
        } else {
            if indexPath.row == 0 {
                if scriptDetailModel != nil {
                    if scriptDetailModel.userScriptStatus != 3 {
                        return 120
                    } else {
                        return 80
                    }
                }
                return 80
            } else {
                if scriptCommentsModel != nil && scriptCommentsModel?.list != nil {
                    let itemModel = scriptCommentsModel?.list[indexPath.row-1]
                    return itemModel?.cellHeight ?? 0
                }
                
                return 107
            }
        }
    }
    
    
    
    
    
    
    
}


extension ScriptDetailsViewController {
    
    func getContentHeight() -> CGFloat {
        if scriptDetailModel != nil {
            let string =  scriptDetailModel!.introduction!
            
            let myMutableString = try! NSMutableAttributedString(data: (string.data(using: String.Encoding.unicode))!, options: [NSMutableAttributedString.DocumentReadingOptionKey.documentType:NSMutableAttributedString.DocumentType.html], documentAttributes: nil)
            let range = NSMakeRange(0, myMutableString.length)
            myMutableString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)], range: range)
            
            var height1 = stringSingleHeightWithWidth(text: myMutableString.string, width: FULL_SCREEN_WIDTH-40, font: UIFont.systemFont(ofSize: 14), lineSpacing: 20)
            var height = stringSingleHeightWithWidth(text: string, width: FULL_SCREEN_WIDTH-40, font: UIFont.systemFont(ofSize: 14), lineSpacing: 20)
            
            Log(myMutableString)
            Log("1111111111111")
            Log(height)
            Log(height1)
            Log(myMutableString.string)
            
            if height < 82 {
                height = 82
            }
            if contentSelected! {
                return height
            } else {
                return 82
            }
        } else {
            return 82
        }
    }
    
    
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        let array = self.navigationController?.viewControllers
        if array == nil {
            
           UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        

    }
    //MARK: - 分享按钮
    @objc func shareBtnAction() {
        let commonView = ShareView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
    //MARK: - 创建房间按钮
    @objc func createBtnAction() {
        
        getScriptRequest(script_id: script_id) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) { // 免费获取剧本成功
                let vc = CreateRoomViewController()
                vc.script_id = (self?.scriptDetailModel?.scriptId)!
                vc.name = self?.scriptDetailModel.name
                vc.cover = self?.scriptDetailModel.cover
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                
            }
        }
        
        
    }
}

//MARK: - 分享代理
extension ScriptDetailsViewController: ShareViewDelegate {
    func shareFriendsBtnClick() {
        let vc = MyFriendsListViewController()
        vc.isShare = 1
        vc.shareModel = scriptDetailModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func shareLineBtnClick() {
        showToastCenter(msg: "開発中です")
    }
    
    func shareCopyBtnClick() {
        let past = UIPasteboard.general
        // pasteboardStr就是你要复制的字符串
        past.string =  scriptDetailModel.shareUrl
        showToastCenter(msg: "复制成功")
    }
    
    
}

extension ScriptDetailsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // navigationBar
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 0 && offsetY <= alphaChangeBoundary{
            customNavigationBar.backgroundColor = HexColor(MainColor).withAlphaComponent(offsetY / alphaChangeBoundary)

        }else if offsetY > alphaChangeBoundary {
            customNavigationBar.backgroundColor = HexColor(MainColor).withAlphaComponent(offsetY / alphaChangeBoundary)
        }else {
            customNavigationBar.backgroundColor = HexColor(MainColor).withAlphaComponent(0)
        }

        if offsetY < 0 {
            UIView.animate(withDuration: 0.1, animations: {
                self.customNavigationBar.alpha = 0
            })

        }else{
            UIView.animate(withDuration: 0.1, animations: {
                self.customNavigationBar.alpha = 1
            })
        }
        
        
        // sectionHeader不悬停
//        let sectionHeaderHeight: CGFloat  = 60
//          if(scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 ) {
//            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
//       } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
//       }
        
    }

}
