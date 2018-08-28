//
//  GoodDetailBaseViewController.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class GoodDetailBaseViewController: UIViewController ,IndicatorInfoProvider{
    var goodsInfo : GoodInfo?
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        //self.goodsInfo = goodsInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var itemInfo: IndicatorInfo = "View"
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.random.lighten()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
