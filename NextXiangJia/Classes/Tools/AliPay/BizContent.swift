//
//  BizContent.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/12/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
///渠道
enum channels:String {
    case 余额 = "balance"
    case 余额宝 = "moneyFund"
    case 红包 = "coupon"
    case 花呗 = "pcredit"
    case 花呗分期 = "pcreditpayInstallment"
    case 信用卡 = "creditCard"
    case 信用卡快捷 = "creditCardExpress"
    case 信用卡卡通 = "creditCardCartoon"
    case 信用支付类型_包含信用卡卡通_信用卡快捷_花呗_花呗分期 = "credit_group"
    case 借记卡快捷 = "debitCardExpress"
    case 商户预存卡 = "mcard"
    case 个人预存卡 = "pcard"
    case 优惠_包含实时优惠和商户优惠 = "promotion"
    case 营销券 = "voucher"
    case 积分 = "point"
    case 商户优惠 = "mdiscount"
    case 网银 = "bankPay"
 }
class BizContent{
    ///对一笔交易的具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。非必填。eg：Iphone6 16G
    var body:String = "飨家商城订单"
    ///商品的标题/交易标题/订单标题/订单关键字等。必填。eg：大乐透
    var subject:String = "飨家商城订单"
    ///商户网站唯一订单号。必填。eg：70501111111S001111119
    var out_trade_no:String = ""
    ///该笔订单允许的最晚付款时间，逾期将关闭交易。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。 该参数数值不接受小数点， 如 1.5h，可转换为 90m。注：若为空，则默认为15d。非必填
    var timeout_express:String = ""
    ///订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]。必填
    var total_amount:String = ""
    ///销售产品码，商家和支付宝签约的产品码，为固定值QUICK_MSECURITY_PAY。必填
    var product_code:String = "QUICK_MSECURITY_PAY"
    ///商品主类型：0—虚拟类商品，1—实物类商品 注：虚拟类商品不支持使用花呗渠道。非必填
    var goods_type:String = "1"
    ///公用回传参数，如果请求时传递了该参数，则返回给商户时会回传该参数。支付宝会在异步通知时将该参数原样返回。本参数必须进行UrlEncode之后才可以发送给支付宝。非必填
    var passback_params:String = ""
    ///优惠参数。忽略。非必填
    var promo_params:String = ""
    ///业务扩展参数。忽略。非必填
    var extend_params:String = ""
    ///可用渠道，用户只能在指定渠道范围内支付   当有多个渠道时用“,”分隔  注：与disable_pay_channels互斥。非必填
    var enable_pay_channels:String = ""
    ///禁用渠道，用户不可用指定渠道支付 当有多个渠道时用“,”分隔  注：与enable_pay_channels互斥。非必填
    var disable_pay_channels:String = ""
    ///商户门店编号。该参数用于请求参数中以区分各门店，非必传项。非必填
    var store_id:String = ""
}
