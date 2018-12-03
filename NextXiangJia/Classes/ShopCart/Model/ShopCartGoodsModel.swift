//
//  ShopCartGoodsModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/10/17.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
///购物车商品模型，有规格的商品拥有spec_array属性，其中存放选择的规格值，无规格的商品则没有spec_array属性，使用该model时需注意区分这两种情况
class ShopCartGoodsModel:NSObject{
    var name:String = ""//商品名
    var cost_price:Double = 0.00//市场价
    var goods_id:Int = 0//商品id
    var img:String = ""//图片路径
    var sell_price:Double = 0.00//销售价
    var point:Int = 0//商品积分
    var weight:Double = 0.00//重量
    var store_nums:Int = 0//库存
    var exp:Int = 0//商品经验
    var goods_no:String = ""//商品编号
    var product_id:Int = 0//货品编号（规格编号）
    var seller_id:Int = 0//卖家id
    var reduce:Double = 0//优惠
    var count:Int = 0//数量
    var sum:Double = 0.00//单品总价
    var spec_array:String?{
        didSet{
            guard let specString = spec_array else { return }
            let specJson = JSON(parseJSON: specString)
            for json in specJson {
                specArray.append(ProductSpec(jsonData: json.1))
            }
            
        }
    }//规格json
    
    lazy var specArray:[ProductSpec] = [ProductSpec]()//规格数组
    
    init(jsonData:JSON) {
        super.init()
        name = jsonData["name"].stringValue
        cost_price = jsonData["cost_price"].doubleValue
        goods_id = jsonData["goods_id"].intValue
        img = jsonData["img"].stringValue
        sell_price = jsonData["sell_price"].doubleValue
        point = jsonData["point"].intValue
        weight = jsonData["weight"].doubleValue
        store_nums = jsonData["store_nums"].intValue
        exp = jsonData["exp"].intValue
        goods_no = jsonData["goods_no"].stringValue
        product_id = jsonData["product_id"].intValue
        seller_id = jsonData["seller_id"].intValue
        reduce = jsonData["reduce"].doubleValue
        count = jsonData["count"].intValue
        sum = jsonData["sum"].doubleValue
        self.setValue(jsonData["spec_array"].stringValue, forKey: "spec_array")
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "spec_array"{
            spec_array = value as? String
        }
    }
}
