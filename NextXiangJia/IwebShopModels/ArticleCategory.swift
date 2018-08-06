//
//  ArticleCategory.swift
//  NextXiangJia
//  文章分类类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class ArticleCategory:BaseModel {
    @objc var id:Int = 0
    @objc var name:String = ""//分类名称
    @objc var parent_id:Int = 0//父分类
    @objc var issys:Int = 0//系统分类
    @objc var sort:Int = 0//排序
    @objc var path:String = ""//路径
}
