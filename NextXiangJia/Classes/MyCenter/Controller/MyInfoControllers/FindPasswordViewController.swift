//
//  FindPasswordViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/10.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class FindPasswordViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
//        settings.style.selectedBarBackgroundColor = .red
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemBackgroundColor = .white
//        settings.style.buttonBarLeftContentInset = 20
//        settings.style.buttonBarRightContentInset = 20
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = -5
        settings.style.selectedBarHeight = 5
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //设置ui
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //xl datasource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let findByPhoneVC = FindPasswordTabViewController(itemInfo: "短信找回", type: typePhone)
        let findByMailVC = FindPasswordTabViewController(itemInfo: "邮箱找回", type: typeMail)
        
        return[findByPhoneVC,findByMailVC]
    }
}
//MARK: - 设置ui
extension FindPasswordViewController {
    private func setUI(){
        //1.设置navigationBar tabBar
//        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "找回密码", navItem:self.navigationItem)
        navigationItem.title = "找回密码"
        self.view.backgroundColor = .white
        //2.设置bodyContent
        setupBodyContent()
    }
    
    private func setupBodyContent(){
        buttonBarView.frame = CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: buttonBarView.frame.width, height: buttonBarView.frame.height)
        buttonBarView.selectedBar.backgroundColor = UIColor(named: "global_orange")
        buttonBarView.backgroundColor = UIColor(named: "global_orange")
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
        //pagerBehaviour = .common(skipIntermediateViewControllers: false)
        self.containerView.contentInsetAdjustmentBehavior = .never
        //self.view.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
    }

}

