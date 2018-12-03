//
//  MyAddressModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/10/30.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class MyAddressModel {
    var id:Int = 0//地址id
    var user_id:Int = 0//用户id
    var accept_name:String = ""//收件人信息
    var zip:String = ""//邮政编码
    var telphone:String = ""//电话号
    var province:String = ""//省
    var city:String = ""//市
    var area:String = ""//区
    var address:String = ""//详细地址
    var mobile:String = ""//手机号
    ///是否默认  1默认  0非默认
    var is_default:Int = 0
    var country:String?//国家
    
    init(jsonData:JSON) {
        id = jsonData["id"].intValue
        user_id = jsonData[user_id].intValue
        accept_name = jsonData["accept_name"].stringValue
        zip = jsonData["zip"].stringValue
        telphone = jsonData["telphone"].stringValue
        province = jsonData["province"].stringValue
        city = jsonData["city"].stringValue
        area = jsonData["area"].stringValue
        address = jsonData["address"].stringValue
        mobile = jsonData["mobile"].stringValue
        is_default = jsonData["is_default"].intValue
        country = jsonData["country"].string
    }
}
