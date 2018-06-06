//
//  DouyuHotCateData.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
/*
 请求斗鱼数据，用来测试网络模块
 */
class TagData: NSObject {
    @objc var icon_url : String = ""//板块图标
    @objc var small_icon_url : String = ""//小图标
    @objc var tag_name : String = ""//版块名
    @objc var tag_id : Int = 0//板块id
    @objc var push_vertical_screen : Int = 0
    @objc var push_nearby : Int = 0
    @objc var room_list : [[String : NSObject]]?
        {
        didSet{
            guard let roomLists = room_list else { return }
            for dict in roomLists {
                rooms.append(RoomData(dict: dict))
            }
        }
    }
    lazy var rooms : [RoomData] = [RoomData]()
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    //重写该方法防止有未解析数据报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //print("TagData有未解析数据")
    }
    
//    override func setValue(_ value: Any?, forKey key: String) {
//        if key == "room_list" {
//            if let roomListsDict = value as? [[String : NSObject]] {
//                for dict in roomListsDict {
//                    rooms.append(RoomData(dict: dict))
//                }
//            }
//        }
//    }
}
