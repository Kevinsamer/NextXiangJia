//
//  RecommendInfo.swift
//  NextXiangJia
//  推荐商品类
//  Created by DEV2018 on 2018/8/23.
//  Copyright © 2018年 DEV2018. All rights reserved.
//
//"recommend_info":[
//{
//"img":"upload/2017/11/06/20171106131330863.jpg",
//"sell_price":"40.00",
//"name":"丰县大沙河苹果甜脆味美爽口多汁（今天下单明早果园直发）",
//"id":"162",
//"market_price":"55.00"
//},
//{
//"img":"upload/2017/11/29/20171129135010805.jpg",
//"sell_price":"198.00",
//"name":"【武进名点】竺山湖鲜鱼饼（顺丰包邮）",
//"id":"185",
//"market_price":"268.00"
//},
//{
//"img":"upload/2017/12/29/20171229212159215.jpg",
//"sell_price":"0.00",
//"name":"测试",
//"id":"191",
//"market_price":"1.00"
//},
//{
//"img":"upload/2017/11/29/20171129145543896.jpg",
//"sell_price":"60.00",
//"name":"【武进名点】兴农麻糕（盒装，每盒12个，江浙沪包邮）",
//"id":"190",
//"market_price":"80.00"
//},
//{
//"img":"upload/2017/11/29/20171129142806783.jpg",
//"sell_price":"35.00",
//"name":"【武进名点】米之果麻糕（两盒包邮 ）",
//"id":"188",
//"market_price":"50.00"
//},
//{
//"img":"upload/2017/11/29/20171129144605759.jpg",
//"sell_price":"80.00",
//"name":"【武进名点】兴农葱油饼（盒装，江浙沪包邮，20块一盒）",
//"id":"189",
//"market_price":"100.00"
//}
//],

import Foundation

class RecommendInfo:BaseModel {
    @objc var img:String = ""//图片路径
    @objc var sell_price:String = ""//销售价格
    @objc var name:String = ""//商品名
    @objc var id:Int = 0//商品id
    @objc var market_price:String = ""//原价
}
