//
//  HomeViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class HomeViewModel {
    private lazy var tagGroup : [TagData] = [TagData]()
}

//MARK: - 首页网络请求
extension HomeViewModel {
    func requestBannerData(){
        NetworkTools.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: ["limit":"4","offset":"0","time":NSDate.getCurrentDateInterval() as NSString]) { (result) in
            //print(result)
            guard let resultDict = result as? [String : NSObject] else {
                return
            }
            guard let tags = resultDict["data"] as? [[String : NSObject]] else {
                return
            }
            print(tags)
            for tag in tags {
                let trump = TagData(dict: tag)
                self.tagGroup.append(trump)
            }
            for tag in self.tagGroup {
                print(tag.tag_name)
                for room in tag.rooms {
                    print(room.room_name)
                }
                print("--------")
            }
        }
    }
    
    func requestCollectionData(){
        
    }
}
