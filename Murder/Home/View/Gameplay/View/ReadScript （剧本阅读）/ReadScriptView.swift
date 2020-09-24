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
    

    private let iconImgView = UIImageView()
    
    private let nameLabel = UILabel()
    
    // 我的id
    var script_role_id : Int!
    
    var room_id : Int?
    
    var script_node_id: Int?
    
    var type :String? = "script"
    
    var script : ScriptLogDetail? {
        didSet {
        }
    }

    
    var scriptData : [AnyObject]? {
        didSet {
            if !scriptData!.isEmpty , scriptData?.count != 0{
                popMenuView.type = type
                popMenuView.titleArray = scriptData!
                popMenuView.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.bottom.equalTo(bottomBtn.snp.top).offset(5)
                    make.height.equalTo(55*popMenuView.titleArray.count + 20)
                    make.width.equalTo(136)
                }
                
                tableView.reloadData()
               
                if type != "script" {
                    let model = scriptData![0] as! ScriptLogChapterModel
                    label.text = model.name!
                    
                } else {
                    let model = scriptData![0] as! GPChapterModel
                    label.text = model.name!
                }
                

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
        bgView.backgroundColor = HexColor("#F5F5F5")
        self.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            if type != "script" {
                make.height.equalTo(552*SCALE_SCREEN)
            } else {
                make.height.equalTo(537*SCALE_SCREEN)
            }
        }
        bgView.layoutIfNeeded()
        bgView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: 15)

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ReadScriptViewCell", bundle: nil), forCellReuseIdentifier: ReadScriptCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.rowHeight = 492*SCALE_SCREEN
        tableView.backgroundColor = UIColor.white
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            if type != "script" {
                make.height.equalTo(552*SCALE_SCREEN)
            } else {
                make.height.equalTo(537*SCALE_SCREEN)
            }
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
            make.bottom.equalToSuperview().offset(500)
        }
        
        
        bgView.addSubview(popMenuView)
        popMenuView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomBtn.snp.top).offset(5)
            make.height.equalTo(175)
            make.width.equalTo(136)
        }
        popMenuView.delegate = self
        popMenuView.type = type
        popMenuView.imageName = "menu_catalogue"
        popMenuView.cellRowHeight = 55
        popMenuView.lineColor = HexColor(hex: "#FFFFFF", alpha: 0.05)
        popMenuView.contentTextColor = UIColor.white
        popMenuView.contentTextFont = 15
        popMenuView.refresh()
        
        
        if type != "script" {
            showBottomView()
            bottomBtn.isSelected = true
        }
        
    }
}


