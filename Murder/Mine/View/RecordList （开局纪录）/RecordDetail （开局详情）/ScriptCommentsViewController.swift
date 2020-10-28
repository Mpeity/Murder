//
//  ScriptCommentsViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/10/27.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SVProgressHUD


enum CommentsFromType {
    // GamePlay 游戏中    ScriptLog 游戏记录
    case gamePlay
    case scriptLog
}

class ScriptCommentsViewController: UIViewController {
    
    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()

    // 名称
    private var nameLabel: UILabel?

    private var starView: StarView?
    
    private var textBgView: UIView?
    
    private var textView: EWTextView?
    
    private var tagButton: UIButton?
        
    private var confirmBtn: UIButton?
    
    // 是 修改评论 否 添加评论
    private var isEidt: Bool? = false
    
    private var leak: Int? = 0
    
    private var content: String?
    
    private var star: Int? = 0
    
    private var scriptCommentModel: ScriptCommentModel?

    
    var fromType: CommentsFromType?
    
    var scriptName: String? {
        didSet {
            
        }
    }
    
    var scriptId: Int? {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBar()
        setUI()
    }

}

extension ScriptCommentsViewController {
    private func commentFindFunc() {
        SVProgressHUD.show()
        commentFindRequest(script_id: self.scriptId!) {[weak self] (result, error) in
            SVProgressHUD.dismiss()
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let result = data["result"] as? [String : AnyObject]
                let is_comment = data["is_comment"] as? Int
                
                if result != nil || is_comment != 0 {
                    self?.isEidt = true
                    self?.starView?.isEdit = false
                    self?.scriptCommentModel = ScriptCommentModel(fromDictionary: result!)
                    self?.refreshUI()
                } else {
                    self?.starView?.isEdit = true
                }
            }
        }
    }
}


extension ScriptCommentsViewController {
    private func setNavigationBar() {
        
         
         navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
         backBtn.setImage(UIImage(named: "back_black"), for: .normal)
         backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
         
         
         titleLabel.textColor = HexColor(DarkGrayColor)
         titleLabel.textAlignment = .center
         titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
         titleLabel.text = "レビュー"
         navigationItem.titleView = titleLabel
         
     }
    
    private func refreshUI() {
        if scriptCommentModel != nil {
            if scriptCommentModel?.content != nil {
                textView?.text = scriptCommentModel?.content!
            }
            
            if scriptCommentModel?.leak != nil {
                if scriptCommentModel?.leak == 1 {
                    tagButton?.isSelected = true
                } else {
                    tagButton?.isSelected = false
                }
            }
            if scriptCommentModel?.star != nil {
                starView?.newCount = CGFloat((scriptCommentModel?.star)!)
            }
        }
    }
    
    private func setUI() {
        if nameLabel == nil {
            nameLabel = UILabel()
            nameLabel?.textColor = HexColor(DarkGrayColor)
            nameLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            nameLabel?.textAlignment = .center
            self.view.addSubview(nameLabel!)
            
            nameLabel?.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(NAVIGATION_BAR_HEIGHT + 20)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(27)
            })
            nameLabel?.text = scriptName
            
        }
        
        if starView == nil {
            if starView == nil {
                let x = (FULL_SCREEN_WIDTH - 165) * 0.5
                starView = StarView(count: 0, lineSpace: 0, fullImgName: "pinglun_pic_01", halfImgName: "pinglun_pic_03", zeroImgName: "pinglun_pic_02", sizeWidth: 33.0, sizeHeight: 33.0, frame: CGRect(x: x, y: NAVIGATION_BAR_HEIGHT + 58, width: 165, height: 33), isEdit: false)
                self.view.addSubview(starView!)
            }
            
            switch fromType {
            case .gamePlay:
                break
            case .scriptLog:
                commentFindFunc()
            default:
                break
            }
        }
        
        if textBgView == nil {
            textBgView = UIView()
            textBgView?.layer.cornerRadius = 10
            textBgView?.layer.masksToBounds = true
            self.view.addSubview(textBgView!)
            textBgView?.backgroundColor = HexColor("#F5F5F5")
            textBgView?.snp.makeConstraints { (make) in
                make.top.equalTo(starView!.snp_bottom).offset(17)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.height.equalTo(200)
            }
        }

        if textView == nil {
            textView = EWTextView()
            textView?.backgroundColor = UIColor.clear
            textView?.placeHolder = "（任意）感想を記入しましょう。"
            textView?.font = UIFont.systemFont(ofSize: 12)
            textView?.textColor = HexColor(DarkGrayColor)
            textView?.delegate = self
            textView?.returnKeyType = .done
            textBgView?.addSubview(textView!)
            textView?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(17)
                make.right.equalToSuperview().offset(-17)
                make.top.equalToSuperview()
                make.height.equalTo(200)
            })
        }


        if tagButton == nil {
            tagButton = UIButton()
            tagButton?.createButton(style: .left, spacing: 3, imageName: "pic_04", title: "ネタバレあり", cornerRadius: 0, color: "#ffffff")
            tagButton?.setTitleColor(HexColor(DarkGrayColor), for: .normal)
            tagButton?.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            tagButton?.setImage(UIImage(named: "pic_04"), for: .normal)
            tagButton?.setImage(UIImage(named: "pic_04_check"), for: .selected)
            tagButton?.isSelected = false
            tagButton?.addTarget(self, action: #selector(tagButtonAction(button:)), for: .touchUpInside)
            self.view.addSubview(tagButton!)
            tagButton?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.width.equalTo(90)
                make.top.equalTo(textBgView!.snp_bottom).offset(10)
                make.height.equalTo(25)
            })
        }
        
        

        
        
        
        if confirmBtn == nil {
            confirmBtn = UIButton()
            confirmBtn?.setBackgroundImage(UIImage(named: "button_bg"), for: .normal)
            confirmBtn?.setTitle("提出", for: .normal)
            confirmBtn?.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
            self.view.addSubview(confirmBtn!)
            confirmBtn?.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-12)
                } else {
                    make.bottom.equalToSuperview().offset(-12)
                }
            })
        }
        
        
        
    }
}

extension ScriptCommentsViewController {
    @objc func tagButtonAction(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected == true {
            tagButton?.isSelected = true
            leak = 1
        } else {
            tagButton?.isSelected = false
            leak = 0
        }
        
    }
    
    @objc func confirmBtnAction() {
        content = textView?.text
        star = starView?.getStar()
        
        if isEidt == true {
            editCommentRequest(script_id: self.scriptId!, leak: self.leak!, content: self.content, star: self.star!) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
                    showToastCenter(msg: resultDic["msg"] as! String)
                    self?.backBtnAction()
                }
            }
        } else {
            addCommentRequest(script_id: self.scriptId!, leak: self.leak!, content: self.content, star: self.star!) {[weak self] (result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                
                if resultDic["code"]!.isEqual(1) {
                    showToastCenter(msg: resultDic["msg"] as! String)
                    self?.backBtnAction()
                }
            }
        }
    }
    
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension ScriptCommentsViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }
    
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       if (text=="\n") {
           textView.resignFirstResponder()
           return false
       }
       return true
   }
}

extension ScriptCommentsViewController {
    
}
