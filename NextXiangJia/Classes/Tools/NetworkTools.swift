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
let SEARCH_URL = BASE_URL + "app/getSearch"//搜索接口 传搜索内容和分页数,价格上下限(min_price/max_pirce:Int)
let CATEGORYLIST_URL = BASE_URL + "app/getGoodslist"//分类搜索结果  传分类id和分页数
let CATEGORYS_URL = BASE_URL + "app/typeleft"//分类数据接口  可选参数父分类id
let LOGIN_URL = BASE_URL + "app/login_act"//登录接口
let LOGINOUT_URL = BASE_URL + "simple/logout"//退出登录接口
let REGISTER_URL = BASE_URL + "app/reg_act"//注册接口
let AUTHCODE_URL = BASE_URL + "site/getCaptcha/random"//验证码图片链接
let JOINCART_URL = BASE_URL + "simple/joinCart"//传id(商品或货品),数量,类型(goods/product)
let REMOVECART_URL = BASE_URL + "simple/removeCart"//传id(商品或货品),类型(goods/product)
let CARTINFO_URL = BASE_URL + "app/cart"//购物车数据接口
let GETADDRESS_URL = BASE_URL + "app/getaddress"//得到用户所有地址，传id(user_id)
let DEFAULTADDRESS_URL = BASE_URL + "ucenter/address_default"//设置默认地址接口,传地址id
let DELADDRESS_URL = BASE_URL + "ucenter/address_del"//删除地址接口,传地址id
let ADDADDRESS_URL = BASE_URL + "simple/address_add"//添加地址接口
let ISDEFAULTADDRESS_URL = BASE_URL + "app/getDefaultaddress"//获得用户默认地址接口,传递用户id
///根据省份名获取省份id的接口，传省份名
let SEARCHPROVINCE_URL = BASE_URL + "block/searchProvince"
///获得配送方式
let ORDERDELIVERY_URL = BASE_URL + "block/order_delivery"
///预览订单数据接口(购物车整体结算传值为is_phone=true,商品单个结算时传值增加id:商品id或者货品id,type:goods或者product,num:购买数量)
let PREVIEWORDER_URL = BASE_URL + "simple/cart2"
///提交订单数据接口
let POSTORDER_URL = BASE_URL + "simple/cart3"
///支付接口-废弃
let DOPAY_URL = BASE_URL + "block/doPay"
///我的订单数据接口(传用户id 分页数)
let MYORDERLIST_URL = BASE_URL + "app/getOrderList"
///订单商品列表接口(传订单id,is_send 0未发货  1已发货)
let ORDERGOODS_URL = BASE_URL + "app/iosgetordergoods"
///订单详情接口(传订单id，is_phone)
let ORDERDETAIL_URL = BASE_URL + "ucenter/order_detail"
///订单取消|确认收货接口（传订单id，op:cancel/confirm）
let ORDERSTATUS_URL = BASE_URL + "ucenter/order_status"
///修改订单状态接口，(传订单id和status)
let UPDATEORDER_URL = BASE_URL + "app/updateOrder"
//待使用
//TODO:将修改密码php代码的中文返回码替换为数字返回码，在app中处理相应的返回码
///修改密码接口(传原密码、新密码、重复新密码)
let PASSWORDEDIT_URL = BASE_URL + "app/password_edit"

let COMMENTS_URL = BASE_URL + "comment_ajax"//?goods_id=1&page=1

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
            if response.result.isSuccess {
                guard let result = response.result.value else {
                    //3.错误处理
                    print("error:\(response.result.error ?? "出现错误" as! Error )")
                    return
                }
                //4.结果返回
                finishCallback(result as Any)
            }else{
                print("error:\(response.result.error ?? "出现错误" as! Error )")
            }
            
        }
    }
    
}
