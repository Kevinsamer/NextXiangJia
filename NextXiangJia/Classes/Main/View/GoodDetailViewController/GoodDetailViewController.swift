//
//  GoodDetailViewController.swift
//  NextXiangJia
//  商品详情页
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SnapKit
import XLPagerTabStrip
class GoodDetailViewController: ButtonBarPagerTabStripViewController {

    //MARK: - 懒加载
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        //        settings.style.buttonBarLeftContentInset = 20
        //        settings.style.buttonBarRightContentInset = 20
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = -5
        settings.style.selectedBarHeight = 5
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 20)
        
        super.viewDidLoad()
        
        buttonBarView.removeFromSuperview()
        navigationController?.navigationBar.addSubview(buttonBarView)
        
        setUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let goodVC = GoodViewController(itemInfo: "商品")
        let detailVC = DetailViewController(itemInfo: "详情")
        let commentVC = CommentViewController(itemInfo: "评价")
        
        return [goodVC,detailVC,commentVC]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.titleView = nil
        buttonBarView.removeFromSuperview()
        super.viewWillDisappear(animated)
    }
}

//MARK: - 设置界面
extension GoodDetailViewController {
    private func setUI(){
        //0.设置滑动栏buttonBarView
        setButtonBarView()
        //1.初始化数据
        initData()
        //2.设置navigationBar
        setNavigationBar()
        //3.设置主content
        setContentView()
    }
    private func setButtonBarView(){
        
        //改变选择字体的样式，选择加粗
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = .white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
        
        buttonBarView.frame = CGRect(x: 100, y: 0, width: finalScreenW /  2, height: buttonBarView.frame.height)
        //buttonBarView.centerX = (navigationController?.navigationBar.centerX)!
        buttonBarView.selectedBar.backgroundColor = .white
        buttonBarView.backgroundColor = .clear
        
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
    }
    
    private func setContentView(){
        view.backgroundColor = .white
    }
    
    private func setNavigationBar(){
        //YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, titleName: "商品详情", navItem: self.navigationItem)
    }
    
    private func initData(){
        
    }
}


