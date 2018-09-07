//
//  SearchResultModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class SearchResultModel:BaseModel {
    @objc var id:Int = 0//商品id
    @objc var name:String = ""//商品名
    @objc var sell_price:Double = 0.00//销售价
    @objc var market_price:Double = 0.00//市场价
    @objc var store_nums:Int = 0//库存
    @objc var img:String = ""//图片路径
    @objc var sale:Int = 0//销量
    @objc var grade:Int = 0//评分总数
    @objc var comments:Int = 0//评价数
    @objc var favorite:Int = 0//收藏数
}
