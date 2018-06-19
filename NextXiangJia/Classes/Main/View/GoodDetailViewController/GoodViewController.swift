//
//  GoodViewController.swift
//  NextXiangJia
//  商品
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SnapKit

class GoodViewController: GoodDetailBaseViewController {
    
    //MARK: - 懒加载
    lazy var topScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    lazy var promptLabel: UILabel = {
        let label = UILabel()
        label.snp.makeConstraints({ (make) in
            make.bottom.equalTo(topScrollView)
            make.width.equalTo(view)
            make.height.equalTo(40)
        })
        label.text = "上拉查看图文详情"
        return label
    }()
    
    //MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
