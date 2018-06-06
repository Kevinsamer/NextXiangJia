//
//  RoomData.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class RoomData: NSObject {
    @objc var room_id : Int = 0//房间id
    @objc var show_time : Int = 0
    @objc var hn : Int = 0
    @objc var vertical_src : String = ""
    @objc var cate_id : Int = 0
    @objc var avatar_small : String = ""
    @objc var specific_status : Int = 0
    @objc var room_src : String = ""//房间缩略图
    @objc var room_name :String = ""//房间名
    @objc var game_name : String = ""//游戏名
    @objc var isVertical : Int = 0
    @objc var owner_uid : Int = 0
    @objc var nickname : String = ""//主播名
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //print("RoomData有未解析的数据")
    }
}
