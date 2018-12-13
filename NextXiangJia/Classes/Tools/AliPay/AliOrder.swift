//
//  AliOrder.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/12/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class AliOrder{
    ///app_id
    var app_id:String = ""
    ///支付接口
    var method:String = "alipay.trade.app.pay"
    ///参数编码格式
    var charset:String = "utf-8"
    ///当前时间点
    var timestamp:String = YTools.dateToString(date: Date.init(timeIntervalSinceNow: 0))
    ///支付版本
    var version:String = "1.0"
    ///sign_type设置
    var sign_type:String = "RSA2"
    ///商品数据
    var biz_content:BizContent = BizContent()
    ///将商品数据拼接成字符串
    
    
}
