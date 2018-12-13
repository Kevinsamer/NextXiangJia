//
//  AliSDKManager.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/12/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SwiftyJSON

let privateKey = "MIIEowIBAAKCAQEAtvTGNzL6ShXS5g+ejYXl70zKstpVGP/8i+QitsxcGGbuN72+vDUgrDGHi9OKn+tx1SWlcK6lLiULKUds+txnxnTClOI1eTlcbsULZozNAQEBcuxvjtgMeSpyf1S9gg0SXcqRSJ9pFQIomKHxFp5rmjH6hnxCSiZqfLkotJpijLKRLmclOlOHKFa6El3k3+nanJ1FBiWrsFbCUzZ5bdR8CcTmDg3MnzJuPWAThvSRraHv86jui95EZFxu0qDSUb01laBPe0Jc1CKmvxRj+V7nCNbnoXidgUWjA6vDrGEg7yhAM83a1Q6F95WtXOwW2U3ZwxUGzSQjrShI2wJta0QWowIDAQABAoIBAG5cACTTzz5ZI7o6ub1Mg4Jxo+N259YIs+H+XyI862Cc1h0xi5gjw+2agtTJadlFQIj+CGmML39CQRVJTGeWA9MmIymDuhXBkAwRN+tIC3ELlkAodrKHiB6eiCpeh2GnWOjShAh2gAB4KNzI8pBeRzHf6+qrkaEAw0MwvWkTp1aOafLuigw532ihbgt9/OTI3hs/u3s2ftzgDnF5/8L5ynyD8qFgUSzZq2eusv79jleSdzmyxQKeyZW3MxB6gm4n7rpu3jJIilPMvKOkTETbz5EGEAOgUhBKUZb06udvWgaKt2mbDqrOgfyN7kOVQYZaebh0juw7Jxa2Pl8ILAzYnWECgYEA7PBlBL85NT80sCIFmeZNNiAtCUve7MHLpywiLZnoOOCfVOSut+klBdEhXPhX/N3OahFbxwidEd1aBVMajuTbHJlpYESv/xjwvEtC1SuSpb5jvo891X173FEPB9k2YBvEnd/mSCJR4mWZS2+H0UKahDEzcmuPbE8cJQ7g4riqDf0CgYEAxayjG6u/0Sf+iMe6imtrJiFTTsyTt19H0HbU+yjMFM4iLeR538H5qwlpQSdH3qDVNueL+kbm3z7qhkCsZlad/iJip5wRcU/OkyF3d7DdFtsvhVO13JqRRPeGKPplQkBH57hQlRG3PvgEwcJEJRU2Cmf0i3CDeCA77Imy97DwiR8CgYEAs+rzeoBOS52cP6cGA9A6j0AtkqKXO8cJAv9jUKdPDGmc85TXC3Yxk9Iy+GroPW6cgDSAMYnb46Xm5qYtQ5aKv5PKzbw6vIXOv9ySelak+9Cv4xLYTFYGCM1QkZAiVyaezZcoQVw2O6kUl5CwXHmr5XeK7na4qPEFmSpMID1DfG0CgYAJu71wUF2qk9iRrZv+0tk80GlEuQgRAG0N07wa/eBGqfu+3MAvh2KezGDVZ3S/fpXhFTesRC98EKIFqEuU4nD3IYRQEnw9Yxud3Qj/6MKKLJLDcuLCkQ3UIogFnoa742RnAYlePbgTLq01STaHyOqXSpUdBJZEpPmuZP1d+uVtKwKBgHuwPr4Vofal4S3uaD6leR5cVMBWPzJcSBpwUek7xa27lZjQqaSCTK3PDIsedJu3v+SatDK2RDoZ7iwIQoU0w1sPAmZiwGeeuNsL9hSbM1SKnA0g6noRVAEq9L47ZB84AghRzUS5/FmpWtYVF+BtGrnZa8TpWHOMu1yLl0XTXijU"

class AliSDKManager{
    static var order = APOrderInfo()
    static var signer = APRSASigner(privateKey: privateKey)
    static var orderInfo:String = ""
    static var orderInfoEncode:String = ""
    static var signedString:String?
    static var appScheme = ""
    static var orderString:String = ""
    ///组装请求信息并加签后返回
    class func signInfo(bizContent:BizContent)->String{
        order.app_id = "2018120662434599"
        order.method = "alipay.trade.app.pay"
        order.charset = "utf-8"
        order.timestamp = "\(YTools.dateToString(date: Date.init(timeIntervalSinceNow: 0)))"
        order.version = "1.0"
        order.sign_type = "RSA2"
        order.biz_content = APBizContent.init()
        order.biz_content.body = bizContent.body
        order.biz_content.subject = bizContent.subject
        order.biz_content.out_trade_no = bizContent.out_trade_no
        order.biz_content.timeout_express = "30m"
        order.biz_content.total_amount = bizContent.total_amount
        //将商品信息拼接成字符串
        orderInfo = order.orderInfoEncoded(false)
        orderInfoEncode = order.orderInfoEncoded(true)
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        signedString = signer?.sign(orderInfo, withRSA2: true)
        // NOTE: 如果加签成功，则继续执行支付
        if signedString != nil {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            appScheme = "xiangjiamall"
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            orderString = String.init(format: "%@&sign=%@", orderInfoEncode, signedString!)
        }
        return orderString
    }
    
    ///    9000    订单支付成功
    ///    8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    ///    4000    订单支付失败
    ///    5000    重复请求
    ///    6001    用户中途取消
    ///    6002    网络连接出错
    ///    6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
    ///    其它    其它支付错误
    class func switchResultStatus(resultStatus:String){
        switch resultStatus {
        case "9000":
            //支付成功
            print("支付成功")
            break
//        case "8000":
//            //正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//            break
//        case "4000":
//            //订单支付失败
//            break
//        case "5000":
//            //重复请求
//            break
//        case "6001":
//            //用户中途取消
//            print("用户中途取消")
//            break
//        case "6002":
//            //网络连接出错
//            break
//        case "6004":
//            //支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
//            break
        default:
            //其他
            print("支付失败")
            break
        }
    }
}


