//
//  ReadScriptView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let ReadScriptCellId = "ReadScriptCellId"

class ReadScriptView: UIView {
    
    private lazy var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
    
    private lazy var bottomBtn: UIButton = UIButton()
    
    private let popMenuView = PopMenuView()
    
    private let label = UILabel()
    
    // 我的id
    var script_role_id : Int!
    
    var room_id : Int?
    
    var script_node_id: Int?

    
    var scriptData : [AnyObject]? {
        didSet {
            if !scriptData!.isEmpty{
//                var arr = [AnyObject]()
//                for item:GPChapterModel in scriptData as! [GPChapterModel] {
//                    arr.append(item.name as AnyObject)
//                }
                popMenuView.titleArray = scriptData!
                tableView.reloadData()

            }
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


extension ReadScriptView {
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

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ReadScriptViewCell", bundle: nil), forCellReuseIdentifier: ReadScriptCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 492
        tableView.backgroundColor = UIColor.white
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(537)
        }

        bottomBtn.createButton(style: .right, spacing: 30, imageName: "catalogue", title: "目録", cornerRadius: 0, color: "#ffffff")
        bottomBtn.setTitleColor(HexColor("#333333"), for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        bottomBtn.addTarget(self, action: #selector(bottomBtnAction(button:)), for: .touchUpInside)
        bgView.addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(250)

        }
        
        
        bgView.addSubview(popMenuView)
        popMenuView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomBtn.snp.top).offset(5)
            make.height.equalTo(175)
            make.width.equalTo(136)
        }
        popMenuView.delegate = self
        popMenuView.imageName = "menu_catalogue"
        popMenuView.cellRowHeight = 55
        popMenuView.lineColor = HexColor(hex: "#FFFFFF", alpha: 0.05)
        popMenuView.contentTextColor = UIColor.white
        popMenuView.contentTextFont = 15
        popMenuView.refresh()
        
    }
}


extension ReadScriptView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadScriptCellId, for: indexPath) as! ReadScriptViewCell
        cell.selectionStyle = .none
        
        let model = scriptData![indexPath.row] as! GPChapterModel
        cell.itemModel = model
        cell.textViewTapBlcok = {(param)->() in
            if param {
                self.showBottomView()
            } else {
                self.hideBottomView()
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
//        let model = scriptData![indexPath.row] as! GPChapterModel

        
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label.text = "【 第一幕 】"
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
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "第\(section)章"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = scriptData![indexPath.row] as! GPChapterModel
        
        let height = model.content?.ga_heightForComment(fontSize: 15, width: FULL_SCREEN_WIDTH-30)
        
        if height! <= CGFloat(492.0) {
            return 492
        }
        return height!
    }
}


extension ReadScriptView {
    @objc func hideView() {
        self.removeFromSuperview()
    }
    
    @objc func bottomBtnAction(button:UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            showBottomView()
        } else {
            hideBottomView()
        }
    }
    
    // 显示底部目录按钮
    func showBottomView() {
        UIView.animate(withDuration: 0.3) {
            self.bottomBtn.snp.remakeConstraints { (make) in
                       make.right.equalToSuperview()
                       make.left.equalToSuperview()
                       make.height.equalTo(50)
                       if #available(iOS 11.0, *) {
                           make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                       } else {
                           // Fallback on earlier versions
                           make.bottom.equalToSuperview()

                       }
                   }
               }
    }
    // 隐藏底部目录按钮
    func hideBottomView() {
        UIView.animate(withDuration: 0.3) {
            self.bottomBtn.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.left.equalToSuperview()
                make.height.equalTo(50)
                make.bottom.equalToSuperview().offset(250)
            }
        }
        
    }
    
    
}

//MARK:- PopMenuViewDelegate
extension ReadScriptView: PopMenuViewDelegate {
    func cellDidSelected(index: Int, model: AnyObject?) {
        
                
        
        let currentIndex = index
        let indexPath = IndexPath(row: currentIndex, section: 0)
        let model = scriptData![currentIndex] as! GPChapterModel
        label.text = "【 \(model.name!) 】"
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        
        
        let mapData = ["type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":1,"script_role_id":script_role_id!,"game_status_type":"chapter_see","key":UserAccountViewModel.shareInstance.account?.key] as [String : AnyObject]
        
        let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
        
        SingletonSocket.sharedInstance.socket.write(string: mapJson)
        
    }
        
}

extension ReadScriptView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideBottomView()
    }
}
