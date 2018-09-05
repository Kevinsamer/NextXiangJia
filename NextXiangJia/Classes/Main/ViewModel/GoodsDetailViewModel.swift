//
//  GoodsDetailViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/8/24.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class GoodsDetailViewModel {
    var goodsInfo:GoodInfo?//商品信息
    var goodsProducts:[GoodsProduct]?//货品信息
    var productSpecs:[[ProductSpec]]?//规格信息
}
//发送网络请求
extension GoodsDetailViewModel {
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
