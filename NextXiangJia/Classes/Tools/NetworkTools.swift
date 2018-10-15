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
let CATEGORYS_URL = BASE_URL + "app/typeleft"//分类数据接口  可选参数父分类id
let LOGIN_URL = BASE_URL + "app/login_act"//登录接口
let LOGINOUT_URL = BASE_URL + "simple/logout"//退出登录接口
let REGISTER_URL = BASE_URL + "app/reg_act"//注册接口
let AUTHCODE_URL = BASE_URL + "site/getCaptcha/random"//验证码图片链接
let JOINCART_URL = BASE_URL + "simple/join"//传id(商品或货品),数量,类型(goods/product)
let REMOVECART_URL = BASE_URL + "simple/removeCart"//传id(商品或货品),类型(goods/product)

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
