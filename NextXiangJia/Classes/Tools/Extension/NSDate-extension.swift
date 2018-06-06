//
//  NSDate-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
extension NSDate {
    //获取1970至今的毫秒数间隔
    class func getCurrentDateInterval() -> String {
        return "\(NSDate().timeIntervalSince1970)"
    }
}
