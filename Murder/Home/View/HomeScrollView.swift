//
//  HomeScrollView.swift
//  Murder
//
//  Created by m.a.c on 2020/11/5.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class HomeScrollView: UIView {
    private lazy var headerCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal     //滚动方向
        layout.itemSize = CGSize(width: 177, height: 82)
        // 行间距
        layout.minimumLineSpacing = 13
        // 列间距
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 82), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var contentCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal     //滚动方向
        layout.itemSize = CGSize(width: 177, height: 82)
        // 行间距
        layout.minimumLineSpacing = 13
        // 列间距
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: 82), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        
    }()
    
    
    
}
