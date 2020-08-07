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

        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController:UIViewController, animated:Bool) {
        // 自定义导航栏的样式
        
        // 设置导航栏背景图片
//        navigationBar.setBackgroundImage(<#T##backgroundImage: UIImage?##UIImage?#>, for: <#T##UIBarMetrics#>)
        // 设置标题颜色
        navigationBar.tintColor = HexColor("#333333")
        
        // 设置标题字号
//        navigationBar.titleTextAttributes
//        if children.count>0{
//            viewController.hidesBottomBarWhenPushed = true
//            let leftItem = UIBarButtonItem(image: UIImage(named: "back_black"), style: .plain, target: self, action: #selector(backBtnAction))
//            navigationController?.navigationItem.leftBarButtonItem = leftItem
//
//        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    @objc func backBtnAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
//    //设置导航条背景图片
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg"] forBarMetrics:UIBarMetricsDefault];
//    //设置标题颜色
//        self.navigationBar.tintColor = [UIColor whiteColor];
//    //通过Attributes设置标题字体颜色字号
//        [self.navigationBar setTitleTextAttributes:@{@"NSForegroundColorAttributeName":[UIColor whiteColor]}];
//        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//        textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//        textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
//        [self.navigationBar setTitleTextAttributes:textAttrs];
//
//    //如果是根控制器就不显示返回按钮
//        if (self.childViewControllers.count > 0) { // 非根控制器
//            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"button_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed)];
//            viewController.navigationItem.leftBarButtonItem = item;
//        }
//        [super pushViewController:viewController animated:animated];
//
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
