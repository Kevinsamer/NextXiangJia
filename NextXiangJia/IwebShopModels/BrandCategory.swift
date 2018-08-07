//
//  BrandCategory.swift
//  NextXiangJia
//  品牌分类表
//  Created by DEV2018 on 2018/8/7.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class BrandCategory:BaseModel {
    @objc var id:Int = 0//分类id
    @objc var name:String = ""//分类名称
    @objc var goods_category_id:Int = 0//商品分类id
}
