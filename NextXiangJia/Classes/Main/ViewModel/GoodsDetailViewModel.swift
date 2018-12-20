//
//  GoodsDetailViewModel.swift
//  NextXiangJia
//  商品数据viewmodel
//  Created by DEV2018 on 2018/8/24.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class GoodsDetailViewModel {
    ///商品信息
    var goodsInfo:GoodInfo?
    ///货品信息
    var goodsProducts:[GoodsProduct]?
    ///规格信息
    var productSpecs:[[ProductSpec]]?
}
//发送网络请求
extension GoodsDetailViewModel {
    ///请求商品详情页数据
    /// - parameter id:商品id
    /// - parameter finishCallback:回调函数,获取并操作服务器回复的数据
    func requestGoodsDetail(goodsID id : Int, finishCallback : @escaping () -> ()) {
        NetworkTools.requestData(type: .GET, urlString: GOODINFO_URL, parameters: ["id" : "\(id)" as NSString]) { (result) in
//            print(result)
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultCode = resultDict["code"] as? Int else { return }
            if resultCode == 200 {
                guard let goodsData = resultDict["result"] as? [String : NSObject] else { return }
                self.goodsInfo = GoodInfo(dict: goodsData)
                finishCallback()
            }
        }
    }
    ///请求商品规格数据
    /// - parameter id:商品id
    /// - parameter finishCallback:回调函数
    func requestGoodsProducts(goodsID id : Int, finishCallback : @escaping () -> ()){
        NetworkTools.requestData(type: .GET, urlString: GOODPRODUCT_URL, parameters: ["id" : "\(id)" as NSString]) { (result) in
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultCode = resultDict["code"] as? Int else { return }
            if resultCode == 200 {
                //有规格数据
                guard let productData = resultDict["result"] as? [[String : NSObject]] else { return }
                self.goodsProducts = [GoodsProduct]()
                self.productSpecs = [[ProductSpec]]()
                for product in productData {
                    self.goodsProducts?.append(GoodsProduct(dict: product))
                }
                for product in self.goodsProducts! {
                    self.productSpecs?.append(product.productSpecs)
                }
                finishCallback()
            }else if resultCode == 201 {
                //无规格数据
                self.goodsProducts = nil
            }
        }
    }
}
