//
//  AccountLog.swift
//  NextXiangJia
//  账户余额日志类
//  Created by DEV2018 on 2018/8/2.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class AccountLog:BaseModel {
    @objc var id:Int = 0//日志id
    @objc var admin_id:Int = 0//管理员id
    @objc var user_id:Int = 0//用户id
    @objc var type:Int = 0//余额变化类型 0增加 1减少
    @objc var event:Int = 0//操作类型
    @objc var time:String = ""//发生时间
    @objc var amount:Double = 0.0//金额  带正负号
    @objc var amount_log:Double = 0.0//增减后的余额
    @objc var note:String = ""//备注  用户[111111]使用余额支付购买，订单[20171222140325329724]，金额：-405元
}
