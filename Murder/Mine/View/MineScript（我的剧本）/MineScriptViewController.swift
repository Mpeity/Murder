//
//  MineScriptViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/10/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

private let MineScriptCellId = "MineScriptCell"

class MineScriptViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 标题
     private var titleLabel: UILabel = UILabel()
     // 返回上一层按钮
     private var backBtn: UIButton = UIButton()
    
    private lazy var collectionView: UICollectionView = {

        let itemWidth = 103
        let itemHeight = 180
        
        let layout = UICollectionViewFlowLayout()
        // 横向滚动
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        // 列间距
        layout.minimumInteritemSpacing = (FULL_SCREEN_WIDTH-30 - 3*CGFloat(itemWidth)) * 0.5
        let collectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: FULL_SCREEN_WIDTH, height: FULL_SCREEN_HEIGHT), collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "MineScriptCell", bundle: nil), forCellWithReuseIdentifier: MineScriptCellId)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        // 设置coectionView的内边距
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15 , bottom: 15, right: 15)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
    }

}

extension MineScriptViewController {
    
    private func setNavigationBar() {
         
         navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
         backBtn.setImage(UIImage(named: "back_black"), for: .normal)
         backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
         
         
         titleLabel.textColor = HexColor(DarkGrayColor)
         titleLabel.textAlignment = .center
         titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
         titleLabel.text = "マイシナリオ"
         navigationItem.titleView = titleLabel
         
     }
    private func setUI() {
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension MineScriptViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return images.count + 1
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MineScriptCellId, for: indexPath as IndexPath) as! MineScriptCell
        
        // 2.给cell设置数据
//        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
    
}

extension MineScriptViewController {
    //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
      }
}

