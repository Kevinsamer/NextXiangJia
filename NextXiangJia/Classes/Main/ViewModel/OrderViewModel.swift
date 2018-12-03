//
//  OrderViewModel.swift
//  NextXiangJia
//  订单viewModel
//  Created by DEV2018 on 2018/11/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
class OrderViewModel{
    
}

extension OrderViewModel{
    ///请求配送方式
    /// - parameter goodsList:商品数组，用于拼接请求链接
    /// - parameter province:省份代码
    /// - parameter finishCallback:回调函数
    func requestOrderDelivery(goodsList:[ShopCartGoodsModel], province:String,  finishCallback:@escaping (_ kuaiDi:OrderDeliveryModel, _ ziTi:OrderDeliveryModel)->()){
        var url = "\(ORDERDELIVERY_URL)?province=\(province)"
        for goods in goodsList{url += "&goodsId%5B%5D=\(goods.goods_id)"}
        for goods in goodsList{url += "&productId%5B%5D=\(goods.product_id)"}
        for goods in goodsList{url += "&num%5B%5D=\(goods.count)"}
//        print("url:\(url)")
        NetworkTools.requestData(type: MethodType.GET, urlString: url) { (result) in
            //print("result:\(result)")
            let resultJson = JSON(result)
            //print(resultJson)
            let kuaidi = OrderDeliveryModel(jsonData: resultJson["1"])
            let ziti = OrderDeliveryModel(jsonData: resultJson["3"])
//            print(kuaidi.name)
//            print(ziti.name)
            finishCallback(kuaidi, ziti)
        }
    }
    ///根据省份名请求省份id,某些情况会导致地址信息中存储的省市区编号为空，则省市区名也为空，此时向该接口传递的是一个空值，接口会强制返回北京市的编码110000，导致在无省分名称数据的情况下查询到省份id，所以如果传递的省份名时空值，则传值固定为"nil"
    /// - parameter name:省份名
    /// - parameter finishCallback:回调函数
    /// - parameter provinceID:请求到的省份id
    func requestProvinceIDByName(provinceName name:String, finishCallback:@escaping (_ provinceID:String)->()){
        NetworkTools.requestData(type: .POST, urlString: SEARCHPROVINCE_URL, parameters: ["province":"\(name == "" ? "nil" : name)" as NSString]) { (result) in
            let resultJSON = JSON(result)
            //let flag = resultJSON["flag"].stringValue
            let id = resultJSON["area_id"].stringValue
            finishCallback(id)
            
        }
    }
    ///请求预览订单数据:如果是购物车全部结算则不传id、type、num
    /// - parameter isPhone:判断是否为请求result数据的标签位,true则返回生成预览订单的json
    /// - parameter id:商品id,如果有规格则为货品id
    /// - parameter type:商品类型，goods或product
    /// - parameter num:购买数量
    /// - parameter finishCallback:回调函数
    /// - parameter sum:商品总价
    /// - parameter goodsLists:预览订单的商品列表
    /// - parameter tax:税费
    func requestPreviewOrder(isPhone:String, id:String? = nil, type:String? = nil, num:String? = nil, finishCallback:@escaping (_ sum:Double, _ goodsLists:[ShopCartGoodsModel], _ tax:Double)->()){
        NetworkTools.requestData(type: .POST, urlString: PREVIEWORDER_URL, parameters: ["is_phone":"\(isPhone)" as NSString, "id":"\(id ?? "")" as NSString, "type":"\(type ?? "")" as NSString, "num":"\(num ?? "")" as NSString]) { (result) in
            let resultJSON = JSON(result)
            let goodsTotalPrice:Double = resultJSON["sum"].doubleValue
            var goodsList:[ShopCartGoodsModel] = [ShopCartGoodsModel]()
            for goodsJson in resultJSON["goodsList"].arrayValue{
                goodsList.append(ShopCartGoodsModel(jsonData: goodsJson))
            }
            let goodsTax:Double = resultJSON["tax"].doubleValue
            finishCallback(goodsTotalPrice, goodsList, goodsTax)
        }
    }
    
    ///请求提交订单数据,分为单独商品提交和购物车一起提交
    /// - parameter isPhone:判断是否为请求result数据的标签位,true则返回生成预览订单的json
    /// - parameter directGid:如果是购物车全部结算，传0；如果是单个商品，传goodsid或者productId
    /// - parameter directType:商品类型，如果购物车全部结算则不传；如果是单个商品，传goods或者product（对应directGid）
    /// - parameter directNum:购买数量，如果是购物车全部结算则传1；如果是单个商品则传对应的数量
    /// - parameter directPromo:未知参数，暂不使用
    /// - parameter directActiveId:未知参数，传0
    /// - parameter acceptTime:收货时间，默认使用"任意"
    /// - parameter payment:支付方式id，1位预付款支付，10为app拉起支付宝支付，14为app拉起微信支付,暂时默认只能使用支付宝支付
    /// - parameter message:订单留言
    /// - parameter taxes:税费
    /// - parameter taxTitle:发票抬头
    /// - parameter radioAddress:收货地址id
    /// - parameter deliveryId:配送方式id(1为快递配送，3位自提)
    func requestPostOrder(isPhone:String, directGid:Int, directType:String? = nil, directNum:Int, directPromo:String? = nil, directActiveId:Int = 0, acceptTime:String = "任意", payment:Int = 10, message:String, taxes:Double? = nil, taxTitle:String? = nil, radioAddress:Int, deliveryId:Int, finishCallback:@escaping (_ postOrderBackModel:PostOrderResultModel)->()){
        NetworkTools.requestData(type: MethodType.POST, urlString: POSTORDER_URL, parameters: ["is_phone":"\(isPhone)" as NSString, "direct_gid":"\(directGid)" as NSString, "direct_type":"\(directType ?? "")" as NSString, "direct_num":"\(directNum)" as NSString, "direct_promo":"\(directPromo ?? "")" as NSString, "direct_active_id":"\(directActiveId)" as NSString, "accept_time":"任意" as NSString, "payment":"\(payment)" as NSString, "message":"\(message)" as NSString, "taxes":"\(taxes ?? 0)" as NSString, "radio_address":"\(radioAddress)" as NSString, "delivery_id":"\(deliveryId)" as NSString, "tax_title":"\(taxTitle ?? "")" as NSString]) { (result) in
            print(result)
            let resultJson = JSON(result)
            let resultModel = PostOrderResultModel(jsonData: resultJson)
            finishCallback(resultModel)
        }
    }
    
    ///调起支付方法接口
    /// - parameter orderId:接收订单id数组，处理为id_id_id_id的字符串
    /// - parameter paymentId:支付方式id,暂时默认为支付宝支付
    func requestDoPay(orderId:[Int], paymentId:Int, finishCallback:@escaping ()->()){
        var orderIds:String = "\(orderId[0])"
        if orderId.count > 1 {
            for i in 1..<orderId.count{
                orderIds += "_\(orderId[i])"
            }
        }
        NetworkTools.requestData(type: .POST, urlString: DOPAY_URL, parameters: ["payment_id":"\(paymentId)" as NSString, "order_id":"\(orderIds)" as NSString]) { (result) in
            finishCallback()
        }
        
    }
}
