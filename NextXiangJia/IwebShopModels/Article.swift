//
//  Article.swift
//  NextXiangJia
//  文章表
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class Article:BaseModel {
    @objc var id:Int = 0
    @objc var title:String = ""//标题
    @objc var content:String = ""//内容
    @objc var category_id:Int = 0//分类id
    @objc var create_time:String = ""//发布时间
    @objc var keywords:String = ""//关键词
    @objc var article_description:String = ""//描述
    @objc var visibility:Int = -1//是否显示 0不显示  1显示
    @objc var top:Int = 0//置顶
    @objc var sort:Int = 0//排序
    @objc var style:Int = -1//标题字体  0正常 1粗体 2斜体
    @objc var color:String = ""//标题颜色
}
