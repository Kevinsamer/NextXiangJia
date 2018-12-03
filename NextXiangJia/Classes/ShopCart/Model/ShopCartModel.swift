//
//  ShopCartModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/10/17.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class ShopCartModel:NSObject{
    var final_sum:Double = 0.00//总价
    var promotion:String = ""//?
    var proReduce:String = ""//?
    var sum:Double = 0.00//总价
    var goodsList:[JSON]?{
        didSet{
            guard let goodsJsons = goodsList else {return}
            for goods in goodsJsons {
                goodsLists.append(ShopCartGoodsModel(jsonData: goods))
            }
        }
    }//商品数组集合
    var count:Int = 0//商品总数
    var reduce:Double = 0.00//总优惠
    var weight:Double = 0.00//总重量
    var point:Int = 0//总可获得积分
    var exp:Int = 0//总可获得经验
    var tax:Double = 0.00//总税费
    var freeFreight:String = ""//?
    var seller:String = ""//商家id数组
    
    
    lazy var goodsLists:[ShopCartGoodsModel] = [ShopCartGoodsModel]()//商品数组
    
    
    
    init(jsonData:JSON) {
        super.init()
        final_sum = jsonData["final_sum"].doubleValue
        promotion = jsonData["promotion"].stringValue
        proReduce = jsonData["proReduce"].stringValue
        sum = jsonData["sum"].doubleValue
        self.setValue(jsonData["goodsList"].arrayValue, forKey: "goodsList")
        //goodsList = jsonData["goodsList"].arrayValue
        count = jsonData["count"].intValue
        reduce = jsonData["reduce"].doubleValue
        weight = jsonData["weight"].doubleValue
        point = jsonData["point"].intValue
        exp = jsonData["exp"].intValue
        tax = jsonData["tax"].doubleValue
        freeFreight = jsonData["freeFreight"].stringValue
        seller = jsonData["seller"].stringValue
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "goodsList"{
            goodsList = value as? [JSON]
        }
    }
}
