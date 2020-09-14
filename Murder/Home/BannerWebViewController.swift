//
//  BannerWebViewController.swift
//  Murder
//
//  Created by 马滕亚 on 2020/9/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import WebKit

class BannerWebViewController: UIViewController, WKNavigationDelegate{
//    var webView : WKWebView!
    
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    
    var webView = WKWebView()
    
    var bannerModel: HomeBannerModel? {
        didSet {
            
            guard let bannerModel = bannerModel else {
                return
            }
            if bannerModel.datas != nil {
                // 加载 url
                let urlString = bannerModel.datas!
                let urlRequest = URLRequest(url: URL(string: urlString)!)
                webView.load(urlRequest)
            }
            
        }
    }
    
    var urlString: String? {
        didSet {
//            let urlRequest = URLRequest(url: URL(string: urlString!)!)
//            webView.load(urlRequest)
        }
    }
    
    var loadType : UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        // 允许右滑返回
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        view.addSubview(webView)
        
       
        let urlRequest = URLRequest(url: URL(string: urlString!)!)
        webView.load(urlRequest)
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
        
    
}
