//
//  BannerInfo.swift
//  NextXiangJia
//  首页轮播数据类
//  Created by DEV2018 on 2018/8/22.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class BannerInfo:BaseModel {
    @objc var name:String = "" //banner name
    @objc var url:String = ""//banner指向的商品url
    @objc var img:String = ""//图片路径
}
