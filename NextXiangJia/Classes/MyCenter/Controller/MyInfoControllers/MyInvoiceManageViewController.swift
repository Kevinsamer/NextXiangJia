//
//  MyInvoiceManageViewController.swift
//  NextXiangJia
//  发票管理
//  Created by DEV2018 on 2018/4/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class MyInvoiceManageViewController: UIViewController {

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
extension MyInvoiceManageViewController {
    private func setUI(){
        //1.设置navagationBar
        //1.设置navigationBar tabBar
//        YTools.setNavigationBarAndTabBar(navCT: self.navigationController!, tabbarCT: self.tabBarController!, titleName: "发票管理", navItem:self.navigationItem)
        navigationItem.title = "发票管理"
        //2.设置bodyContent
        setupBodyContent()
    }
    private func setupBodyContent(){
        let label = UILabel(frame: CGRect(x: finalScreenW / 2 - 50, y: finalScreenH / 2 - 20, width: 100, height: 40))
        label.textAlignment = .center
        label.text = "MyInvoiceManagePage"
        self.view.addSubview(label)
        self.view.backgroundColor = UIColor.random.lighten(by: 0.6)
    }
}