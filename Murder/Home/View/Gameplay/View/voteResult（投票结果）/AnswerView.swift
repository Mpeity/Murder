//
//  AnswerView.swift
//  Murder
//
//  Created by m.a.c on 2020/8/4.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let VoteAnswerCellId = "VoteAnswerCellId"
class AnswerView: UIView {
    
    var trueAnswers : [TrueAnswerModel]? {
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
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH-100, height: 25), collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "VoteAnswerCell", bundle: nil), forCellWithReuseIdentifier: VoteAnswerCellId)
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

extension AnswerView {
    private func setUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
    }
}



extension AnswerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = trueAnswers![indexPath.item]
        
        let width = labelWidth(text: item.answerTitle!, height: 25, fontSize: 15)
        return CGSize(width: width+20+25+20, height: 25)
    }
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trueAnswers!.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoteAnswerCellId, for: indexPath) as! VoteAnswerCell
        let item = trueAnswers![indexPath.item]
        cell.itemModel = item
        return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
    }
    

    
      
}

