//
//  MyRechargeOnlineViewController.swift
//  NextXiangJia
//  在线充值
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class MyRechargeOnlineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //设置ui
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension MyRechargeOnlineViewController {
    private func setUI(){
        //1.设置navigationBar tabBar
//        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "在线充值", navItem:self.navigationItem)
        navigationItem.title = "在线充值"
        //2.设置bodyContent
        setupBodyContent()
    }

    private func setupBodyContent(){
        let label = UILabel(frame: CGRect(x: 0, y: finalScreenH / 2 - 20, width: finalScreenW, height: 40))
        label.textAlignment = .center
        label.text = "iOS端在线充值暂时关闭"
        self.view.addSubview(label)
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
