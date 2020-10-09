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
    
    private lazy var tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    
    private lazy var bottomBtn: UIButton = UIButton()
    
    private let popMenuView = PopMenuView()
    
    private let label = UILabel()
    

    private let iconImgView = UIImageView()
    
    private let nameLabel = UILabel()
    
    // 向上/向下滑动
    private var scrollUp: Bool = false
    
    // 我的id
    var script_role_id : Int!
    
    var room_id : Int?
    
    var script_node_id: Int?
     

    
    let table_scale: CGFloat = 492.0/667.0
    
    var currentIndex: Int = 0
    
    var webViewCellHeight: Float = 0
    
//    let bgView = UIView()
    
    var table_headerHeight: CGFloat = 45
    
    
    var type :String? = "script" {
        didSet {
            headerView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview()
                make.width.equalTo(FULL_SCREEN_WIDTH)
                if type != "script" {
                    make.height.equalTo(60*SCALE_SCREEN)
                } else {
                    make.height.equalTo(table_headerHeight*SCALE_SCREEN)
                }
            }
        
            if type != "script" {
                headerView.addSubview(iconImgView)
                iconImgView.layer.cornerRadius = 15
                iconImgView.layer.masksToBounds = true
                iconImgView.snp.makeConstraints { (make) in
                    make.height.width.equalTo(30*SCALE_SCREEN)
                    make.top.equalToSuperview().offset(8)
                    make.left.equalToSuperview().offset(22)
                }
                headerView.addSubview(nameLabel)
                nameLabel.textColor = HexColor("#333333")
                nameLabel.textAlignment = .center
                nameLabel.font = UIFont.systemFont(ofSize: 12)
                nameLabel.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(38*SCALE_SCREEN)
                    make.left.equalToSuperview().offset(12)
                    make.width.equalTo(50)
                    make.height.equalTo(22*SCALE_SCREEN)
                }
            }
            
            tableView.snp.makeConstraints { (make) in
                if type != "script" {
                    make.top.equalToSuperview().offset(60*SCALE_SCREEN)
                } else {
                    make.top.equalToSuperview().offset(table_headerHeight*SCALE_SCREEN)
                }
                
                make.left.right.equalToSuperview()
                
                if IS_iPHONE_X {
                    make.height.equalTo(table_scale*FULL_SCREEN_HEIGHT)
                } else {
                    make.height.equalTo(492.0*SCALE_SCREEN)
                }
            }
        }
    }
    
    private let headerView = UIView()
    
    var script : ScriptLogDetail? {
        didSet {
            
        }
    }
    
    var roleResultModel : ScriptRoleResult? {
        didSet {
            guard let roleResultModel = roleResultModel else {
                return
            }
            iconImgView.setImageWith(URL(string: roleResultModel.headId!))
            nameLabel.text = roleResultModel.name!
//            nameLabel.text = "\(IS_iPHONE_X)"
        }
    }


    
    var scriptData : [AnyObject]? {
        didSet {
            if scriptData != nil , scriptData?.count != 0{
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
    
    init(frame: CGRect, type: String) {
        super.init(frame: frame)
        self.type = type
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    deinit {
        
    }

}




extension ReadScriptView {
    private func setUI() {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
        
        var bgView_height:CGFloat = 0.0
                    
        if IS_iPHONE_X {
            if type != "script" {
                bgView_height = 60.0*SCALE_SCREEN + table_scale * FULL_SCREEN_HEIGHT + HOME_INDICATOR_HEIGHT
            } else {
                bgView_height = table_headerHeight * SCALE_SCREEN + table_scale * FULL_SCREEN_HEIGHT + HOME_INDICATOR_HEIGHT
            }
        } else {
            if type != "script" {
                bgView_height = 60.0*SCALE_SCREEN + 492.0 * SCALE_SCREEN
            } else {
                bgView_height = table_headerHeight * SCALE_SCREEN + 492.0 * SCALE_SCREEN
            }
        }
        
        bgView.frame = CGRect(x: 0, y: FULL_SCREEN_HEIGHT-bgView_height, width: FULL_SCREEN_WIDTH, height: bgView_height)
        
        bgView.layoutIfNeeded()
        
        bgView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: 15)
        headerView.backgroundColor = UIColor.white
        bgView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(FULL_SCREEN_WIDTH)
            if type != "script" {
                make.height.equalTo(60*SCALE_SCREEN)
            } else {
                make.height.equalTo(table_headerHeight*SCALE_SCREEN)
            }
        }

        headerView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label.textColor = HexColor("#333333")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)


        let cancelBtn = UIButton()
        headerView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        cancelBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "cancel_readscript"), for: .normal)
                
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ReadScriptViewCell", bundle: nil), forCellReuseIdentifier: ReadScriptCellId)
        // 隐藏cell系统分割线
        tableView.separatorStyle = .none;
        tableView.bounces = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = HexColor("#F5F5F5")
        
        tableView.isPagingEnabled = true
        
        if IS_iPHONE_X {
            tableView.estimatedRowHeight = table_scale*FULL_SCREEN_HEIGHT
        } else {
            tableView.estimatedRowHeight = 492*SCALE_SCREEN
        }

        bgView.addSubview(tableView)
