//
//  Attribute.swift
//  NextXiangJia
//  属性类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class Attriute:BaseModel {
    @objc var id:Int = 0 //属性id
    @objc var model_id:Int = 0//模型id
    @objc var type:Int = 0//输入空间的类型 1单选 2复选 3下拉 4输入框
    @objc var name:String = ""//名称
    @objc var value:String = ""//属性值 逗号分隔
    @objc var search:Int = -1//是否支持搜索  0不支持 1支持
}
