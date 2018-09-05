//
//  ProductSpec.swift
//  NextXiangJia
//  货品中的spec_array
//  Created by DEV2018 on 2018/8/29.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class ProductSpec {
    var id:Int = 0//规格id
    var type:Int = 1//显示类型 1文字 2图片
    var value:String = ""//规格值
    var name:String = ""//总规格名
    var tip:String = ""//详细规格值
    
    init(jsonData: JSON) {
        id = jsonData["id"].intValue
        type = jsonData["type"].intValue
        value = jsonData["value"].stringValue
        name = jsonData["name"].stringValue
        tip = jsonData["tip"].stringValue
    }
}
