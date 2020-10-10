//
//  ThreadCardView.swift
//  Murder
//
//  Created by m.a.c on 2020/7/24.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

//typealias AvatarImgTapBlcok = () ->()

// 深入查看按钮
typealias DeepBtnActionBlock = (_ clueResultModel: SearchClueResultModel) ->()
// 公开按钮
typealias PublicBtnActionBlock = (_ clueResultModel: SearchClueResultModel) ->()

class ThreadCardView: UIView {
    
    
    var deepBtnActionBlock : DeepBtnActionBlock?
    
    var publicBtnActionBlock : PublicBtnActionBlock?
    
    
    @IBOutlet var contentView: UIView!
    
    // 图片
    @IBOutlet weak var imgView: UIImageView!
    // 公开
    @IBOutlet weak var publicBtn: UIButton!
    // 可深入
    @IBOutlet weak var deepBtn: UIButton!
    // 关闭
    @IBOutlet weak var cancelBtn: UIButton!
    
    var script_place_id: Int?
    
    var room_id: Int?
    
    var script_node_id: Int?
    
    var script_clue_id: Int?
    
    var clueListModel :ClueListModel? {
        didSet {
            if clueListModel != nil {
                script_node_id = clueListModel?.scriptNodeId
                script_place_id = clueListModel?.scriptPlaceId
                script_clue_id = clueListModel?.scriptClueId
                if clueListModel?.attachment != nil {
                    imgView.setImageWith(URL(string: (clueListModel?.attachment!)!))
                }
                if clueListModel?.isGoing == 1 { // 可深入
                    deepBtn.layer.cornerRadius = 22
                    deepBtn.setTitleColor(UIColor.white, for: .normal)
                    deepBtn.backgroundColor = HexColor(MainColor)
                } else {
                    deepBtn.layer.cornerRadius = 22
                    deepBtn.layer.borderColor = HexColor(MainColor).cgColor
                    deepBtn.layer.borderWidth = 0.5
                    deepBtn.setTitleColor(HexColor(MainColor), for: .normal)
                }
            }
        }
    }
    
    var clueResultModel: SearchClueResultModel? {
        didSet {
            if clueResultModel != nil {
                script_clue_id = clueResultModel?.scriptClueId
                if clueResultModel?.attachment != nil {
                    imgView.setImageWith(URL(string: (clueResultModel?.attachment!)!))
                }
                if clueResultModel?.isGoing == 1 { // 可深入
                    deepBtn.layer.cornerRadius = 22
                    deepBtn.setTitleColor(UIColor.white, for: .normal)
                    deepBtn.backgroundColor = HexColor(MainColor)
                } else {
                    deepBtn.layer.cornerRadius = 22
                    deepBtn.layer.borderColor = HexColor(MainColor).cgColor
                    deepBtn.layer.borderWidth = 0.5
                    deepBtn.setTitleColor(HexColor(MainColor), for: .normal)
                }
            }
        }
    }
    
    
    // 深入按钮
    @IBAction func deepBtnAction(_ sender: Any) {
        if clueResultModel?.isGoing == 1 { // 可深入
//            deepBtnActionBlock?(clueResultModel!)
            
            searchClueRequest(room_id: room_id!, script_place_id: script_place_id!, script_clue_id: script_clue_id, script_node_id: script_node_id!) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    let data = resultDic["data"] as! [String : AnyObject]
                    let resultData = data["search_clue_result"] as! [String : AnyObject]
                    let model = SearchClueResultModel(fromDictionary: resultData)
                    self!.clueResultModel = model
                    
                } else {
                    
                }
            }
        } else {
            self.removeFromSuperview()
        }
    }
    
    // 公开按钮
    @IBAction func publicBtnAction(_ sender: Any) {
        
        clueOpenRequest(room_id: room_id!, script_clue_id: script_clue_id!, script_place_id: script_place_id!, script_node_id: script_node_id!) { (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["msg"] as! String
                showToastCenter(msg: data)
                
            } else {
                
            }
        }
        
        self.removeFromSuperview()
        
//        publicBtnActionBlock?(clueResultModel!)
    }
    
    // 关闭按钮
    @IBAction func cancelBtnAction(_ sender: Any) {
        contentView = nil
        removeFromSuperview()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        addConstraints()
        
        // 设置UI
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ThreadCardView {
    //MARK:- 设置UI
    private func setUI() {
        self.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        
        publicBtn.layer.cornerRadius = 22
        publicBtn.layer.borderColor = HexColor(MainColor).cgColor
        publicBtn.layer.borderWidth = 0.5
        publicBtn.setTitleColor(HexColor(MainColor), for: .normal)
        
        deepBtn.layer.cornerRadius = 22
        deepBtn.layer.borderColor = HexColor(MainColor).cgColor
        deepBtn.layer.borderWidth = 0.5
        deepBtn.setTitleColor(HexColor(MainColor), for: .normal)
    }
}

extension ThreadCardView {
    
}

extension ThreadCardView {
    //加载xib
     func loadViewFromNib() -> UIView {
         let className = type(of: self)
         let bundle = Bundle(for: className)
         let name = NSStringFromClass(className).components(separatedBy: ".").last
         let nib = UINib(nibName: name!, bundle: bundle)
         let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
         return view
     }
    
     //设置好xib视图约束
     func addConstraints() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView!, attribute: .leading,
                                             relatedBy: .equal, toItem: self, attribute: .leading,
                                             multiplier: 1, constant: 0)
        addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .trailing,
                                         relatedBy: .equal, toItem: self, attribute: .trailing,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal,
                                         toItem: self, attribute: .top, multiplier: 1, constant: 0)
         addConstraint(constraint)
         constraint = NSLayoutConstraint(item: contentView!, attribute: .bottom,
                                         relatedBy: .equal, toItem: self, attribute: .bottom,
                                         multiplier: 1, constant: 0)
         addConstraint(constraint)
     }
}


