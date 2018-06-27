//
//  DetailViewController.swift
//  NextXiangJia
//  详情
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//  rootView向下平移状态栏的高度，可见空间高度为usableViewHeight

import UIKit
private let bottomBarH:CGFloat = 60//底部购买view高度
class DetailViewController: GoodDetailBaseViewController {
    var usableViewHeight:CGFloat?
    
    //MARK: - 懒加载
    
    lazy var webView: UIWebView = {
        let webView = UIWebView.init(frame: CGRect(x: 0, y: finalStatusBarH, width: self.view.frame.width, height: self.usableViewHeight!))
        webView.delegate = self
        //webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        return webView
    }()
    
    lazy var activity: UIActivityIndicatorView = {[unowned self] in
        //webView加载提示
        let activity = UIActivityIndicatorView()
        activity.center = webView.center
        activity.isHidden = true
        activity.activityIndicatorViewStyle = .gray
        return activity
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usableViewHeight = self.view.frame.height - finalStatusBarH - finalNavigationBarH - bottomBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0)
        webView.addSubview(activity)
        self.view.addSubview(webView)
        let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}

//遵守webView的协议
extension DetailViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.activity.isHidden = false
        self.activity.startAnimating()
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activity.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activity.stopAnimating()
    }
}
