//
//  MyNavigationController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/14.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SwiftEventBus
//searchBar attribute
private let searchBarH:CGFloat = 64
class MyNavigationController: UINavigationController {
    
    //MARK: - 懒加载属性
    private lazy var searchBar:UISearchBar = {
        //搜索栏
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: searchBarH))
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.barStyle = UIBarStyle.default
        searchBar.autocapitalizationType = .words
        searchBar.delegate = self
        searchBar.placeholder = "请输入搜索内容"
        let textField = searchBar.value(forKey: "_searchField") as! UITextField //获取searchBar的输入框
        if let backgroundview = textField.subviews.first {
            // Background color
            backgroundview.backgroundColor = UIColor.white
            // Rounded corner
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        }
        searchBar.backgroundColor = UIColor(named: "global_orange")
        searchBar.tintColor = UIColor(named: "global_orange")
        //        var background = searchBar.value(forKey: "_background") as! UIView
        //        background.removeFromSuperview()
        return searchBar
    }()
    private lazy var alphaView : UIControl = {
        //UISearchBar的蒙层
        let view = UIControl(frame: CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: finalScreenW, height: finalContentViewNoTabbarH))
        view.backgroundColor = .black
        view.alpha = 0.3
        view.addTarget(self, action: #selector(dismissAlphaViewAndSearchBar), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // Do any additional setup after loading the view.
//        navigationBar.barTintColor = .red
//        navigationBar.backgroundColor = .red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        YTools.setNavigationBarAndTabBar(navCT: (self.viewControllers.first?.navigationController)!, titleName: "", navItem: (self.viewControllers.first?.navigationItem)!)
    }
    
}
//MARK: - 设置UI
extension MyNavigationController {
    private func setUI(){
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        //设置图标按钮实现点击高亮效果
        let leftBtn = UIButton.init()
        leftBtn.setTitle(String.fontAwesomeIcon(name: .home), for: .normal)
        leftBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        leftBtn.setTitleColor(.white, for: .normal)
        leftBtn.setTitleColor(UIColor.init(named: "dark_gray"), for: .highlighted)
        
        let rightBtn = UIButton()
        rightBtn.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)
        rightBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        rightBtn.setTitleColor(.white                                                                   , for: .normal)
        rightBtn.setTitleColor(UIColor.init(named: "dark_gray"), for: .highlighted)
        rightBtn.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        //设置标题
        let title = UILabel()
        title.font = UIFont(name: "System", size: 18.0)
        title.textColor = .white
        title.text = "分类浏览"
        
        self.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        self.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "home_top_search_right")
        //self.viewControllers.first?.navigationItem.title = "分类浏览"
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        //navigationItem.titleView = title
        navigationBar.barTintColor = UIColor.init(named: "global_orange")
        navigationBar.isTranslucent = false
    }
}

//MARK: - 响应事件
extension MyNavigationController {
    @objc private func searchBtnClicked(){
        if searchBarState == 1 {
            //隐藏
            searchBar.removeFromSuperview()
            alphaView.removeFromSuperview()
            searchBarState = 2
        }else if searchBarState == 2 {
            //显示
            view.addSubview(alphaView)
            view.addSubview(searchBar)
            searchBar.becomeFirstResponder()
            searchBarState = 1
        }
    }
    
    @objc private func dismissAlphaViewAndSearchBar(){
        alphaView.removeFromSuperview()
        searchBar.resignFirstResponder()
        searchBtnClicked()
    }
}

//MARK: - searchBar的delegate
extension MyNavigationController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        alphaView.removeFromSuperview()
        searchBtnClicked()
        searchContent = (searchBar.textField?.text)!
        let vc = SearchResultController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.hidesBottomBarWhenPushed = true
        DispatchQueue.global().async {
            vc.SendData(data: searchContent)
        }
        
//        CommunicationTools.post(name: Communications.SearchResult, data: searchContent)
//        DispatchQueue.afterDelay(duration: 0.01) {
//            SwiftEventBus.post("searchKeys", sender: searchContent)
//        }
        self.viewControllers.first?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //self.rootScrollView.addSubview(alphaView)
        searchBar.text?.removeAll()
        return true
    }
    
}
