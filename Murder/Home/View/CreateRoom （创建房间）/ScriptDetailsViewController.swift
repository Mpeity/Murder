//
//  ScriptDetailsViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SVProgressHUD

let SynopsisViewCellId = "SynopsisViewCellId"

class ScriptDetailsViewController: UIViewController {
    
    var script_id: Int!
    
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
    
    private var contentSelected: Bool? = false{
        didSet {
            tableView.reloadData()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setUI()
        
        scriptDetailsFun()
    }
    
}

//MARK:- 数据请求
extension ScriptDetailsViewController {
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
        
}


extension ScriptDetailsViewController {
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
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeListTableHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeListHeaderViewId)
        
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.sectionHeaderHeight = 63
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-STATUS_BAR_HEIGHT)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(createBtn.snp.top).offset(-10)
        }
        
        tableView.tableHeaderView = tableHeaderView
        
        
        setNavigationBar()
    }
    
    
    private func setNavigationBar() {
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            case 1:
                return 1
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

        } else {
            
            let cell = RoleIntroductionCell(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 82))
            if scriptDetailModel != nil {
                cell.role = scriptDetailModel!.role!
            }
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
        } else {
            return 82
        }
    }
    
    
    
    
    
}


extension ScriptDetailsViewController {
    
    func getContentHeight() -> CGFloat {
        if scriptDetailModel != nil {
            let string =  scriptDetailModel!.introduction!            
            
            let label = UILabel()
//            label.backgroundColor = UIColor.gray
//            label.text = string
//            label.font = UIFont.systemFont(ofSize: 14)
//            label.textColor = HexColor("#666666")
//            label.textAlignment = .left
//            label.numberOfLines = 0
            
//            label.lineBreakMode = NSLineBreakMode.byWordWrapping
//            let size = label.sizeThatFits(CGSize(width: FULL_SCREEN_WIDTH-40, height: CGFloat(MAXFLOAT)))
//            var height = size.height
            
            
//            guard let news = string.removingPercentEncoding,let data = news.data(using: .unicode) else{return 0}
//            let att = [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html]
//            guard let attStr = try? NSMutableAttributedString(data: data, options: att, documentAttributes: nil) else{return 0}
//            label.attributedText = attStr
//            var height:CGFloat = label.attributedText?.boundingRect(with: CGSize(width: FULL_SCREEN_WIDTH-40, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).size.height ?? 0

            
            var height = stringSingleHeightWithWidth(text: string, width: FULL_SCREEN_WIDTH-40, font: UIFont.systemFont(ofSize: 16))
            
            Log(string)
            
            if height < 82 {
                height = 82
            }
            if contentSelected! {
                return height+70
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
