//
//  AdPosition.swift
//  NextXiangJia
//  广告位记录类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class AdPosition:BaseModel {
    @objc var id:Int = 0
    @objc var name:String = ""//广告位名称
    @objc var width:Int = 0//广告位宽度，px或%
    @objc var height:Int = 0//广告位高度，px或%
    @objc var fashion:Int = -1//1.轮播   2.随即
    @objc var status:Int = -1//状态  1:开启  2：关闭
}
