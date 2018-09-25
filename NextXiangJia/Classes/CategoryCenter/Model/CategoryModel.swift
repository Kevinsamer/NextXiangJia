//
//  CategoryModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/10.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class CategoryModel:BaseModel {
    @objc var id:Int = 0
    @objc var name:String = ""//分类名称
    @objc var parent_id:Int = 0  //父分类id
    @objc var sort:Int = 0//排序
    @objc var visibility:Int = 1//首页是否显示1显示   0不显示
    @objc var keywords:String = ""//seo关键词
    @objc var descript:String = ""//seo描述
    @objc var title:String = ""//seo标题
    @objc var seller_id:Int = 0//商家id
}
