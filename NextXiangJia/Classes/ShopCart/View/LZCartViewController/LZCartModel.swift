//
//  LZCartModel.swift
//  CartDemo_Swift
//
//  Created by Artron_LQQ on 16/6/27.
//  Copyright © 2016年 Artup. All rights reserved.
//

import UIKit

class LZCartModel: NSObject {
    var shop:String?
    var select: Bool?
    var number: Int = 0
    var price: String?
    var indexPath: IndexPath?
    
    var name:String?
    var date:String?
    var image:UIImage?
    
    public func showInfo(){
        if testMode{
            print("name:\(name) + num:\(number)")
        }
    }
    
}