//        tableView.snp.makeConstraints { (make) in
//            if type != "script" {
//                make.top.equalToSuperview().offset(60*SCALE_SCREEN)
//            } else {
//                make.top.equalToSuperview().offset(45*SCALE_SCREEN)
//            }
//
//            make.left.right.equalToSuperview()
//            if IS_iPHONE_X {
//                make.height.equalTo(table_scale*FULL_SCREEN_HEIGHT)
//            } else {
//                make.height.equalTo(492*SCALE_SCREEN)
//            }
//            make.bottom.equalToSuperview().offset(HOME_INDICATOR_HEIGHT)
//        }

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return scriptData?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
//        return scriptData?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReadScriptCellId, for: indexPath) as! ReadScriptViewCell
        cell.selectionStyle = .none

//        if indexPath.section % 2 == 0 {
//            cell.backgroundColor = UIColor.red
//        } else {
//            cell.backgroundColor = UIColor.green
//        }
        
        
        if type == "script" {
            let model = scriptData![indexPath.section] as! GPChapterModel
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
            let model = scriptData![indexPath.section] as! ScriptLogChapterModel
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
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IS_iPHONE_X {
            return table_scale*FULL_SCREEN_HEIGHT
        } else {
            return 492*SCALE_SCREEN
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    

    

    
    
}


extension ReadScriptView {
    
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
            let item = scriptData![currentIndex] as! GPChapterModel

            label.text = "\(item.name!) "
            tableView.scroll(toRow: 0, inSection: UInt(currentIndex), at: .top, animated: true)
            let popIndexPath = IndexPath(row: currentIndex, section: 0)
            
            popMenuView.selectIndexPath = popIndexPath

            
            let mapData = ["user_id":UserAccountViewModel.shareInstance.account?.userId!,"type":"game_status","scene":1,"room_id":room_id!,"group_id":room_id!,"script_node_id":script_node_id!,"status":1,"script_role_id":script_role_id!,"game_status_type":"chapter_see","script_role_chapter_id":item.scriptRoleChapterId!,"key":UserAccountViewModel.shareInstance.account?.key] as [String : AnyObject]
            let mapJson = getJSONStringFromDictionary(dictionary: mapData as NSDictionary)
            SingletonSocket.sharedInstance.socket.write(string: mapJson)
            
        } else {
            
            let currentIndex = index
            let item = scriptData![currentIndex] as! ScriptLogChapterModel

            label.text = "\(item.name!) "
            tableView.scroll(toRow: 0, inSection: UInt(currentIndex), at: .top, animated: true)
            let popIndexPath = IndexPath(row: currentIndex, section: 0)
            popMenuView.selectIndexPath = popIndexPath
        
        }
        
    }
        
}

extension ReadScriptView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var nowSection = -1 as Int
        let cellArr = tableView.visibleCells
        guard let cell = cellArr.first else { return }
        let indexPath = tableView.indexPath(for: cell)
        nowSection = indexPath!.section
        
        if type! == "script" {
            let item = scriptData![nowSection] as! GPChapterModel
            label.text = "\(item.name!)"
        } else {
            let item = scriptData![nowSection] as! ScriptLogChapterModel
            label.text = "\(item.name!)"
        }
        
        popMenuView.selectIndexPath = IndexPath(row: nowSection, section: 0)
        hideBottomView()
        
//        //上下滑动的距离
//        let off_y = scrollView.contentOffset.y
//
//        //如果off_y小于0，则为向下滑动，然后再用setContentOffset方法设置整个tableview的偏移量为（0，0）这样看起来就像无法向下滑动一样
//        if off_y < 0 {
//            self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
//        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
}
    
    
    
  







