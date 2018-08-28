//
//  NetworkTools.swift
//  NextXiangJia
//  网络模块
//  Created by DEV2018 on 2018/6/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Alamofire

let BASE_URL = "http://192.168.108.223/"
let HOMEDATA_URL = BASE_URL + "app/home"
let GOODINFO_URL = BASE_URL + "app/goodinfo"

enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    class func requestData(type : MethodType, urlString : String, parameters : [String : NSString]? = nil, finishCallback : @escaping (_ result : Any) -> ()){
        //1.判断请求方法
        let method = type == .GET ? Alamofire.HTTPMethod.get : Alamofire.HTTPMethod.post
        //2.发送请求
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                //3.错误处理
                print("error:\(response.result.error ?? "出现错误" as! Error )")
                return
            }
            //4.结果返回
            finishCallback(result as Any)
        }
    }
    
}
