//
//  ChannelInfo.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/8/23.
//  Copyright © 2018年 DEV2018. All rights reserved.
//
//"channel_info":[
//{
//"id":"1",
//"name":"最热",
//"img":"upload/app/icon_home_hot.png",
//"gride":"3"
//},
//{
//"id":"2",
//"name":"最新",
//"img":"upload/app/icon_home_new.png",
//"gride":"4"
//},
//{
//"id":"5",
//"name":"发现",
//"img":"upload/app/icon_home_live.png",
//"gride":"7"
//},
//{
//"id":"6",
//"name":"生活",
//"img":"upload/app/icon_home_classify.png",
//"gride":"1"
//}
//]

import Foundation

class ChannelInfo:BaseModel {
    @objc var id:Int = 0
    @objc var name:String = ""//Channel name
    @objc var img:String = ""//Channel img 路径
    @objc var gride:Int = 0
}
