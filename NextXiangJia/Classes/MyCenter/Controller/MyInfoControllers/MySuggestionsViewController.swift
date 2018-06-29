//
//  MySuggestionsViewController.swift
//  NextXiangJia
//  站点建议
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MySuggestionsViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
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
        let submitVC = MySuggesttionTabSubmitViewController(itemInfo: "发表建议")
        let feedVC = MySuggestionTabFeedViewController(itemInfo: "我的建议")
        
        return[feedVC,submitVC]
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK: - 设置ui
extension MySuggestionsViewController {
    private func setUI(){
        //1.设置navigationBar tabBar
//        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "站点建议", navItem:self.navigationItem)
        navigationItem.title = "站点建议"
        self.view.backgroundColor = .white
        //2.设置bodyContent
        setupBodyContent()
    }
    private func setupBodyContent(){
        buttonBarView.frame = CGRect(x: 0, y: 0, width: buttonBarView.frame.width, height: buttonBarView.frame.height)
        buttonBarView.selectedBar.backgroundColor = UIColor(named: "global_orange")
        buttonBarView.backgroundColor = UIColor(named: "global_orange")
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
        //pagerBehaviour = .common(skipIntermediateViewControllers: false)
        //containerView.frame = self.view.frame
        //在子页面中修改
    }
}
