//
//  Brand.swift
//  NextXiangJia
//  品牌类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class Brand:BaseModel {
    @objc var id:Int = 0//品牌id
    @objc var name:String = ""//品牌名称
    @objc var logo:String = ""//logo地址
    @objc var url:String = ""//网址
    @objc var brand_description:String = ""//描述
    @objc var sort:Int = -1//排序
    @objc var category_ids:Int = 0//品牌分类，逗号分隔id
}
