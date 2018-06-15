//
//  GoodDetailViewController.swift
//  NextXiangJia
//  商品详情页
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class GoodDetailViewController: UIViewController {
    
    //MARK: - 懒加载
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - 设置界面
extension GoodDetailViewController {
    private func setUI(){
        //1.初始化数据
        initData()
        //2.设置navigationBar
        setNavigationBar()
        //3.设置主content
        setContentView()
    }
    
    private func setContentView(){
        view.backgroundColor = .white
    }
    
    private func setNavigationBar(){
        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, titleName: "商品详情", navItem: self.navigationItem)
    }
    
    private func initData(){
        
    }
}


