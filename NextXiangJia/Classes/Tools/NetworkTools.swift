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
let HOMEDATA_URL = BASE_URL + "app/home"//首页数据接口
let GOODINFO_URL = BASE_URL + "app/goodinfo"//商品详情数据库接口,传商品id
let GOODPRODUCT_URL = BASE_URL + "app/getSpecification"//规格接口,传商品id
let GOODWEBDETAIL_URL = BASE_URL + "siteapp/productsapp/id/"//图文详情接口，直接拼接商品id
let SEARCH_URL = BASE_URL + "app/getSearch"//搜索接口 传搜索内容和分页数
let CATEGORYLIST_URL = BASE_URL + "app/getGoodslist"//分类搜索结果  传分类id和分页数
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
