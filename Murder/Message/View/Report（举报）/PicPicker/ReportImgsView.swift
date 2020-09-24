//
//  ReportImgsView.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin : CGFloat = 15

class ReportImgsView: UIView,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- 定义属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var titleLabe: UILabel = UILabel()
    
    private lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        // 横向滚动
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 68, height: 68)
        // 列间距
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 22, width: FULL_SCREEN_WIDTH, height: 68), collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        // 设置coectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: 0, left: edgeMargin, bottom: 0, right: edgeMargin)
        
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension ReportImgsView {
    private func setUI() {
        let choiceTipLabel = UILabel()
        choiceTipLabel.text = "写真追加"
        choiceTipLabel.textColor = HexColor("#333333")
        choiceTipLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(choiceTipLabel)
        
        choiceTipLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(15)
            make.width.equalTo(200)
        }
        
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ReportImgsView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath as IndexPath) as! PicPickerViewCell
        
        // 2.给cell设置数据
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
    
}
