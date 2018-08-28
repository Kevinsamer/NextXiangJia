//
//  BannerInfo.swift
//  NextXiangJia
//  首页轮播数据类
//  Created by DEV2018 on 2018/8/22.
//  Copyright © 2018年 DEV2018. All rights reserved.
//
//"banner_info":[
//{
//"name":"1",
//"url":"1",
//"img":"upload/2017/12/22/20171222124939273.jpg"
//},
//{
//"name":"2",
//"url":"2",
//"img":"upload/2017/12/22/20171222125026683.jpg"
//}

import Foundation

class BannerInfo:BaseModel {
    @objc var name:String = "" //banner name
    @objc var url:String = ""//banner指向的商品url
    @objc var img:String = ""//图片路径
}
