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

        // Do any additional setup after loading the view.
        addChildrenController("Home")
        addChildrenController("ShopCart")
        addChildrenController("MyCenter")
        addChildrenController("CategoryCenter")
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = false
//    }

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
    
    // MARK: - Function
    func addChildrenController(_ name:String){
        let childVC = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        addChildViewController(childVC)
    }
}
