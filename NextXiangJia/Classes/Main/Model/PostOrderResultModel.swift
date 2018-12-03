//
//  PostOrderResultOrder.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/11/16.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class PostOrderResultModel{
    ///订单id数组
    var orderIdArray:[Int] = [Int]()
    ///最后一个订单数据
    var dataArray:PostOrderModel?
    ///订单编号数组
    var orderNoArray:[String] = [String]()
    ///最后的总价
    var final_sum:Double = 0
    
    init(jsonData:JSON) {
        orderIdArray = jsonData["orderIdArray"].arrayObject as! [Int]
        dataArray = PostOrderModel(jsonData: jsonData["dataArray"])
        orderNoArray = jsonData["orderNoArray"].arrayObject as! [String]
        final_sum = jsonData["final_sum"].doubleValue
    }
}
