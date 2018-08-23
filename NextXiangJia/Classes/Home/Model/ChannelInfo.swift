//
//  ChannelInfo.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/8/23.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class ChannelInfo:BaseModel {
    @objc var id:Int = 0
    @objc var name:String = ""//Channel name
    @objc var img:String = ""//Channel img 路径
    @objc var gride:Int = 0
}
