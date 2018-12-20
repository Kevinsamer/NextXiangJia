//
//  ShopCartViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/10/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
///加入购物车的商品类型：商品或货品
enum JoinCartType:String {
    case goods = "goods"
    case product = "product"
}

class ShopCartViewModel {
    ///加入购物车的返回model
    var joinCartModel:JoinCartModel?
    ///购物车model
    var shopCartModel:ShopCartModel?
    ///从购物车删除商品的model
    var removeCartModel:RemoveCartModel?
}

extension ShopCartViewModel{
    ///请求加入购物车并返回加入结果
    ///分两种情况:
    ///1.在购物车和商品详情页中添加商品，此时num传正数
    ///2.在购物车中减少商品数量，此时num传负数
    /// - parameter id: 商品id.
    /// - parameter num: 商品数量.
    /// - parameter type: JoinCartType.goods/JoinCartType.products,商品类型，分为有规格和无规格，有规格为product,无规格为goods
    /// - parameter finishedCallback:回调函数，请求结束后调用
    func requestJoinCart(id goods_id:Int, num goods_num:Int, type:JoinCartType, finishedCallback:@escaping ()->()){
        
        Alamofire.request(JOINCART_URL, method: .post, parameters: ["goods_id":"\(goods_id)" as NSString, "goods_num":"\(goods_num)" as NSString, "type":type.rawValue as NSString]).responseString { (result) in
            if let error = result.error {
                print(error.localizedDescription)
            }else {
                if let resultStr = result.value {
                    var resultJson:JSON = ""
                    if resultStr.first == "p" {
                        resultJson = JSON(parseJSON: String(resultStr.dropFirst(7)))
                        //print(resultJson)
                    }else if resultStr.first == "g" {
                        resultJson = JSON(parseJSON: String(resultStr.dropFirst(5)))
                        //print(resultJson)
                    }
                    self.joinCartModel = JoinCartModel(jsonData: resultJson)
                    finishedCallback()
                }
            }
        }
    }
    
    ///请求删除购物车的一种商品
    /// - parameter id:商品id
    /// - parameter type: JoinCartType.goods/JoinCartType.products,商品类型，分为有规格和无规格，有规格为product,无规格为goods
    /// - parameter finishedCallback:回调函数，请求结束后调用
    /// - parameter remove:请求结束后服务器返回的移除结果model
    func requestRemoveCart(goods_id id:Int, type:JoinCartType,finishedCallback:@escaping (_ remove:RemoveCartModel)->()){
        NetworkTools.requestData(type: MethodType.POST, urlString: REMOVECART_URL, parameters: ["goods_id":"\(id)" as NSString, "type":"\(type)" as NSString]) { (result) in
            self.removeCartModel = nil
            let json = JSON(result)
            self.removeCartModel = RemoveCartModel(jsonData: json)
            finishedCallback(RemoveCartModel(jsonData: json))
        }
    }
    
    ///请求购物车数据
    /// - parameter finishedCallback:请求回调
    func requestCart(finishedCallback: @escaping ()->()){
        NetworkTools.requestData(type: .GET, urlString: CARTINFO_URL) { (result) in
            self.shopCartModel = nil
            let json = JSON(result)
            let resultCode = json["code"].intValue
            if resultCode == 200 {
                self.shopCartModel = ShopCartModel(jsonData: json["result"])
//                for goods in (self.shopCartModel?.goodsLists)! {
////                    for spec in goods.specArray{
////                        print(spec.name + spec.value)
////                    }
////                    print(goods.spec_array)
//                }
            }else if resultCode == 201{
                print(json["result"])
            }
            finishedCallback()
        }
    }
    
}
