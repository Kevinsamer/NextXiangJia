//
//  OrderGoodsListModel.swift
//  NextXiangJia
//  订单商品model
//  Created by DEV2018 on 2018/11/26.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class OrderGoodsListModel:NSObject{
    ///订单商品id
    var id:Int = 0
    ///订单id
    var order_id:Int = 0
    ///商品id
    var goods_id:Int = 0
    ///图片路径
    var img:String = ""
    ///货品id
    var product_id:Int = 0
    ///商品原价
    var goods_price:Double = 0.00
    ///实付金额
    var real_price:Double = 0.00
    ///商品数量
    var goods_nums:Int = 0
    ///商品重量
    var goods_weight:Double = 0.00
    ///商品属性字符串
    var goods_array:String = ""{
        didSet{
            //print(goods_array.jsonKey)
            goodsArrayModel = GoodsArrayModel(jsonData: JSON.init(parseJSON: goods_array))
        }
    }
    ///商品属性model
    var goodsArrayModel:GoodsArrayModel?
    ///是否发货 0未发货  1已发货 2已退货
    var is_send:Int = 0
    ///配送单id
    var delivery_id:Int = 0
    ///商家id
    var seller_id:Int = 0
    
    init(jsonData:JSON) {
        super.init()
        id = jsonData["id"].intValue
        order_id = jsonData["order_id"].intValue
        goods_id = jsonData["goods_id"].intValue
        img = jsonData["img"].stringValue
        product_id = jsonData["product_id"].intValue
        goods_price = jsonData["goods_price"].doubleValue
        real_price = jsonData["real_price"].doubleValue
        goods_nums = jsonData["goods_nums"].intValue
        goods_weight = jsonData["goods_weight"].doubleValue
        //goods_array = jsonData["goods_array"].stringValue
        setValue(jsonData["goods_array"].stringValue, forKey: "goods_array")
        
        is_send = jsonData["is_send"].intValue
        delivery_id = jsonData["delivery_id"].intValue
        seller_id = jsonData["seller_id"].intValue
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "goods_array"{
            goods_array = (value as? String)!
        }
    }
}
