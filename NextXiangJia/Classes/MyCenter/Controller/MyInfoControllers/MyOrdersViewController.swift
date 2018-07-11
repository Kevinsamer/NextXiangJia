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
        let allVC = MyOrdersTableViewController(itemInfo: "全部", orderNumbers: 20)
        let waitForPayVC = MyOrdersTableViewController(itemInfo: "待支付", orderNumbers: 5)
        //waitForPayVC.view.frame = CGRect(x: 0, y: finalNavigationBarH + finalStatusBarH, width: finalScreenW, height: finalContentViewNoTabbarH)
        let waitForReceiveVC = MyOrdersTableViewController(itemInfo: "待收货", orderNumbers: 0)
        let compiliteVC = MyOrdersTableViewController(itemInfo: "已完成", orderNumbers: 5)
        let cancledVC = MyOrdersTableViewController(itemInfo: "已取消", orderNumbers: 13)
        return [allVC,waitForPayVC,waitForReceiveVC,compiliteVC,cancledVC]
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
extension MyOrdersViewController {
    private func setUI(){
        //1.设置navagationBar
        navigationItem.title = "我的订单"
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
