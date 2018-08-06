//
//  AdManage.swift
//  NextXiangJia
//  广告记录表
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class AdManage:BaseModel {
    @objc var id:Int = 0
    @objc var name:String = ""//广告名
    @objc var type:Int = 0//广告类型  1img 2flash 3文字 4code
    @objc var position_id:Int = 0//广告位id
    @objc var link:String = ""//链接地址
    @objc var order:Int = 0//排列顺序
    @objc var start_time:String = ""//开始时间
    @objc var end_time:String = ""//结束时间
    @objc var content:String = ""//广告内容 图片、文字、flash路径、code等
    @objc var ad_description:String = ""//描述
    @objc var goods_cat_id:Int = 0//绑定的商品分类id
}
