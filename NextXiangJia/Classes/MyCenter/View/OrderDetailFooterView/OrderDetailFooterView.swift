//
//  OrderDetailFooterView.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/7/13.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class OrderDetailFooterView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var orderTotalPriceLabel: UILabel!
    @IBOutlet var orderShouXuFeiLabel: UILabel!
    @IBOutlet var orderBaojiaLabel: UILabel!
    @IBOutlet var orderYunfeiLabel: UILabel!
    @IBOutlet var orderShuijinLabel: UILabel!
    @IBOutlet var orderDaijinLabel: UILabel!
    @IBOutlet var orderPriceLabel: UILabel!
    @IBOutlet var orderCodeLabel: UILabel!
    @IBOutlet var orderTimeLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    

}
