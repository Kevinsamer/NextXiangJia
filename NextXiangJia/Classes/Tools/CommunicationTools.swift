//
//  CommunicationTools.swift
//  NextXiangJia
//  组件通讯工具
//  Created by DEV2018 on 2018/6/13.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import SwiftEventBus
enum Communications: String {
    case SearchResult = "SearchResult"
}
class CommunicationTools {
    
    class func post(duration: TimeInterval = 0.01, name: Communications,data: Any?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            SwiftEventBus.post(name.rawValue, sender: data)
        }
    }
    
    class func getCommunications(_ target: AnyObject, name: Communications, handler: @escaping ((Notification?) -> Void)){
        SwiftEventBus.on(target, name: name.rawValue, queue: OperationQueue.current, handler: handler)
    }
}
