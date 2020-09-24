//
//  FriendReportViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/22.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SVProgressHUD


let FriendReportCellId = "FriendReportCellId"

class FriendReportViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var images : [UIImage] = [UIImage]()

    private var scrollView: UIScrollView!

    // 标题
    private var titleLabel: UILabel = UILabel()
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // 横向滚动
        layout.itemSize = CGSize(width: (FULL_SCREEN_WIDTH-30)*0.5, height: 27)
        // 行间距
        layout.minimumLineSpacing = 10
        // 列间距
        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: 12, left: 15,  bottom: 5, right: 15)
        
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 52, width: FULL_SCREEN_WIDTH, height: 118), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15,  bottom: 5, right: 15)
        collectionView.register(UINib(nibName: "FriendReportCell", bundle: nil), forCellWithReuseIdentifier: FriendReportCellId)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var reportTypeArr: Array<String>?
    
//    private var textView: EWTextView?
    private var textView: EWTextView?

    
    private var commonBtn: GradienButton?
    
    // 底部图片选择
    private var choiceImgView: ReportImgsView?
    
    
    
    var receive_id: Int?
    
    private var report_type: String?
    
    private var report_content: String?
    
    private var report_images: [Int]? = []
    
    private var selectIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        reportTypeArr = ["性的な内容","著作権侵害","違法な内容","広告・ステマ","人身攻撃","その他"]
        setNavigationBar()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)

        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotifications() {
        // 监听键盘的弹出
//        NotificationCenter.default.addObserver(self, selector: "keyboardWillChangeFrame:", name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 监听添加照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        // 监听删除照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick(note:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
    
    

}

extension FriendReportViewController {
    
}


extension FriendReportViewController {
    private func setNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        backBtn.setImage(UIImage(named: "back_black"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.text = "通報"
        navigationItem.titleView = titleLabel
    }
    
    private func setUI() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: NAVIGATION_BAR_HEIGHT, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT))
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        let imgView = UIImageView(frame: CGRect(x: 15, y: 14, width: 15, height: 12))
        imgView.image = UIImage(named: "report_icon")
        scrollView.addSubview(imgView)
        
        
        let titleLabel = UILabel(frame: CGRect(x: 36, y: 12, width: 300, height: 15))
        titleLabel.text = "通報する理由を以下から選んでください"
        titleLabel.textColor = HexColor("#9A9A9A")
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        scrollView.addSubview(titleLabel)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        scrollView.addSubview(collectionView)
        
        let textBgView = UIView(frame: CGRect(x: 15, y: 168, width: FULL_SCREEN_WIDTH-30, height: 200))
        textBgView.backgroundColor = HexColor("#F5F5F5")
        textBgView.layer.cornerRadius = 10
        textBgView.layer.masksToBounds = true
        
        scrollView.addSubview(textBgView)
        
        if textView == nil {
            textView = EWTextView(frame: CGRect(x: 15, y: 0, width: textBgView.width - 30, height: 200))
            textView?.backgroundColor = UIColor.clear
            textView?.font = UIFont.systemFont(ofSize: 12)
            textView?.textColor = HexColor(LightGrayColor)
            textView?.placeHolder = "通報する内容を出来るだけ詳しくご記入してください"
            textView?.delegate = self
            textView?.returnKeyType = .done
            textBgView.addSubview(textView!)
        }
        
        
        

        
        if choiceImgView == nil {
            choiceImgView = ReportImgsView(frame: CGRect(x: 0, y: 390, width: FULL_SCREEN_WIDTH, height: 90))
            choiceImgView?.backgroundColor = UIColor.white
            scrollView.addSubview(choiceImgView!)
        }
        
        if commonBtn == nil {
            commonBtn = GradienButton()
            commonBtn?.setTitle("通報", for: .normal)
            commonBtn?.setTitleColor(UIColor.white, for: .normal)
            commonBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            commonBtn?.layer.cornerRadius = 25
            commonBtn?.layer.masksToBounds = true
            commonBtn?.backgroundColor = HexColor(MainColor)
            commonBtn?.addTarget(self, action: #selector(commonBtnAction), for: .touchUpInside)
            self.view.addSubview(commonBtn!)
            commonBtn?.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-10-HOME_INDICATOR_HEIGHT)
                make.width.equalTo(FULL_SCREEN_WIDTH-30)
                make.height.equalTo(50)
            })
//            commonBtn?.setGradienButtonColor(start: "#934BFE", end: "#3623F2", cornerRadius: 25)

        }
        
    }
}

