//
//  OrderDeliveryModel.swift
//  NextXiangJia
//  配送方式model
//  Created by DEV2018 on 2018/11/7.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class OrderDeliveryModel{
    var id:String = ""//配送方式id
    var name:String = ""//配送方式名称
    var description:String = ""//配送方式描述
    var if_delivery:Int = 0//是否可送达  0是  1否
    var org_price:Double = 0.00//运费原价
    var price:Double = 0.00//运费现价
    var protect_price:Double = 0.00//保价
    
    init(jsonData:JSON) {
        id = jsonData["id"].stringValue
        name = jsonData["name"].stringValue
        description = jsonData["description"].stringValue
        if_delivery = jsonData["if_delivery"].intValue
        org_price = jsonData["org_price"].doubleValue
        price = jsonData["price"].doubleValue
        protect_price = jsonData["protect_price"].doubleValue
    }
}
