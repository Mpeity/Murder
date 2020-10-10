//
//  VoteCommonView.swift
//  Murder
//
//  Created by m.a.c on 2020/8/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let VoteCommonCellId = "VoteCommonCellId"

class VoteCommonView: UIView {
    
    var trueUsers : [TrueUserModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // 题目选项
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical     //滚动方向
        // 行间距
        layout.minimumLineSpacing = 0
        // 列间距
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0,  bottom: 0, right: 0)
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH-100, height: 66), collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "VoteCommonCell", bundle: nil), forCellWithReuseIdentifier: VoteCommonCellId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
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

extension VoteCommonView {
    private func setUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
    }
}



extension VoteCommonView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = trueUsers![indexPath.item]
        let width = labelWidth(text: item.name!, height: 21, fontSize: 12)
        return CGSize(width: 60, height: 66)
    }
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trueUsers!.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoteCommonCellId, for: indexPath) as! VoteCommonCell
        let item = trueUsers![indexPath.item]
        cell.itemModel = item
         return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
    }
    

    
      
}
