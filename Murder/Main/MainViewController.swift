//
//  MainViewController.swift
//  Murder
//
//  Created by mac on 2020/7/17.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    lazy var imageNames = ["home","script","message","script"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


}

extension MainViewController {
    private func setupTabbar() {
           for i in 0..<tabBar.items!.count {
               let item = tabBar.items![i]
               item.image = UIImage(named: imageNames[i])
               item.selectedImage = UIImage(named: imageNames[i]+"_highlighted")

           }
       }
}
