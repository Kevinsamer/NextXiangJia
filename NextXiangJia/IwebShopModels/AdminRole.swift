//
//  AdminRole.swift
//  NextXiangJia
//  管理员权限类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class AdminRole:BaseModel {
    @objc var id:Int = 0
    @objc var name:String = ""//用户名
    @objc var rights:String = ""//权限
    @objc var is_del:Int = 0//删除状态 1删除0正常
}
