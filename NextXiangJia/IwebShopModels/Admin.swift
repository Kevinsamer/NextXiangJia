//
//  Admin.swift
//  NextXiangJia
//  管理员用户类
//  Created by DEV2018 on 2018/8/6.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class Admin:BaseModel {
    @objc var id:Int = 0
    @objc var admin_name:String = ""//用户
    @objc var password:String = ""//密码
    @objc var role_id:Int = -1//角色id
    @objc var create_time:String = ""//创建时间
    @objc var email:String = ""//邮箱
    @objc var last_ip:String = ""//最后登录的ip
    @objc var lst_time:String = ""//最后登录的时间
    @objc var is_del:Int = 0//删除状态  1删除0正常
}
