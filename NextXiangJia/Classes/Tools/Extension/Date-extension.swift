//
//  Date-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/11/8.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

extension Date{
    static func now() -> Date{
        let now = Date()
        let zone = TimeZone.current
        let integer = zone.secondsFromGMT(for: now)
        return now.addingTimeInterval(TimeInterval(integer))
    }
}
