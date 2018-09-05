//
//  HomeViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/6/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class HomeViewModel {
    lazy var tagGroup : [TagData] = [TagData]()
    var homeDataGroup : HomeData?
    
}

//MARK: - 首页网络请求
extension HomeViewModel {
    func requestBannerData(finishCallback : @escaping () -> ()){
        //swift异步操作聚合同步
//        let group = DispatchGroup()
//        group.enter()
//        //每个异步操作都嵌套在enter和leave中
//        group.leave()
//        group.notify(queue: DispatchQueue.main) {
//            //所有异步操作完成
//        }	
        NetworkTools.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: ["limit":"4","offset":"0","time":NSDate.getCurrentDateInterval() as NSString]) { (result) in
            //print(result)
            guard let resultDict = result as? [String : NSObject] else {
                return
            }
            guard let tags = resultDict["data"] as? [[String : NSObject]] else {
                return
            }
            //print(tags)
            for tag in tags {
                let trump = TagData(dict: tag)
                self.tagGroup.append(trump)
            }
            //所有数据请求完毕后回调
            finishCallback()
        }
    }
    
    func requestHomeData(finishCallback : @escaping () -> ()){
        NetworkTools.requestData(type: .GET, urlString: HOMEDATA_URL) { (result) in
            //print(result)
            guard let resultDict = result as? [String : NSObject] else { return }
            guard let resultCode = resultDict["code"] as? Int else { return }
            if resultCode == 200 {
                guard let homeDatas = resultDict["result"] as? [String:NSObject] else { return }
                //print(homeDatas.count)
                self.homeDataGroup = HomeData(dict: homeDatas)
                finishCallback()
            }else if resultCode == 201 {
                
            }
        }
    }
    
}
