//
//  AboutUsViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    
    // 标题
     private var titleLabel: UILabel = UILabel()
     // 返回上一层按钮
     private var backBtn: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tipLabel.textColor = HexColor(DarkGrayColor)
        levelLabel.textColor = HexColor(LightGrayColor)
        
        setNavigationBar()
    }
    
    
    private func setNavigationBar() {
         
         navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
         backBtn.setImage(UIImage(named: "back_black"), for: .normal)
         backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
         
         
         titleLabel.textColor = HexColor(DarkGrayColor)
         titleLabel.textAlignment = .center
         titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
         titleLabel.text = "バージョン"
         navigationItem.titleView = titleLabel
         
     }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AboutUsViewController {
    //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
      }
}

