//
//  Announcement.swift
//  NextXiangJia
//  公告消息类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class Announcement:BaseModel {
    @objc var id:Int = 0
    @objc var title:String = ""//公告标题
    @objc var content:String = ""//公告内容
    @objc var time:String = ""//发布时间
}
