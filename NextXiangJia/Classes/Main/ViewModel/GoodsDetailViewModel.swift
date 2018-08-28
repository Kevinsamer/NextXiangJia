//
//  GoodsDetailViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/8/24.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class GoodsDetailViewModel {
    var goodsInfo:GoodInfo?
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
}
