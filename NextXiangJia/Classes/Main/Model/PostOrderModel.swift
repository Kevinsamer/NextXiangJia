//
//  PostOrderModel.swift
//  NextXiangJia
//  提交订单返回数据model
//  Created by DEV2018 on 2018/11/14.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class PostOrderModel {
    ///订单编号
    var order_no:String = ""
    ///用户id
    var user_id:Int = 0
    ///收货地址
    var accept_name:String = ""
    ///支付方式 1:预付款 10：支付宝app支付
    var pay_type:Int = -1
    ///用户选择的配送方式的id 1快递   3自提
    var distribution:Int = -1
    ///邮政编码
    var postcode:String = ""
    ///座机号码
    var telphone:String = ""
    ///省份id
    var province:String = ""
    ///城市id
    var city:String = ""
    ///区域id
    var area:String = ""
    ///详细地址
    var address:String = ""
    ///电话号码
    var mobile:String = ""
    ///订单建立时间
    var create_time:String = ""
    ///订单附加信息
    var postscript:String = ""
    ///发货时间
    var accept_time:String = ""
    ///经验
    var exp:Int = 0
    ///积分
    var point:Int = 0
    ///类型？
    var type:Int = 0
    ///应付金额
    var payable_amount:Double = 0.0
    ///实付金额
    var real_amount:Double = 0.0
    ///应付运费金额
    var payable_freight:Double = 0.0
    ///实付运费金额
    var real_freight:Double = 0.0
    ///手续费
    var pay_fee:Double = 0.0
    ///是否要发票
    var invoice:Int = 0
    ///发票抬头信息
    var invoice_title:String = ""
    ///税费
    var taxes:Double = 0.0
    ///促销优惠金额
    var promotions:Double = 0.0
    ///订单总金额
    var order_amount:Double = 0.0
    ///保价
    var insured:Double = 0
    ///自提点id
    var takeself:Int = 0
    ///促销活动id
    var active_id = 0
    ///卖家id
    var seller_id:Int = 0
    ///管理员备注
    var note:String = ""
    
    init(jsonData:JSON) {
        order_no = jsonData["order_no"].stringValue
        user_id = jsonData["user_id"].intValue
        accept_name = jsonData["accept_name"].stringValue
        pay_type = jsonData["pay_type"].intValue
        distribution = jsonData["distribution"].intValue
        postcode = jsonData["postcode"].stringValue
        telphone = jsonData["telphone"].stringValue
        province = jsonData["province"].stringValue
        city = jsonData["city"].stringValue
        area = jsonData["area"].stringValue
        address = jsonData["address"].stringValue
        mobile = jsonData["mobile"].stringValue
        create_time = jsonData["create_time"].stringValue
        postscript = jsonData["postscript"].stringValue
        accept_time = jsonData["accept_time"].stringValue
        exp = jsonData["exp"].intValue
        point = jsonData["point"].intValue
        type = jsonData["type"].intValue
        payable_amount = jsonData["payable_amount"].doubleValue
        real_amount = jsonData["real_amount"].doubleValue
        payable_freight = jsonData["payable_freight"].doubleValue
        real_freight = jsonData["real_freight"].doubleValue
        pay_fee = jsonData["pay_fee"].doubleValue
        invoice = jsonData["invoice"].intValue
        invoice_title = jsonData["invoice_title"].stringValue
        taxes = jsonData["taxes"].doubleValue
        promotions = jsonData["promotions"].doubleValue
        order_amount = jsonData["order_amount"].doubleValue
        insured = jsonData["insured"].doubleValue
        takeself = jsonData["takeself"].intValue
        active_id = jsonData["active_id"].intValue
        seller_id = jsonData["seller_id"].intValue
        note = jsonData["note"].stringValue
    }
    
}
