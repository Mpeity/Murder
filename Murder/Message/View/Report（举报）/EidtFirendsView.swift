//
//  EidtFirendsView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol EidtFirendsViewDelegate {
    // 删除好友
    func deleteFriends()
    // 拉黑好友
    func blackFriends()
    
    func reportFriends()
}

class EidtFirendsView: UIView {
    
    var delegate: EidtFirendsViewDelegate?

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var commonView: UIView!
    // 举报
    @IBOutlet weak var reportBtn: UIButton!
    // 拉黑
    @IBOutlet weak var blackBtn: UIButton!
    // 删除
    @IBOutlet weak var deleteBtn: UIButton!
    // 取消
    @IBOutlet weak var cancelBtn: UIButton!
    
    
//    var itemModel: MessageListModel? {
//        didSet {
//            if itemModel != nil {
//                refreshUI()
//            }
//        }
//    }
    
    var receive_id: Int?

    
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
    
        
        setUI()
    }
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}




// MARK: - setUI
extension EidtFirendsView {
    
    
    private func refreshUI() {
       
        
    }
    
    private func setUI() {

        contentView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        
        commonView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft], radii: 20)
        commonView.viewWithCorner(byRoundingCorners: [UIRectCorner.topRight], radii: 20)
        
        blackBtn.addTarget(self, action: #selector(blackBtnAction), for: .touchUpInside)
        reportBtn.addTarget(self, action: #selector(reportBtnAction), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
    }
    
}


extension EidtFirendsView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelBtnAction()
    }
    
    //MARK:-取消
    @objc private func cancelBtnAction() {
        contentView = nil
        removeFromSuperview()
    }
    
    //MARK:- 举报
    @objc private func reportBtnAction() {
        self.isHidden = true
        if delegate != nil {
            delegate?.reportFriends()
        }
    }
    
    //MARK:- 删除好友
    @objc private func deleteBtnAction() {

        self.isHidden = true
        let commonView = DeleteFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.deleteBtnTapBlcok = {[weak self] () in
            let friend_id = self?.receive_id
            deleteFriendRequest(friend_id: friend_id!) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
                    showToastCenter(msg: resultDic["msg"] as! String)
                    if self?.delegate != nil {
                        self?.delegate?.deleteFriends()
                    }
                    self?.contentView = nil
                    self?.removeFromSuperview()
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Delete_Friend_Notif), object: nil)
                }
            }
        }
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
        
    //MARK:- 拉黑
     @objc private func blackBtnAction() {
        SVProgressHUD.show()
        friendIsBlockRequest(friend_id: receive_id!) {[weak self] (result, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String: Any]
                let isBlock = data["is_block"] as! Int
                if isBlock == 0 { // 未拉黑
                    self?.showBlackView()
                } else { // 已拉黑
                    showToastCenter(msg: "この人をブロックしました。")
                }
            }
        }
    }
    
    private func showBlackView() {
        self.isHidden = true
        let commonView = BlackFriendsView(frame: CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT))
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        commonView.deleteBtnTapBlcok = {[weak self] () in
            let friend_id = self?.receive_id
            friendBlockRequest(friend_id: friend_id!) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    showToastCenter(msg: resultDic["msg"] as! String)
                    if self?.delegate != nil {
                        self?.delegate?.blackFriends()
                    }
                    self?.contentView = nil
                    self?.removeFromSuperview()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Delete_Friend_Notif), object: nil)
                }
            }
        }
        UIApplication.shared.keyWindow?.addSubview(commonView)
    }
    
    
    //查找视图对象的响应者链条中的导航视图控制器
    private func findNavController() -> UINavigationController? {
         
         //遍历响应者链条
         var next = self.next
         //开始遍历
         while next != nil {
            //判断next 是否是导航视图控制器
            if let nextobj = next as? UINavigationController {
                return nextobj
            }
            //如果不是导航视图控制器 就继续获取下一个响应者的下一个响应者
            next = next?.next
         }
        return nil
     }
    
    
}


extension EidtFirendsView {
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
