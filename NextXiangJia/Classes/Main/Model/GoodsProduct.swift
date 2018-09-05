//
//  GoodsProduct.swift
//  NextXiangJia
//  商品货品类
//  Created by DEV2018 on 2018/8/28.
//  Copyright © 2018年 DEV2018. All rights reserved.
//
//{
//    "code":200,
//    "result":[
//    {
//    "id":"187",
//    "goods_id":"162",
//    "products_no":"SD150994759218-1",
//    "spec_array":"[{"id":"88","type":"1","value":"普通箱装（十斤）","name":"苹果规格","tip":"1"}]",
//    "store_nums":"9915",
//    "market_price":"55.00",
//    "sell_price":"40.00",
//    "cost_price":"35.00",
//    "weight":"5000.00"
//    },
//    {
//    "id":"188",
//    "goods_id":"162",
//    "products_no":"SD150994759218-2",
//    "spec_array":"[{"id":"88","type":"1","value":"红色礼盒（十斤，苹果个头更大）","name":"苹果规格","tip":"2"}]",
//    "store_nums":"9996",
//    "market_price":"60.00",
//    "sell_price":"50.00",
//    "cost_price":"35.00",
//    "weight":"5000.00"
//    }
//    ],
//    "time":1535437669
//}

import Foundation
import SwiftyJSON
class GoodsProduct: BaseModel {
    
    @objc var id:Int = 0//货品id
    @objc var goods_id:Int = 0//商品id
    @objc var products_no:String = ""//货品的货号（以商品的货号加横线加数字组成）
    @objc var spec_array:String = ""//json规格数据
        {
        didSet{
            productSpecsJSON = JSON(parseJSON: spec_array)
        }
    }
    @objc var store_nums:Int = 0//库存数量
    @objc var market_price:String = ""//市场价格
    @objc var sell_price:String = ""//销售价
    @objc var cost_price:String = ""//成本价格
    @objc var weight:Float = 0.00//重量
    var productSpecsJSON:JSON? {
        didSet{
            guard let jsons = productSpecsJSON else {return}
            for i in 0..<jsons.count {
                productSpecs.append(ProductSpec(jsonData: jsons[i]))
            }
        }
    }
    var productSpecs:[ProductSpec] = [ProductSpec]()
}
