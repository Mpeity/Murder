//
//  ContributeWebViewController.swift
//  Murder
//
//  Created by m.a.c on 2020/9/11.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit
import WebKit

class ContributeWebViewController: UIViewController, WKNavigationDelegate{
//    var webView : WKWebView!
    
    // 返回上一层按钮
    private var backBtn: UIButton = UIButton()
    
    var webView = WKWebView()
    
    
    var urlString: String? {
        didSet {
            let urlRequest = URLRequest(url: URL(string: urlString!)!)
            webView.load(urlRequest)
        }
    }
    
    var loadType : UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "投稿について"
        
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
        
       
        // 加载 url
        let urlRequest = URLRequest(url: URL(string: "http://m.madami.ltd/nd.jsp?mid=302&id=4&groupId=0")!)
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
