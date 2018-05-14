//
//  ShopCartViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/3/20.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ShopCartViewController: UIViewController {
    // MARK: - 懒加载属性

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //设置UI
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}

// MARK: - 设置UI界面
extension ShopCartViewController{
    private func setUI(){
        //1.设置导航栏
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
        
        //设置标题
        let title = UILabel()
        title.font = UIFont(name: "System", size: 18.0)
        title.textColor = .white
        title.text = "购物车"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "home_top_search_right")
        navigationItem.title = "购物车"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        //navigationItem.titleView = title
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "global_orange")
        navigationController?.navigationBar.isTranslucent = false
    }
}
