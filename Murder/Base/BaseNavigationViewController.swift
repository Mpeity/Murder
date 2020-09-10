//
//  BaseNavigationViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/7/26.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = HexColor("#333333")
        navigationBar.barTintColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController:UIViewController, animated:Bool) {
        // 自定义导航栏的样式
        
        // 设置导航栏背景图片
//        navigationBar.setBackgroundImage(<#T##backgroundImage: UIImage?##UIImage?#>, for: <#T##UIBarMetrics#>)
        
        // 设置标题颜色
        
        
        // 设置标题字号
//        navigationBar.titleTextAttributes
        
        if children.count>0{
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    @objc func backBtnAction() {
        navigationController?.popViewController(animated: true)
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
