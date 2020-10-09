//
//  BaseNavigationViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/7/26.
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
        
//        if children.count>0{
//            viewController.hidesBottomBarWhenPushed = true
//        }
//        super.pushViewController(viewController, animated: animated)
        
        if self.viewControllers.count > 0 {
            if self.viewControllers.count == 1 {
                viewController.hidesBottomBarWhenPushed = true
            }
           
        } else {
            viewController.hidesBottomBarWhenPushed = false
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
