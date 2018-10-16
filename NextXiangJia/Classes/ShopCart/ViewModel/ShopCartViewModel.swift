//
//  ShopCartViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/10/15.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
enum JoinCartType:String {
    case goods = "goods"
    case product = "product"
}

class ShopCartViewModel {
    var joinCartModel:JoinCartModel?
}

extension ShopCartViewModel{
    @available(*,message: "dasdasdasdas")
    func requestJoinCart(id goods_id:Int, num goods_num:Int, type:JoinCartType, finishedCallback:@escaping ()->()){
        
        Alamofire.request(JOINCART_URL, method: .post, parameters: ["goods_id":"\(goods_id)" as NSString, "goods_num":"\(goods_num)" as NSString, "type":type.rawValue as NSString]).responseString { (result) in
            if let error = result.error {
                print(error.localizedDescription)
            }else {
                if let resultStr = result.value {
                    var resultJson:JSON = ""
                    if resultStr.first == "p" {
                        resultJson = JSON(parseJSON: String(resultStr.dropFirst(7)))
                        //print(resultJson)
                    }else if resultStr.first == "g" {
                        resultJson = JSON(parseJSON: String(resultStr.dropFirst(5)))
                        //print(resultJson)
                    }
                    self.joinCartModel = JoinCartModel(jsonData: resultJson)
                    finishedCallback()
                }
            }
            
        }
    }
    
}
