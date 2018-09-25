//
//  MyRegex.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/18.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
let usernameRegex = "^[a-zA-Z0-9\\u4E00-\\u9FA5]{2,20}"
//let passwordRegex = "^[a-zA-Z0-9_/u4e00-/u9fa5]+$"

struct MyRegex{
    let regex:NSRegularExpression?
    
    init(_ pattern:String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool{
        if let matchs = regex?.matches(in: input, options: [], range: NSMakeRange(0, input.count)){
            return matchs.count > 0
        }else{
            return false
        }
    }
}
//eg:
//let matcher = MyRegex(usernameRegex)
//let username = self.inputField.text!
//if matcher.match(input: username){
//    print("匹配")
//}else{
//    print("error")
//}

