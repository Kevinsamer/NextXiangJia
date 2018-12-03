//
//  MyOrdersViewController.swift
//  NextXiangJia
//  我的订单
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MyOrdersViewController: ButtonBarPagerTabStripViewController {
    var isFromPayVC:Bool = false
    
    //MARK: - 懒加载
    lazy var leftBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "btnBack"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backToRootVC))
        return item
    }()
    override func viewDidLoad() {
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemBackgroundColor = UIColor(named: "global_orange")
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
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let allVC = MyOrdersTableViewController(itemInfo: "全部", orderNumbers: 0)
        let waitForPayVC = MyOrdersTableViewController(itemInfo: "待支付", orderNumbers: 0)
        //waitForPayVC.view.frame = CGRect(x: 0, y: finalNavigationBarH + finalStatusBarH, width: finalScreenW, height: finalContentViewNoTabbarH)
        let waitForReceiveVC = MyOrdersTableViewController(itemInfo: "待收货", orderNumbers: 0)
        let compiliteVC = MyOrdersTableViewController(itemInfo: "已完成", orderNumbers: 0)
        let cancledVC = MyOrdersTableViewController(itemInfo: "已取消", orderNumbers: 0)
        return [allVC,waitForPayVC,waitForReceiveVC,compiliteVC,cancledVC]
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //离开时开启侧滑
        if self.isFromPayVC {
            self.navigationItem.hidesBackButton = false
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //关闭侧滑
        if self.isFromPayVC{
            self.navigationItem.hidesBackButton = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
    }

}
//MARK: - 设置ui
extension MyOrdersViewController {
    private func setUI(){
        //1.设置navagationBar
        navigationItem.title = "我的订单"
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if self.isFromPayVC {
            self.navigationItem.leftBarButtonItem = self.leftBarButtonItem
        }
        //2.设置buttonBarView
        setButtonBarView()
    }
   
    private func setButtonBarView(){
        //改变选择字体的样式，选择加粗
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = UIColor(white: 1, alpha: 0.6)
            newCell?.label.textColor = .white
            
            if animated {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    newCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    oldCell?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                })
            } else {
                newCell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                oldCell?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }
        }
        buttonBarView.frame = CGRect(x: 0, y: finalStatusBarH + finalNavigationBarH, width: buttonBarView.frame.width, height: 44)
        buttonBarView.selectedBar.backgroundColor = .white
        buttonBarView.backgroundColor = UIColor(named: "global_orange")
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
        containerView.contentInsetAdjustmentBehavior = .never
        print("buttonBar\(buttonBarView.height)")
    }
    
}

extension MyOrdersViewController{
    @objc private func backToRootVC(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
