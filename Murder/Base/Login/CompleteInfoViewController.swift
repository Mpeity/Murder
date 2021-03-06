//
//  CompleteInfoViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/20.
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
    @IBOutlet weak var commonBtn: GradienButton!
    
    @IBOutlet weak var commonBtnWidth: NSLayoutConstraint!
    
    // 性别
    private var sex: String? = "0"
    // 头像
    private var file: String?
    
    
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
        photoBtn.layer.masksToBounds = true
        photoBtn.addTarget(self, action: #selector(photoBtnAction), for: .touchUpInside)
        
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textColor = HexColor(LightGrayColor)
        
        womanBtn.createButton(style: .left, spacing: 23, imageName: "logo_woman", title: "女の子", cornerRadius: 25, color: "#FFFFFF")
        womanBtn.layer.borderColor = HexColor("#CACACA").cgColor
        womanBtn.layer.borderWidth = 0.5
        womanBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        womanBtn.addTarget(self, action: #selector(womanBtnAction), for: .touchUpInside)
        womanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        manBtn.createButton(style: .left, spacing: 10, imageName: "logo_man", title: "男の子", cornerRadius: 25, color: "#FFFFFF")
        manBtn.layer.borderColor = HexColor("#CACACA").cgColor
        manBtn.layer.borderWidth = 0.5
        manBtn.setTitleColor(HexColor("#CACACA"), for: .normal)
        manBtn.addTarget(self, action: #selector(manBtnAction), for: .touchUpInside)
        manBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)

//        imageWithRenderingMode;:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal
        
        nicknameView.layer.cornerRadius = 25
        nicknameView.layer.borderWidth = 0.5
        nicknameView.layer.borderColor = HexColor("#CCCCCC").cgColor
        nicknameTextfield.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
        nicknameTextfield.delegate = self

        commonBtnWidth.constant = FULL_SCREEN_WIDTH - 37 * 2

        commonBtn.layoutIfNeeded()
//        commonBtn.gradientColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
        commonBtn.setOtherGradienButtonColor(start: "#CACACA", end: "#CACACA", cornerRadius: 25)
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.setTitle("スタット", for: .normal)
        commonBtn.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)
        commonBtn.isUserInteractionEnabled = false
        
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
        
        getInfo()
        
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
        getInfo()
    }
    
    //MARK:- 完善信息
    @objc func commonBtnAction() {
        if file != nil && nicknameTextfield.text != nil{
            editInfo(head: file!)
        }
    }
    
    func editInfo(head: String) {
        let nickname = nicknameTextfield.text!
        editInformation(nickname: String(nickname), head: head, sex: self.sex!) {[weak self] (result, error) in
            
            if error != nil {
                return
            }
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }

            if resultDic["code"]!.isEqual(1) { //修改成功
                // 将account对象设置到单例对象中
                UserAccountViewModel.shareInstance.account?.nickname = String(nickname)
                UserAccountViewModel.shareInstance.account?.head = String(head)
                // 首页
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            } else {
//                    showToastCenter(msg: "メールアドレスのフォーマットが正しくありません、再度入力してくさい")
            }
        }
    }
    
    
    private func getInfo() {
        if file != nil  && sex != nil && nicknameTextfield.text != nil && nicknameTextfield.text != "" {
            commonBtn.setOtherGradienButtonColor(start: "#3522F2", end: "#934BFE", cornerRadius: 25)
            commonBtn.isUserInteractionEnabled = true

        } else {
            commonBtn.setOtherGradienButtonColor(start: "#CACACA", end: "#CACACA", cornerRadius: 25)
        }
    }
    
    
    
    
}


extension CompleteInfoViewController {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if nicknameTextfield.text?.count != 0 {
            nicknameTextfield.textColor = HexColor(MainColor)
            nicknameView.layer.borderColor = HexColor(MainColor).cgColor
             getInfo()

        } else {
            nicknameView.layer.borderColor = HexColor("#CCCCCC").cgColor
        }
    }
    
//   func textFieldDidChangeSelection(_ textField: UITextField) {
//        if textField.text != nil {
//            getInfo()
//        }
//    }
    
    // 利用代理方法控制字符数量
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        let textLength = text.count + string.count - range.length

        return textLength<=15
    }
    


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        nicknameTextfield.becomeFirstResponder()
        nicknameTextfield.resignFirstResponder()
    }
}

//MARK:- 照片选择
extension CompleteInfoViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    // 通过rect，裁切图片
    func MCImageCrop(image: UIImage, toRect:CGRect) -> UIImage {
//        let imageRef = self.photoBtn?.cropping(to: toRect)
//        let image = UIImage.init(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        
        let rect = toRect
        let cgImageCorpped = image.cgImage?.cropping(to: rect)
        let imageCorpped = UIImage(cgImage: cgImageCorpped!)
        return imageCorpped
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        
//        let width = 130.0
//
//        let head = MCImageCrop(image: image, toRect: CGRect(x: (Double(FULL_SCREEN_WIDTH)-width)*0.5, y: (Double(FULL_SCREEN_HEIGHT)-width)*0.5, width: width, height: width))
        photoBtn.setImage(image, for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
        
        saveImagePath(image: image)
    }
    
    func saveImagePath(image: UIImage) {
        //将选择的图片保存到Document目录下
        var attachment_id = ""
        
        //先把图片转成NSData(这里压缩图片到0.5，图片过大会造成上传时间太久或失败)
        let data = image.jpegData(compressionQuality: 0.5)
        //Home目录
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents"
        //文件管理器
        let fileManager: FileManager = FileManager.default
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error {
            
            Log(error)
        }
        fileManager.createFile(atPath: (documentPath as NSString).appending("/image.png"), contents: data, attributes: nil)
        //得到选择后沙盒中图片的完整路径
        let filePath: String = String(format: "%@%@", documentPath, "/image.png")
        let newData = filePath.data(using: .utf8)
        //上传图片
        if (fileManager.fileExists(atPath: filePath)){
            //取得NSURL
            
            uploadImgae(imageData: data!,file: newData as AnyObject) { [weak self](result, error) in
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) { // 上传成功
                    let data = resultDic["data"] as! [String : AnyObject]
                    let resultData = data["result"] as! [String : AnyObject]
                    let pathStr = resultData["path"] as! String
                    attachment_id = resultData["attachment_id"] as! String
                    self?.file = attachment_id
                    
                    self?.getInfo()
                }

            }
        }
    }
}
