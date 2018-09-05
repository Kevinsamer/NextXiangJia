//
//  GoodsSpec.swift
//  NextXiangJia
//  商品规格类
//  Created by DEV2018 on 2018/8/28.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class GoodsSpec: BaseModel {
    @objc var id:Int = 0//规格id
    @objc var name:String = ""//规格名称
    @objc var value:String = ""//规格值
    @objc var type:Int = 1//显示类型 1文字 2图片
    @objc var note:String = ""//备注说明
    @objc var is_del = 0//是否删除 1删除 0未删除
    @objc var seller_id = 0//商家id
}
