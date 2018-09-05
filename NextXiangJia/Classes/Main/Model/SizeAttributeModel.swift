
//
//  SizeAttributeModel.swift
//  shoppingcart
//
//  Created by  on 2018/2/5.
//  Copyright © 2018年  All rights reserved.
//

import UIKit

class SizeAttributeModel: NSObject {
    var goodsNo = "" //商品编号
    var sizeid = ""   //属性组合id
    var imageId = ""  //缩略图id
    var price = "" //现价
    var originalPrice = "" //原价
    var stock = ""   //库存
    var count = ""  //数量
    var value = "" //可能规格不同商品图片也不同
    var type = 1//1文字  2图片
    var productId = "-1"//货品id
    var productNo = "-1"//货品编号
    var productType = 0//规格类型：0该商品无规格  1该商品有规格
}
