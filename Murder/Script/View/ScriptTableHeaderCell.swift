//
//  ScriptTableHeaderCell.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/30.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

let ScriptCollectionViewCellId = "ScriptTableHeaderCollectionViewCellId"

class ScriptTableHeaderCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var titleLabel: UILabel = UILabel()
    
    var selectIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var dataArr: Array<String> = [""]{
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        
           
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical     //滚动方向
        // 行间距
        layout.minimumLineSpacing = 0
        // 列间距
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0,  bottom: 0, right: 0)
        let collectionView = UICollectionView(frame:  CGRect(x: 60, y: 14, width: FULL_SCREEN_WIDTH-60, height: 21), collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "ScriptTableHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ScriptCollectionViewCellId)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}


extension ScriptTableHeaderCell {
    func setUI() {
        titleLabel.textColor = HexColor(DarkGrayColor)
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(45)
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        
        collectionView.reloadData()
    }
}


extension ScriptTableHeaderCell {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataArr[indexPath.item]
        let width = labelWidth(text: item, height: 21, fontSize: 12)
        return CGSize(width: width+20, height: 21)
    }
    
    //MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScriptCollectionViewCellId, for: indexPath) as! ScriptTableHeaderCollectionViewCell
        cell.titleLabel.text = dataArr[indexPath.item]
        if (selectIndexPath == indexPath) {
            cell.titleLabel.textColor = UIColor.white
            cell.commonView.backgroundColor = HexColor(MainColor)
            cell.layer.cornerRadius = 10
        } else {
            cell.titleLabel.textColor = HexColor(LightDarkGrayColor)
            cell.commonView.backgroundColor = UIColor.white
        }
         return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndexPath = indexPath
        collectionView.reloadData()
    }
    
}
