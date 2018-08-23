//
//  HotInfo.swift
//  NextXiangJia
//  热点商品类
//  Created by DEV2018 on 2018/8/23.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class HotInfo:BaseModel {
    @objc var img:String = ""//图片路径
    @objc var sell_price:String = ""//销售价格
    @objc var name:String = ""//商品名
    @objc var id:Int = 0//商品id
    @objc var market_price:String = ""//原价
}
