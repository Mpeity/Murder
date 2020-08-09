//
//  CompleteInfoViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class CompleteInfoViewController: UIViewController, UITextFieldDelegate  {

    // 头像按钮
    @IBOutlet weak var photoBtn: UIButton!
    
    // tip
    @IBOutlet weak var tipLabel: UILabel!
    
    // 女子
    @IBOutlet weak var womanBtn: UIButton!
    
    // 男子
    @IBOutlet weak var manBtn: UIButton!
    // 昵称视图
    @IBOutlet weak var nicknameView: UIView!
    // 昵称输入
    @IBOutlet weak var nicknameTextfield: UITextField!
    // 立即体验
    @IBOutlet weak var commonBtn: UIButton!
    // 性别
    var sex: String?
    // 头像
    var file: String?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "情報を充実させる"
        setupNavigaitonBar()
        setUI()

        
    }



}


extension CompleteInfoViewController {
    
    private func setUI() {
        photoBtn.layer.cornerRadius = 62.5
        photoBtn.addTarget(self, action: #selector(photoBtnAction), for: .touchUpInside)
        
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textColor = HexColor(LightGrayColor)
        
        womanBtn.createButton(style: .left, spacing: 23, imageName: "logo_woman", title: "女の子", cornerRadius: 25, color: "#FFFFFF")
        womanBtn.layer.borderColor = HexColor("#CACACA").cgColor
        womanBtn.layer.borderWidth = 0.5
        womanBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        womanBtn.addTarget(self, action: #selector(womanBtnAction), for: .touchUpInside)
        
        manBtn.createButton(style: .left, spacing: 10, imageName: "logo_man", title: "男の子", cornerRadius: 25, color: "#FFFFFF")
        manBtn.layer.borderColor = HexColor("#CACACA").cgColor
        manBtn.layer.borderWidth = 0.5
        manBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        manBtn.addTarget(self, action: #selector(manBtnAction), for: .touchUpInside)
//        imageWithRenderingMode;:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal
        
        nicknameView.layer.cornerRadius = 25
        nicknameView.layer.borderWidth = 0.5
        nicknameView.layer.borderColor = HexColor("#CCCCCC").cgColor
        nicknameTextfield.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)

        commonBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.setTitle("スタット", for: .normal)
        commonBtn.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)
        
    }
    
    private func setupNavigaitonBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(leftBtnAction))
    }
}

extension CompleteInfoViewController {
    @objc func leftBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- 头像选择
    @objc func photoBtnAction() {
        // 选择照片
        
//        head
        
        // 1、判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        // 2、创建照片选择控制器
        let ipc = UIImagePickerController()
        // 3、设置照片源
        ipc.sourceType = .photoLibrary
        // 4、设置代理
        ipc.delegate = self
        // 弹出选择照片的控制
        present(ipc, animated: true, completion: nil)
    }
    
    //MARK:- 女 womanBtn
    @objc func womanBtnAction() {
        sex = "2"

        womanBtn.setTitleColor(HexColor(MainColor), for: .normal)
        manBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        womanBtn.layer.borderColor = HexColor(MainColor).cgColor
        manBtn.layer.borderColor = HexColor("#CACACA").cgColor
        womanBtn.setImage(UIImage(named: "logo_woman_selected"), for: .normal)
        manBtn.setImage(UIImage(named: "logo_man"), for: .normal)
        
    }
    
    //MARK:- 男manBtn
    @objc func manBtnAction() {
        sex = "1"

        womanBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        womanBtn.layer.borderColor = HexColor("#CACACA").cgColor
        womanBtn.setImage(UIImage(named: "logo_woman"), for: .normal)

        manBtn.setTitleColor(HexColor(MainColor), for: .normal)
        manBtn.layer.borderColor = HexColor(MainColor).cgColor
        manBtn.setImage(UIImage(named: "logo_man_selected"), for: .normal)
    }
    
    //MARK:- 完善信息
    @objc func commonBtnAction() {
        
        
        if file!.isEmptyString {
            showToastCenter(msg: "")
        }
        
        // 图片选择完毕 上传图片
        uploadImgae(file: file!) {[weak self] (result, error) in
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let dataResult = data["result"] as! [String : AnyObject]
                let path = dataResult["path"]
                let head = dataResult["attachment_id"]
                
                self?.editInfo(head: head as! String)
            }
        }
        
        
        
        
        
    }
    
    func editInfo(head: String) {
        let nickname = nicknameTextfield.text!
        editInformation(key: "", nickname: String(nickname), head: head, sex: self.sex!) {[weak self] (result, error) in
            
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            
        }
    }
    
    
    
    
}


extension CompleteInfoViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if nicknameTextfield.text?.count != 0 {
            nicknameTextfield.textColor = HexColor(MainColor)
            nicknameView.layer.borderColor = HexColor(MainColor).cgColor

        } else {
            nicknameView.layer.borderColor = HexColor("#CCCCCC").cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        nicknameTextfield.becomeFirstResponder()
        nicknameTextfield.resignFirstResponder()
    }
}

//MARK:- 照片选择
extension CompleteInfoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        photoBtn.setImage(image, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
