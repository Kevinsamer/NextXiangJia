//
//  MainViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/2/24.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
//        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
        addChildrenController("Home")
        addChildrenController("ShopCart")
        addChildrenController("CategoryCenter")
        addChildrenController("MyCenter")
        
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = false
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//
//        if item.tag == 444 || item.tag == 222{
//            //点击底部tabbar，如果是购物车和我的则进行登录判断
//            YTools.presentToLoginOrNextControl(vc: self, completion: {
//
//            })
//
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Function
    func addChildrenController(_ name:String){
        let childVC = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        addChildViewController(childVC)
    }
}

extension MainViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //ps:底部4个tabBarItem设置了tag，首页：111，购物车：222，分类：333，我的：444
        if viewController.tabBarItem.tag == 222 || viewController.tabBarItem.tag == 444{
            if AppDelegate.appUser?.id == -1{
                YTools.presentToLoginOrNextControl(vc: self, itemTag: viewController.tabBarItem.tag, completion: nil)
                return false
            }else{
                return true
            }
            
        }
        return true
    }
}

