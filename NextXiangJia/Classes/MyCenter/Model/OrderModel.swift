//
//  OrderModel.swift
//  NextXiangJia
//  订单model
//  Created by DEV2018 on 2018/11/22.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class OrderModel{
    ///订单id
    var id:Int = 0
    ///订单编号
    var order_no:String = ""
    ///订单所属用户id
    var user_id:Int = 0
    ///支付方式编号
    var pay_type:Int = -1
    ///用户选择的配送方式id 1快递  3自提
    var distribution:Int = 0
    ///订单状态 1.生成订单  2.支付订单  3.取消订单（客户触发） 4.作废订单（管理员处罚） 5.完成订单  6.退款（订单完成后） 7.部分退款（订单完成后）
    var status:Int = 0
    ///支付状态 0：未支付  1：已支付
    var pay_status:Int = 0
    ///配送状态  0：未发送  1：已发送  2：部分发送
    var distribution_status:Int = 0
    ///收货人姓名
    var accept_name:String = ""
    ///邮编
    var postcode:String = ""
    ///联系电话
    var telphone:String = ""
    ///国id
    var country:Int = 0
    ///省id
    var province:Int = 0
    ///市id
    var city:Int = 0
    ///区域id
    var area:Int = 0
    ///收货地址
    var address:String = ""
    ///手机
    var mobile:String = ""
    ///应付商品总金额
    var payable_amount:Double = 0.00
    ///实付商品总金额
    var real_amount:Double = 0.00
    ///总运费金额
    var payable_freight:Double = 0.00
    ///实付运费
    var real_freight:Double = 0.00
    ///付款时间
    var pay_time:String = ""
    ///发货时间
    var send_time:String = ""
    ///下单时间
    var create_time:String = ""
    ///订单完成时间
    var completion_time:String = ""
    ///发票 0不要 1索要
    var invoice:Int = 0
    ///用户附言
    var postscript:String = ""
    ///管理员备注
    var note:String = ""
    ///是否删除  0未删除  1删除
    var if_del:Int = 0
    ///保价
    var insured:Double = 0.00
    ///支付手续费
    var pay_fee:Double = 0.00
    ///发票抬头
    var invoice_title:String = ""
    ///税金
    var taxes:Double = 0.00
    ///促销优惠金额
    var promotions:Double = 0.00
    ///订单折扣或涨价
    var discount:Double = 0.00
    ///订单总金额
    var order_amount:Double = 0.00
    ///使用的道具id
    var prop:String = ""
    ///用户收货时间
    var accept_time:String = ""
    ///增加的经验
    var exp:Int = 0
    ///增加的积分
    var point:Int = 0
    ///订单类型  0普通订单 1团购订单 2限时抢购
    var type:Int = 0
    ///支付平台交易号
    var trade_no:String = ""
    ///自提点id
    var takeself:Int = 0
    ///自提方式的验证码
    var checkcode:String = ""
    ///促销活动id
    var active_id:Int = 0
    ///商家id
    var seller_id:Int = 0
    ///是否给商家结算货款  0未结算 1已结算
    var is_checkout:Int = 0
    //增加订单详情属性:
    
    ///订单详情属性:订单id
    var order_id:Int = 0
    ///订单详情属性:运输方式
    var delivery:String = ""
    ///订单详情属性:省份名称
    var province_str:String = ""
    ///订单详情属性:城市名称
    var city_str:String = ""
    ///订单详情属性:区域名称
    var area_str:String = ""
    ///订单详情属性:支付方式名称
    var payment:String = ""
    ///订单详情属性:paynote
    var paynote:String = ""
    ///订单详情属性:商品金额
    var goods_amount:Double = 0.00
    ///订单详情属性:商品重量
    var goods_weight:Double = 0.00
    ///订单详情属性:用户名
    var username:String = ""
    ///订单详情属性:邮箱
    var email:String = ""
    ///订单详情属性:用户手机号
    var u_mobile = ""
    ///订单详情属性:用户联系地址
    var contact_addr:String = ""
    ///订单详情属性:真实姓名
    var true_name:String = ""
    init(jsonData:JSON) {
        id = jsonData["id"].intValue
        order_no = jsonData["order_no"].stringValue
        user_id = jsonData["user_id"].intValue
        pay_type = jsonData["pay_type"].intValue
        distribution = jsonData["distribution"].intValue
        status = jsonData["status"].intValue
        pay_status = jsonData["pay_status"].intValue
        distribution_status = jsonData["distribution_status"].intValue
        accept_name = jsonData["accept_name"].stringValue
        postcode = jsonData["postcode"].stringValue
        telphone = jsonData["telphone"].stringValue
        country = jsonData["country"].intValue
        province = jsonData["province"].intValue
        city = jsonData["city"].intValue
        area = jsonData["area"].intValue
        address = jsonData["address"].stringValue
        mobile = jsonData["mobile"].stringValue
        payable_amount = jsonData["payable_amount"].doubleValue
        real_amount = jsonData["real_amount"].doubleValue
        payable_freight = jsonData["payable_freight"].doubleValue
        real_freight = jsonData["real_freight"].doubleValue
        pay_time = jsonData["pay_time"].stringValue
        send_time = jsonData["send_time"].stringValue
        create_time = jsonData["create_time"].stringValue
        completion_time = jsonData["completion_time"].stringValue
        invoice = jsonData["invoice"].intValue
        postscript = jsonData["postscript"].stringValue
        note = jsonData["note"].stringValue
        if_del = jsonData["if_del"].intValue
        insured = jsonData["insured"].doubleValue
        pay_fee = jsonData["pay_fee"].doubleValue
        invoice_title = jsonData["invoice_title"].stringValue
        taxes = jsonData["taxes"].doubleValue
        promotions = jsonData["promotions"].doubleValue
        discount = jsonData["discount"].doubleValue
        order_amount = jsonData["order_amount"].doubleValue
        prop = jsonData["prop"].stringValue
        accept_time = jsonData["accept_time"].stringValue
        exp = jsonData["exp"].intValue
        point = jsonData["point"].intValue
        type = jsonData["type"].intValue
        trade_no = jsonData["trade_no"].stringValue
        takeself = jsonData["takeself"].intValue
        checkcode = jsonData["checkcode"].stringValue
        active_id = jsonData["active_id"].intValue
        seller_id = jsonData["seller_id"].intValue
        is_checkout = jsonData["is_checkout"].intValue
        order_id = jsonData["order_id"].intValue
        delivery = jsonData["delivery"].stringValue
        province_str = jsonData["province_str"].stringValue
        city_str = jsonData["city_str"].stringValue
        area_str = jsonData["area_str"].stringValue
        payment = jsonData["payment"].stringValue
        paynote = jsonData["paynote"].stringValue
        goods_amount = jsonData["goods_amount"].doubleValue
        goods_weight = jsonData["goods_weight"].doubleValue
        username = jsonData["username"].stringValue
        email = jsonData["email"].stringValue
        u_mobile = jsonData["u_mobile"].stringValue
        contact_addr = jsonData["contact_addr"].stringValue
        true_name = jsonData["true_name"].stringValue
    }
}
