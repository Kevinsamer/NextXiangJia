//
//  Bill.swift
//  NextXiangJia
//  商家货款结算单表类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class Bill:BaseModel {
    @objc var id:Int = 0
    @objc var seller_id:Int = 0//商家id
    @objc var apply_time:String = ""//申请结算时间
    @objc var pay_time:String = ""//付结算时间
    @objc var admin_id:Int = 0//管理员id
    @objc var is_pay:Int = -1//结算状态 0未结算 1已结算
    @objc var apply_content:String = ""//申请结算文本
    @objc var pay_content:String = ""//支付结算文本
    @objc var start_time:String = ""//结算起始时间
    @objc var end_time:String = ""//结算终止时间
    @objc var log:String = ""//结算明细
    @objc var order_ids:Int = 0//order表主键id，结算的id
    @objc var amount:Double = 0.0//结算的金额
}
