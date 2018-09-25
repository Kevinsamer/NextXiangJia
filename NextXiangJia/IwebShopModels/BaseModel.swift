//
//  BaseModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/8/2.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class BaseModel:NSObject {
    
    init(dict:[String: NSObject]){
        super.init()
        setValuesForKeys(dict)
    }
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("有未解析json数据,key=\(key)")
    }
    
    override func setValuesForKeys(_ keyedValues: [String : Any]) {
        
        if !keyedValues.isEmpty {
            super.setValuesForKeys(keyedValues)
        }
    }
    
    override func setNilValueForKey(_ key: String) {
        print(key)
    }
    
}
