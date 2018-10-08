//
//  CGRect-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/30.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

extension CGRect {
    init(view:UIView, viewSize size:CGSize) {
        self.init(origin: view.frame.origin, size: size)
    }
}
