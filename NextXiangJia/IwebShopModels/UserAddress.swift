//
//  Address.swift
//  NextXiangJia
//  收货信息表（收件人地址信息等）
//  Created by DEV2018 on 2018/8/2.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class UserAddress:BaseModel {
    @objc var id:Int = 0
    @objc var user_id:Int = 0//用户id
    @objc var accept_name:String = ""//收货人姓名
    @objc var zip:String = ""//邮编
    @objc var telphone:String = ""//联系电话
    @objc var country:Int = 0//国家id
    @objc var province:Int = 0//省id
    @objc var city:Int = 0//城市id
    @objc var area:Int = 0//区id
    @objc var address:String = ""//收货地址
    @objc var mobile = ""//手机号
    @objc var is_default = 0//是否为默认地址  0非默认   1默认
}
