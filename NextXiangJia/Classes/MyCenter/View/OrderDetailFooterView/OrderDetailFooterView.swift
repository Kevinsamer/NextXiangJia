//
//  OrderDetailFooterView.swift
//  NextXiangJia
//  订单详情底部信息展示视图
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
    ///实付款
    @IBOutlet var orderTotalPriceLabel: UILabel!
    ///手续费
    @IBOutlet var orderShouXuFeiLabel: UILabel!
    ///保价
    @IBOutlet var orderBaojiaLabel: UILabel!
    ///运费
    @IBOutlet var orderYunfeiLabel: UILabel!
    ///税费
    @IBOutlet var orderShuijinLabel: UILabel!
    ///代金券
    @IBOutlet var orderDaijinLabel: UILabel!
    ///商品金额
    @IBOutlet var orderPriceLabel: UILabel!
    ///订单编号
    @IBOutlet var orderCodeLabel: UILabel!
    ///订单时间
    @IBOutlet var orderTimeLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    

}
