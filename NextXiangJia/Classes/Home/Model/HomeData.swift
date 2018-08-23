//
//  HomeData.swift
//  NextXiangJia
//  首页数据类
//  Created by DEV2018 on 2018/8/22.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class HomeData: BaseModel {
    @objc var banner_info:[[String:NSObject]]?
        {
        didSet{
            guard let bannersLists = banner_info else { return }
            for dict in bannersLists {
                banners.append(BannerInfo(dict: dict))
            }
        }
    }
    @objc var channel_info:[[String:NSObject]]?
        {
        didSet{
            guard let channelLists = channel_info else { return }
            for dict in channelLists {
                channels.append(ChannelInfo(dict: dict))
            }
        }
    }
    @objc var recommend_info:[[String:NSObject]]?
        {
        didSet{
            guard let recommendLists = recommend_info else { return }
            for dict in recommendLists {
                recommends.append(RecommendInfo(dict: dict))
            }
        }
    }
    @objc var hot_info:[[String:NSObject]]?
        {
        didSet{
            guard let hotLists = hot_info else { return }
            for dict in hotLists {
                hots.append(HotInfo(dict: dict))
            }
        }
    }
    lazy var hots:[HotInfo] = [HotInfo]()
    lazy var recommends:[RecommendInfo] = [RecommendInfo]()
    lazy var channels:[ChannelInfo] = [ChannelInfo]()
    lazy var banners:[BannerInfo] = [BannerInfo]()
}
