//
//  Double-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/8/31.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

extension Double {
    ///默认值为精确到小数点后两位数
    func format(f:String) ->String
    {
        return String(format:"%\(f)f",self)
    }
}
