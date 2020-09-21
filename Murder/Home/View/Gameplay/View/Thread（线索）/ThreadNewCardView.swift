//
//  ThreadNewCardView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/10.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import SVProgressHUD



class ThreadNewCardView: UIView {
    
    private var contentView: UIView! = UIView()
    
    private var commonView: UIView! = UIView()
    
    // 图片
    private var imgView: UIImageView! = UIImageView(frame: CGRect.zero)
    // 公开
    private var publicBtn: UIButton! = UIButton(frame: CGRect.zero)
    // 可深入
    private var deepBtn: UIButton! = UIButton(frame: CGRect.zero)
    // 关闭
    private var cancelBtn: UIButton! = UIButton(frame: CGRect.zero)
    
    var script_place_id: Int?
        
    var room_id: Int?
        
    var script_node_id: Int?
        
    var script_clue_id: Int?
      
    // 列表
    var clueListModel :ClueListModel? {
        didSet {
            if clueListModel != nil {
                script_place_id = clueListModel?.scriptPlaceId
                script_clue_id = clueListModel?.childId
                if clueListModel?.attachment != nil {
                    showDetailView(attachmentStr: clueListModel!.attachment, isOpenNum: clueListModel!.isOpen, isGoingNum: clueListModel!.isGoing)
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
                    deepBtn.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    // 地图
    var clueResultModel: SearchClueResultModel? {
        didSet {
            if clueResultModel != nil {
                script_clue_id = clueResultModel?.childId
                if clueResultModel?.attachment != nil {
                    showDetailView(attachmentStr: clueResultModel!.attachment, isOpenNum: clueResultModel!.isOpen, isGoingNum: clueResultModel!.isGoing!)
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
                    deepBtn.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    
    // 深入按钮
    @objc func deepBtnAction(_ sender: Any) {
        if (clueResultModel != nil && clueResultModel?.isGoing == 1) || (clueListModel != nil && clueListModel?.isGoing == 1) { // 可深入
            SVProgressHUD.show(withStatus: "加载中")
            searchClueRequest(room_id: room_id!, script_place_id: script_place_id!, script_clue_id: script_clue_id, script_node_id: script_node_id!) {[weak self] (result, error) in
                SVProgressHUD.dismiss()
                if error != nil {
                    return
                }
                // 取到结果
                guard  let resultDic :[String : AnyObject] = result else { return }
                if resultDic["code"]!.isEqual(1) {
                    let data = resultDic["data"] as! [String : AnyObject]
                    let resultData = data["search_clue_result"] as! [String : AnyObject]
                    
                    let model = SearchClueResultModel(fromDictionary: resultData)
                    self?.clueResultModel = model
                    
                } else {
                    
                }
            }
        } else {
            self.removeFromSuperview()
        }
    }
    
    // 公开按钮
    @objc func publicBtnAction(_ sender: Any) {
        
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
        
    }
    
    // 关闭按钮
    @objc func cancelBtnAction(_ sender: Any) {
        contentView = nil
        commonView = nil
        removeFromSuperview()
    }
        
        

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonView.frame = self.bounds
        addSubview(commonView)
        
        commonView.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ThreadNewCardView {
    func getImageSize(_ url: String?) -> CGSize {
        guard let urlStr = url else {
            return CGSize.zero
        }
        let tempUrl = URL(string: urlStr)
        if tempUrl == nil {
            return CGSize(width: 0, height: 0)
        }
        let imageSourceRef = CGImageSourceCreateWithURL(tempUrl! as CFURL, nil)
        var width: CGFloat = 0
        var height: CGFloat = 0
        if let imageSRef = imageSourceRef {
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSRef, 0, nil)
            if let imageP = imageProperties {
                let imageDict = imageP as Dictionary
                width = imageDict[kCGImagePropertyPixelWidth] as! CGFloat
                height = imageDict[kCGImagePropertyPixelHeight] as! CGFloat
            }
        }

        return CGSize(width: width, height: height)
    }
}

extension ThreadNewCardView {
    private func showDetailView(attachmentStr: String?, isOpenNum: Int?, isGoingNum: Int?) {
        

        let attachment = attachmentStr
        let isOpen = isOpenNum
        let isGoing = isGoingNum
        
        var imgSize = CGSize()
        let size = getImageSize(attachment!)
        if size.height != 0, size.width != 0 {
            if size.width >= FULL_SCREEN_WIDTH {
                imgSize.width = FULL_SCREEN_WIDTH
                let scale = FULL_SCREEN_WIDTH / size.width
                imgSize.height = size.height * scale
                
            } else if (size.width <= 300.0) {
                imgSize.width = 300.0
                let scale = 300.0 / size.width
                imgSize.height = size.height * scale
 
            } else {
                
                imgSize = size
                
            }
            
            
             var space =  CGFloat(20 + 44 + 33 + 40)
               if isOpen == 1, isGoing == 0 { // 两个都不显示
                   space = CGFloat(10 + 33 + 40)
                   var imgHeight = imgSize.height + space
                   if imgHeight >= FULL_SCREEN_HEIGHT {
                       imgHeight = CGFloat(Int(FULL_SCREEN_HEIGHT - CGFloat(space)))
                       let heightScale = imgHeight / imgSize.height
                       imgSize.width = imgSize.width * heightScale
                       imgSize.height = imgHeight
                   }

               } else  { // 显示一个 或 两个
                   space = CGFloat(20 + 33 + 44 + 40)
                   var imgHeight = imgSize.height + space
                   if imgHeight >= FULL_SCREEN_HEIGHT {
                       imgHeight = CGFloat(Int(FULL_SCREEN_HEIGHT - CGFloat(space)))
                       let heightScale = imgHeight / imgSize.height
                       imgSize.width = imgSize.width * heightScale
                       imgSize.height = imgHeight
                   }
                   
               }
            
            Log(size)
            Log(imgSize)
            
            // isgoing  1 显示 0 不显示
            // isopen 0显示 1不显示？
            var top = 0.0
            var left = 0.0
            
            top = Double((FULL_SCREEN_HEIGHT-imgSize.height - 44 - 10 - 10 - 33) * 0.5)
            left = Double(Float(FULL_SCREEN_WIDTH - imgSize.width) * 0.5)
            
            if isOpen == 1, isGoing == 0  { // 无按钮
                publicBtn.isHidden = true
                deepBtn.isHidden = true
                
                top = Double((FULL_SCREEN_HEIGHT-imgSize.height - 10 - 33) * 0.5)
                left = Double((FULL_SCREEN_WIDTH - imgSize.width) * 0.5)
                
                contentView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(top)
                    make.bottom.equalToSuperview().offset(-top)
                    make.left.equalToSuperview().offset(left)
                    make.right.equalToSuperview().offset(-left)
                    
                }
                
                imgView.snp.makeConstraints { (make) in
                    make.width.equalTo(imgSize.width)
                    make.height.equalTo(imgSize.height)
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                }
                
                imgView.setImageWith(URL(string: attachment!))
                imgView.size = imgSize
                imgView.sizeToFit()
                
                cancelBtn.snp.makeConstraints { (make) in
                    make.width.height.equalTo(33)
                    make.top.equalTo(imgView.snp_bottom).offset(10)
                    make.centerX.equalToSuperview()
                }
                
                
            } else if isOpen! == 0,isGoing! == 1 { // 两个都显示
                publicBtn.isHidden = false
                deepBtn.isHidden = false

                contentView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(top)
                    make.bottom.equalToSuperview().offset(-top)
                    make.left.equalToSuperview().offset(left)
                    make.right.equalToSuperview().offset(-left)
                }
                
                imgView.snp.makeConstraints { (make) in
                    make.width.equalTo(imgSize.width)
                    make.height.equalTo(imgSize.height)
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                }
                
                imgView.setImageWith(URL(string: attachment!))
                imgView.size = imgSize
                imgView.sizeToFit()
                
                let space = 2.0*left + 22*2.0 + 15.0
                let width = (Double(FULL_SCREEN_WIDTH) - space) * 0.5
                publicBtn.snp.makeConstraints { (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(44)
                    make.top.equalTo(imgView.snp_bottom).offset(10)
                    make.left.equalToSuperview().offset(22)
                }
                
                deepBtn.snp.makeConstraints { (make) in
                    make.width.equalTo(width)
                    make.height.equalTo(44)
                    make.top.equalTo(imgView.snp_bottom).offset(10)
                    make.left.equalTo(publicBtn.snp_right).offset(15)
                }
                
                cancelBtn.snp.makeConstraints { (make) in
                    make.width.height.equalTo(33)
                    make.top.equalTo(deepBtn.snp_bottom).offset(10)
                    make.centerX.equalToSuperview()
                }
                
            } else {
                left = Double(Float(FULL_SCREEN_WIDTH - imgSize.width) * 0.5)
                contentView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(top)
                    make.bottom.equalToSuperview().offset(-top)
                    make.left.equalToSuperview().offset(left)
                    make.right.equalToSuperview().offset(-left)
                }
                
                imgView.snp.makeConstraints { (make) in
                    make.width.equalTo(imgSize.width)
                    make.height.equalTo(imgSize.height)
                    make.top.equalToSuperview()
                    make.left.equalToSuperview()
                }
                
                
                imgView.setImageWith(URL(string:attachment!))
                imgView.size = imgSize
                imgView.sizeToFit()
                
                let space = 22.0
                
                if isOpen! == 0 {
                    deepBtn.isHidden = true
                    publicBtn.snp.makeConstraints { (make) in
                        make.height.equalTo(44)
                        make.top.equalTo(imgView.snp_bottom).offset(10)
                        make.left.equalToSuperview().offset(space)
                        make.right.equalToSuperview().offset(-space)
                    }
                    cancelBtn.snp.makeConstraints { (make) in
                        make.width.height.equalTo(33)
                        make.top.equalTo(publicBtn.snp_bottom).offset(10)
                        make.centerX.equalToSuperview()
                    }
                }
                
                if isGoing! == 1 {
                    publicBtn.isHidden = true
                    deepBtn.snp.makeConstraints { (make) in
                        make.height.equalTo(44)
                        make.top.equalTo(imgView.snp_bottom).offset(10)
                        make.left.equalToSuperview().offset(space)
                        make.right.equalToSuperview().offset(-space)

                    }
                    
                    cancelBtn.snp.makeConstraints { (make) in
                        make.width.height.equalTo(33)
                        make.top.equalTo(deepBtn.snp_bottom).offset(10)
                        make.centerX.equalToSuperview()
                    }
                }
            }
            contentView.layoutIfNeeded()
            contentView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight,UIRectCorner.bottomLeft,UIRectCorner.bottomRight], radii: 15)

            imgView.layoutIfNeeded()
            imgView.viewWithCorner(byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], radii: 15)
        }
    }
    
    //MARK:- 设置UI
    private func setUI() {
        self.backgroundColor = HexColor(hex: "#020202", alpha: 0.5)
        


        
        if contentView == nil {
            contentView = UIView()
        }
        
        if commonView == nil {
            commonView = UIView()
        }
        
        if imgView == nil {
            imgView = UIImageView(frame: CGRect.zero)
        }
        
        if publicBtn == nil {
            publicBtn = UIButton(frame: CGRect.zero)
        }
        
        if deepBtn == nil {
            deepBtn = UIButton(frame: CGRect.zero)
        }
        
        if cancelBtn == nil {
            cancelBtn = UIButton(frame: CGRect.zero)
        }
        
        
        contentView.backgroundColor = UIColor.white
        commonView.addSubview(contentView)
        
        
        contentView.addSubview(imgView)

        contentView.addSubview(publicBtn)
        publicBtn.layer.cornerRadius = 22
        publicBtn.layer.borderColor = HexColor(MainColor).cgColor
        publicBtn.layer.borderWidth = 0.5
        publicBtn.setTitleColor(HexColor(MainColor), for: .normal)
        publicBtn.setTitle("公開", for: .normal)
        publicBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        publicBtn.addTarget(self, action: #selector(publicBtnAction(_:)), for: .touchUpInside)

        contentView.addSubview(deepBtn)
        deepBtn.layer.cornerRadius = 22
        deepBtn.layer.borderColor = HexColor(MainColor).cgColor
        deepBtn.layer.borderWidth = 0.5
        deepBtn.setTitleColor(HexColor(MainColor), for: .normal)
        deepBtn.setTitle("深くへ調査", for: .normal)
        deepBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        deepBtn.addTarget(self, action: #selector(deepBtnAction(_:)), for: .touchUpInside)

        contentView.addSubview(cancelBtn)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        cancelBtn.setImage(UIImage(named: "black_cancel"), for: .normal)
    }
}




