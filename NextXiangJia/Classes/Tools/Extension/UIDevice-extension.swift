//
//  UIDevice-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/4/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import  UIKit
extension UIDevice{
    //判断是否为IphoneX
    public func isX() -> Bool{
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}
