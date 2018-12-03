//
//  GoodsArrayModel.swift
//  NextXiangJia
//  订单列表商品属性model
//  Created by DEV2018 on 2018/11/26.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class GoodsArrayModel{
    ///商品名
    var name:String = ""
    ///商品编号
    var goodsno:String = ""
    ///规格信息
    var value:String = ""
    
    init(jsonData:JSON) {
        name = jsonData["name"].stringValue
        goodsno = jsonData["goodsno"].stringValue
        value = jsonData["value"].stringValue
    }
}
