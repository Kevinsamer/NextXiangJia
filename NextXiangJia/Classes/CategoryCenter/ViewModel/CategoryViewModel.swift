//
//  CategoryViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/10.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class CategoryViewModel {
    var categorys:[CategoryModel]?
    var categoryGoods:[SearchResultModel]?
}

extension CategoryViewModel {
    func requestCategorys(parentID id:Int?, finishCallback: @escaping () -> ()){
        NetworkTools.requestData(type: .GET, urlString: CATEGORYS_URL, parameters: id==nil ? nil : ["parent_id": "\(id!)" as NSString]) { (result) in
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let resultCode = resultDict["code"] as? Int else {return}
            if resultCode == 200 {
                guard let categorysData = resultDict["result"] as? [[String:NSObject]] else {return}
                self.categorys = [CategoryModel]()
                for category in categorysData {
                    self.categorys?.append(CategoryModel(dict: category))
                }
            }else if resultCode == 201 {
                self.categorys = nil
            }
            finishCallback()
        }
    }
    
    func requestCategoryGoods(categoryID cat:Int, page:Int, finishCallback : @escaping () -> ()){
        NetworkTools.requestData(type: .GET, urlString: CATEGORYLIST_URL, parameters: ["cat" : "\(cat)" as NSString, "page" : "\(page)" as NSString]) { (result) in
            guard let resultDict = result as? [String : NSObject] else {return}
            guard let resultCode = resultDict["code"] as? Int else {return}
            if resultCode == 200 {
                guard let goodsData = resultDict["result"] as? [[String : NSObject]] else {return}
                self.categoryGoods = [SearchResultModel]()
                for goods in goodsData {
                    self.categoryGoods?.append(SearchResultModel(dict: goods))
                }
            }else if resultCode == 201 {
                self.categoryGoods = nil
            }
            finishCallback()
        }
    }
}
