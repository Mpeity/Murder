//
//  MineScriptViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/10/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import MJRefresh

private let Page_Size = 15


private let MineScriptCellId = "MineScriptCell"

class MineScriptViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // 标题
     private var titleLabel: UILabel = UILabel()
     // 返回上一层按钮
     private var backBtn: UIButton = UIButton()
    
    private var page_no = 1
    
    private var mineScriptModel: MineScriptModel?

    
    private lazy var collectionView: UICollectionView = {

        let itemWidth = 103.0
        let itemHeight = 181.0
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = (FULL_SCREEN_WIDTH - 30 - 3*CGFloat(itemWidth)) * 0.5
        layout.minimumLineSpacing = 20
        
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
        loadRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
        setupFooterView()
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadRefresh))
        header?.backgroundColor = UIColor.white
        header?.lastUpdatedTimeLabel.isHidden = true  // 隐藏时间
        header?.stateLabel.isHidden = true // 隐藏文字
        header?.isAutomaticallyChangeAlpha = true //自动更改透明度
        
        // 设置tableview的header
        collectionView.mj_header = header
        
        // 进入刷新状态
        collectionView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
//        myTableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
//        //如果提醒他没有更多的数据了
//        myTableView.mj_footer.endRefreshingWithNoMoreData()
        
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        footer?.setTitle("", for: .idle)
        footer?.setTitle("ローディング中...", for: .refreshing)
        footer?.setTitle("~ 以上です ~", for: .noMoreData)
        footer?.stateLabel.font = UIFont.systemFont(ofSize: 12)
        footer?.stateLabel.textColor = HexColor("#999999")
        collectionView.mj_footer = footer
    }
}

extension MineScriptViewController {
    
    @objc private func loadMore() {
        page_no += 1
        loadScriptList()
    }
    
    @objc private func loadRefresh() {
        page_no = 1
        loadScriptList()
    }
    
    private func loadScriptList() {
        myScriptListRequest(page_no: page_no, page_size: Page_Size) {[weak self] (result, error) in
            
            if error != nil {
                self?.collectionView.mj_header.endRefreshing()
                self?.collectionView.mj_footer.endRefreshing()
                return
            }
            

            
            // 取到结果
            guard  let resultDic :[String : AnyObject] = result else { return }
            
            if resultDic["code"]!.isEqual(1) {
                let data = resultDic["data"] as! [String : AnyObject]
                let model = MineScriptModel(fromDictionary: data)

                if self?.page_no == 1 {
                    self?.mineScriptModel = model
                } else {
                    self?.mineScriptModel?.list?.append(contentsOf: model.list!)
                }
                self?.collectionView.reloadData()


                if model.list?.count ?? 0 < 15 { // 最后一页
                    //如果提醒他没有更多的数据了
                    self?.collectionView.mj_header.endRefreshing()
                    self?.collectionView.mj_footer.endRefreshing()
                    
                    if self?.page_no != 1 {
                        self?.collectionView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    return
                }
                
                self?.collectionView.mj_header.endRefreshing()
                self?.collectionView.mj_footer.endRefreshing()
                
            } else {
                self?.collectionView.mj_header.endRefreshing()
                self?.collectionView.mj_footer.endRefreshing()
            }
        }
    }
}


extension MineScriptViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mineScriptModel?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MineScriptCellId, for: indexPath as IndexPath) as! MineScriptCell
        let itemModel = mineScriptModel?.list?[indexPath.item]
        cell.itemModel = itemModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemModel = mineScriptModel?.list?[indexPath.item]
        let vc = ScriptDetailsViewController()
        vc.script_id = itemModel?.scriptId
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension MineScriptViewController {
    //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
      }
}