extension FriendReportViewController {
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reportTypeArr!.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendReportCellId, for: indexPath) as! FriendReportCell
        cell.titleLabel.text = reportTypeArr![indexPath.item]
        
        if (selectIndexPath == indexPath) {
            cell.isSelected = true
            cell.choiceBtn.isSelected = true
        } else {
            cell.isSelected = false
            cell.choiceBtn.isSelected = false
        }
         return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FriendReportCell
        if cell?.isSelected ?? false {
            cell?.choiceBtn.isSelected = true
        } else {
            cell?.choiceBtn.isSelected = false
        }
        selectIndexPath = indexPath
        collectionView.reloadData()
        report_type = reportTypeArr![indexPath.row]
    }
}


extension FriendReportViewController {
    //MARK: - 返回按钮
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 提交
    @objc func commonBtnAction() {
        
        if textView?.text == nil || textView?.text == "" {
            showToastCenter(msg: "通報する理由を以下から選んでください")
        }
        
        if report_type == nil || report_type != "" {
            showToastCenter(msg: "通報する内容を出来るだけ詳しくご記入してください")
        }
        
        if textView?.text != nil, textView?.text != "",  report_type != nil {
            SVProgressHUD.show()
            var reportImagesStr: String?
            if report_images != nil , report_images?.count != 0 {
                reportImagesStr = getJSONStringFromArray(array: report_images! as NSArray)
            } else {
                reportImagesStr = ""
            }
            report_content = textView?.text!
            friendReportRequest(report_id: receive_id!, report_type: report_type!, report_content: report_content!, report_images: reportImagesStr) { [weak self](result, error) in
                SVProgressHUD.dismiss()
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    showToastCenter(msg: resultDic["msg"] as! String)
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK:- 添加照片和删除照片的事件
extension FriendReportViewController {
    @objc private func addPhotoClick() {
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        // 2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        // 3.设置照片源
        ipc.sourceType = .photoLibrary
        
        // 4.设置代理
        ipc.delegate = self
        
        // 弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc private func removePhotoClick(note : NSNotification) {
        // 1.获取image对象
        guard let image = note.object as? UIImage else {
            return
        }
        // 2.获取image对象所在下标值
        guard let index = images.index(of: image) else {
            return
        }
        // 3.将图片从数组删除
        images.remove(at: index)
        // 4.重写赋值collectionView新的数组
        choiceImgView?.images = images
        if report_images != nil, report_images!.count > index{
            report_images?.remove(at: index)
        }
    }
}

// MARK:- UIImagePickerController的代理方法
extension FriendReportViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1.获取选中的照片
        let image = info[.originalImage] as! UIImage
        
        // 2.将选中的照片添加到数组中
        images.append(image)
        
        // 3.将数组赋值给collectionView,让collectionView自己去展示数据
        choiceImgView?.images = images
        
        // 4.退出选中照片控制器
        picker.dismiss(animated: true, completion: nil)
        
        saveImagePath(image: image)
    }
    
    private func saveImagePath(image: UIImage) {
        SVProgressHUD.show()

        //将选择的图片保存到Document目录下
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
            print(error)
        }
        fileManager.createFile(atPath: (documentPath as NSString).appending("/image.png"), contents: data, attributes: nil)
        //得到选择后沙盒中图片的完整路径
        let filePath: String = String(format: "%@%@", documentPath, "/image.png")
        let newData = filePath.data(using: .utf8)
        //上传图片
        if (fileManager.fileExists(atPath: filePath)){
            //取得NSURL
            uploadImgae(imageData: data!,file: newData as AnyObject) { [weak self](result, error) in
                SVProgressHUD.dismiss()

                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) { // 上传成功
                    let data = resultDic["data"] as! [String : AnyObject]
                    let resultData = data["result"] as! [String : AnyObject]
//                    let pathStr = resultData["path"] as! String
                    let attachment_id = resultData["attachment_id"] as! String
                    self?.report_images?.append(Int(attachment_id)!)
                }

            }
        }
    }

}

extension FriendReportViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }
    
   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       if (text=="\n") {
           textView.resignFirstResponder()
           return false
       }
       return true
   }
    
    
    
    
    
    @objc func keyboardWillChangeFrame(notif: Notification) {
        // 获取动画执行的时间
        let duration = notif.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 获取键盘最终Y值
        let endFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 计算工具栏距离底部的间距
        var margin = FULL_SCREEN_HEIGHT - y - HOME_INDICATOR_HEIGHT
    }

}

extension FriendReportViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        textView?.resignFirstResponder()
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView?.resignFirstResponder()
        self.view.endEditing(true)
    }
}


