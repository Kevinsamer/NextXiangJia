//
//  UIColor-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/2/27.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience init(r: CGFloat , g: CGFloat , b: CGFloat , alpha: CGFloat) {
        
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
}
