//
//  WD_WebVC.swift
//  WineDealer
//
//  Created by 米翊米 on 2017/1/18.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKNavigationDelegate {
    var urlString:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        navigationBarTintColor()
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviViewH))
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(webView)
        if urlString == nil {
            navigationItem.title = "免责声明"
            
            let path = Bundle.main.path(forResource: "desc", ofType:"html")
            let urlStr = URL.init(fileURLWithPath: path!)
            let data = try! Data(contentsOf: urlStr)
            
            if let htmlStr = String(data: data, encoding: .utf8) {
                webView.loadHTMLString(htmlStr, baseURL: nil)
            }
        } else {
            let path = Bundle.main.path(forResource: "pro", ofType:"html")
            let urlStr = URL.init(fileURLWithPath: path!)
            let data = try! Data(contentsOf: urlStr)
            
            if let htmlStr = String(data: data, encoding: .utf8) {
                webView.loadHTMLString(htmlStr, baseURL: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideHUD()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideHUD()
    }

}
