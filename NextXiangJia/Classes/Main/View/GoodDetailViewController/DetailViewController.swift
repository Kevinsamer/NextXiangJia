//
//  DetailViewController.swift
//  NextXiangJia
//  详情
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//  rootView向下平移状态栏的高度，可见空间高度为usableViewHeight

import UIKit
import WebKit
private let bottomBarH:CGFloat = 60//底部购买view高度
class DetailViewController: GoodDetailBaseViewController {
    var usableViewHeight:CGFloat?
    
    override var goodsInfo: GoodInfo? {
        didSet{
            
        }
    }
    
    //MARK: - 懒加载
    
//    lazy var webView: UIWebView = {
//        let webView = UIWebView.init(frame: CGRect(x: 0, y: finalStatusBarH, width: self.view.frame.width, height: self.usableViewHeight!))
//        webView.delegate = self
//        //webView.scrollView.delegate = self
//        webView.backgroundColor = UIColor.white
//        return webView
//    }()
    
    lazy var wkWebView: WKWebView = {
        var config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        let webView = WKWebView(frame: CGRect(x: 0, y: finalStatusBarH, width: self.view.frame.width, height: self.usableViewHeight!), configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = UIColor.white
        return webView
    }()
    
    lazy var webProgressView: UIProgressView = {
        let progress = UIProgressView(frame: CGRect(x: 0, y: 0, width: wkWebView.frame.width, height: 10))
        progress.progressViewStyle = UIProgressViewStyle.bar
        return progress
    }()
    
    lazy var webAlphaView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: wkWebView.frame.width, height: wkWebView.frame.height))
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    lazy var activity: UIActivityIndicatorView = {[unowned self] in
        //webView加载提示
        let activity = UIActivityIndicatorView()
        activity.center = wkWebView.center
        activity.isHidden = true
        activity.activityIndicatorViewStyle = .gray
        return activity
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usableViewHeight = self.view.frame.height - finalStatusBarH - finalNavigationBarH - bottomBarH - (UIDevice.current.isX() ? IphonexHomeIndicatorH : 0)
        wkWebView.addSubview(activity)
        wkWebView.addSubview(webAlphaView)
        wkWebView.addSubview(webProgressView)
//        self.view.addSubview(webView)
        self.view.addSubview(wkWebView)
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        //此处有显示图文详情的链接则直接使用，若没有提供链接，则使用注释的request来加载手机端商品详情页面，通过js隐藏不需要的元素来展示图文详情
        //let request = URLRequest(url: URL(string: BASE_URL + "site/products/id/\((self.goodsInfo?.goods_id) ?? 0)")!)
        let request = URLRequest(url: URL(string: GOODWEBDETAIL_URL + "\(self.goodsInfo?.goods_id ?? 0)")!)
        self.wkWebView.load(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    deinit {
        if self.usableViewHeight != nil {
            self.wkWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.webProgressView.progress = Float(self.wkWebView.estimatedProgress)
            if self.wkWebView.estimatedProgress == 1.0 {
                wkJS()
                //预留出执行js语句的时间，js语句运行结束后延迟0.4s显示webview
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                    //                    self.wkWebView.isHidden = false
                    self.activity.stopAnimating()
                    self.webProgressView.removeFromSuperview()
                    self.webAlphaView.removeFromSuperview()
                })
            }
        }
    }
    
    //js脚本，调整界面内容，只显示图文详情
    private func wkJS(){
        //隐藏商品信息
        wkWebView.evaluateJavaScript("document.getElementsByClassName('goods_info')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏轮播图
        wkWebView.evaluateJavaScript("document.getElementsByClassName('goods_photo')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏客服button
        wkWebView.evaluateJavaScript("document.getElementsByClassName('layer-3')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏tabbar
        wkWebView.evaluateJavaScript("document.getElementById('layout_bottom')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        wkWebView.evaluateJavaScript("document.getElementsByClassName('btn_bottom_goods')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏商品详情评论咨询按钮
        wkWebView.evaluateJavaScript("document.getElementsByClassName('pro_tab')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        //隐藏顶部导航栏
        wkWebView.evaluateJavaScript("document.getElementsByClassName('header fixed top z2')[0].style.display='none'", completionHandler: { (nullAble, errors) in
            //            print(errors)
        })
        
    }
    
}

//MARK: - 遵守WKWebView协议
extension DetailViewController : WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activity.isHidden = false
        self.activity.startAnimating()
        //开始加载时调用
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //即将完成加载
        //禁用长按功能
        self.wkWebView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: { (nullAble, errors) in
            //                        print(errors)
        })
        self.wkWebView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: { (nullAble, errors) in
            //                        print(errors)
        })
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //加载失败时调用
        self.activity.stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}