extension ReadScriptView: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return scriptData?.count ?? 0
//    }
//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptData?.count ?? 0
        
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadScriptCellId, for: indexPath) as! ReadScriptViewCell
        cell.selectionStyle = .none
        
        
        if type == "script" {
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
        } else {
            let model = scriptData![indexPath.row] as! ScriptLogChapterModel
            cell.logChapterModel = model
            cell.textViewTapBlcok = {(param)->() in
                if param {
                    self.showBottomView()
                } else {
                    self.hideBottomView()
                }
                
            }
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView()
        view.backgroundColor = UIColor.white
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label.textColor = HexColor("#333333")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        
        if type != "script" {
            view.addSubview(iconImgView)
            iconImgView.setImageWith(URL(string: (UserAccountViewModel.shareInstance.account?.head!)!))
            iconImgView.layer.cornerRadius = 15
            iconImgView.layer.masksToBounds = true
            iconImgView.snp.makeConstraints { (make) in
                make.height.width.equalTo(30)
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(22)
            }
            
            
            view.addSubview(nameLabel)
            nameLabel.textColor = HexColor("#333333")
            nameLabel.text = UserAccountViewModel.shareInstance.account?.nickname!
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            nameLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(38)
                make.left.equalToSuperview().offset(12)
                make.width.equalTo(50)
                make.height.equalTo(22)
            }
        }
        
        
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
        if type != "script" {
            return 60
        } else {
          return 45
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "第\(section)章"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == "script" {
            let model = scriptData?[indexPath.row] as! GPChapterModel
            let font = UIFont.systemFont(ofSize: 15)
            let height = stringSingleHeightWithWidth(text: model.content, width: FULL_SCREEN_WIDTH-30, font: font)
            
//            let height = getContentHeight(string: model.content!)
            
            if height <= CGFloat(492.0*SCALE_SCREEN) {
                return 492*SCALE_SCREEN
            }
            return height
            
        } else {
            let model = scriptData?[indexPath.row] as! ScriptLogChapterModel
            let font = UIFont.systemFont(ofSize: 15)
            let height = stringSingleHeightWithWidth(text: model.content, width: FULL_SCREEN_WIDTH-30, font: font)
//            let height = getContentHeight(string: model.content!)
            
            if height <= CGFloat(492.0*SCALE_SCREEN) {
                return 492*SCALE_SCREEN
            }
            return height
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    

    

    
    
}


extension ReadScriptView {
    
    private func getContentHeight(string: String) -> CGFloat {
        let label = UILabel()
        label.backgroundColor = UIColor.gray
        label.text = string
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = HexColor("#666666")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let size = label.sizeThatFits(CGSize(width: FULL_SCREEN_WIDTH-30, height: CGFloat(MAXFLOAT)))
        let height = size.height
        return height
    }
    
    @objc func hideView() {
        self.isHidden = true
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
                make.bottom.equalToSuperview().offset(500)
            }
        }
        
    }
    
    
}

//MARK:- PopMenuViewDelegate
extension ReadScriptView: PopMenuViewDelegate {
    func cellDidSelected(index: Int, model: AnyObject?) {
        
        if type! == "script" {
            let currentIndex = index
            let indexPath = IndexPath(row: currentIndex, section: 0)
            let item = scriptData![currentIndex] as! GPChapterModel
            label.text = "\(item.name!) "
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            let mapData = ["user_id":UserAccountViewModel.shareInstance.account?.userId!,"type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":1,"script_role_id":script_role_id!,"game_status_type":"chapter_see","script_role_chapter_id":item.scriptRoleChapterId!,"key":UserAccountViewModel.shareInstance.account?.key] as [String : AnyObject]
            let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
            SingletonSocket.sharedInstance.socket.write(string: mapJson)
            popMenuView.selectIndexPath = indexPath
            
        } else {
            let currentIndex = index
            let indexPath = IndexPath(row: currentIndex, section: 0)
            let item = scriptData![currentIndex] as! ScriptLogChapterModel
            label.text = "【 \(item.name!) 】"
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        }
                
        
        
        
//        let script_role_id = gamePlayModel?.scriptNodeResult.myRoleId
//        let secret_talk_id = index+1
//        let mapData = ["type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":1,"script_role_id":script_role_id!,"secret_talk_id":secret_talk_id,"game_status_type":"secret_talk","key":(UserAccountViewModel.shareInstance.account?.key!)! as String] as [String : AnyObject]
        
//        let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
//        SingletonSocket.sharedInstance.socket.write(string: mapJson)
        
    }
        
}

extension ReadScriptView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let cellArr = tableView.indexPathsForVisibleRows
        let indexPath = cellArr?[cellArr!.count - 1]
        let index = indexPath?.row
        
        Log(indexPath)
        Log(index)

        if type! == "script" {
//            let y = scrollView.contentOffset.y
//            let index = Int(y / 492)
            let item = scriptData![index!] as! GPChapterModel
            label.text = "\(item.name!)"
        } else {
//            let y = scrollView.contentOffset.y
//            let index = Int(y / 492)
            let item = scriptData![index!] as! ScriptLogChapterModel
            label.text = "\(item.name!)"
        }
         
        popMenuView.selectIndexPath = IndexPath(row: index!, section: 0)

        hideBottomView()
    }
    
    
}










