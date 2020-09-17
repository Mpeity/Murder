//
//  UserAgreementViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class UserAgreementViewController: UIViewController {
    
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ユーザープロトコル"
        
        setNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    private func setNavigationBar() {
              
          navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
          backBtn.setImage(UIImage(named: "back_black"), for: .normal)
          backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)

      }
      
      //MARK: - 返回按钮
      @objc func backBtnAction() {
          self.navigationController?.popViewController(animated: true)
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
