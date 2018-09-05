
//
//  GoodsTypeModel.swift
//  shoppingcart
//
//  Created by  on 2018/2/5.
//  Copyright © 2018年  All rights reserved.
//

import UIKit

class GoodsTypeModel: NSObject {
    var selectIndex = -1
    var typeName = ""
    var typeArray = NSArray()
    override init() {
        super.init()
    }
    convenience init(selectIndex:Int, typeName:String, typeArray:NSArray) {
        self.init()
        self.selectIndex = selectIndex
        self.typeName = typeName
        self.typeArray = typeArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
