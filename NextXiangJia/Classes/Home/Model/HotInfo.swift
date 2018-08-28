//
//  HotInfo.swift
//  NextXiangJia
//  热点商品类
//  Created by DEV2018 on 2018/8/23.
//  Copyright © 2018年 DEV2018. All rights reserved.
//
//"hot_info":[
//{
//"img":"upload/2017/12/29/20171229212159215.jpg",
//"sell_price":"0.00",
//"name":"测试",
//"id":"191",
//"market_price":"1.00"
//},
//{
//"img":"upload/2017/06/21/20170621155503356.jpg",
//"sell_price":"588.00",
//"name":"高塔商贸·青花国粹，焕然生机，若非青花之蓉的精致，又怎能映衬国韵大气之美。",
//"id":"3",
//"market_price":"588.00"
//},
//{
//"img":"upload/2017/08/03/20170803091626747.jpg",
//"sell_price":"299.00",
//"name":"高塔商贸·乐扣格纳斯6+6套组",
//"id":"18",
//"market_price":"299.00"
//},
//{
//"img":"upload/2017/07/03/20170703093802547.jpg",
//"sell_price":"199.00",
//"name":"高塔商贸·爱格免踩拖把，省时省力，更环保。组合（2杆，3圆头，3方头，2个拖头）",
//"id":"9",
//"market_price":"199.00"
//},
//{
//"img":"upload/2017/07/19/20170719113107744.jpg",
//"sell_price":"82.00",
//"name":"武乡吾土·百合",
//"id":"44",
//"market_price":"100.00"
//},
//{
//"img":"upload/2017/08/03/20170803091448755.jpg",
//"sell_price":"199.00",
//"name":"高塔商贸·可折叠可伸缩 防滑无痕衣架",
//"id":"19",
//"market_price":"199.00"
//},
//{
//"img":"upload/2017/07/03/20170703095913127.jpg",
//"sell_price":"268.00",
//"name":"高塔商贸·国之安泰是和，家人安康是和，好酒共分享是和。一口，酒香扑鼻；两口，淳甜齿颊；三口，浓香沁心",
//"id":"15",
//"market_price":"268.00"
//},
//{
//"img":"upload/2017/07/03/20170703094232702.jpg",
//"sell_price":"199.00",
//"name":"高塔商贸·免手洗平板拖把，特惠组合装包括:3把拖把+8块拖布+3个小刷子=199元",
//"id":"11",
//"market_price":"199.00"
//}
//]

import Foundation

class HotInfo:BaseModel {
    @objc var img:String = ""//图片路径
    @objc var sell_price:String = ""//销售价格
    @objc var name:String = ""//商品名
    @objc var id:Int = 0//商品id
    @objc var market_price:String = ""//原价
}
