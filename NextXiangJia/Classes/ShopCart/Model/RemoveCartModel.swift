//
//  RemoveCartModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/10/19.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import SwiftyJSON
class RemoveCartModel{
    var isError:Bool?
    var message:String?
    var data:String?
    
    init(jsonData:JSON) {
        isError = jsonData["isError"].boolValue
        message = jsonData["message"].stringValue
        data = jsonData["data"].stringValue
    }
    
//    空参构造
//    init() {
//
//    }
}
