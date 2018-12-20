//
//  SearchResultViewModel.swift
//  NextXiangJia
//  搜索viewmodel
//  Created by DEV2018 on 2018/9/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class SearchResultViewModel {
    ///搜索结果数据
    var searchResults:[SearchResultModel]?
    ///分类搜索结果数据
    var categoryResults:[SearchResultModel]?
}

extension SearchResultViewModel {
    ///请求搜索商品数据
    /// - parameter word:搜索关键词
    /// - parameter page:分页数,服务器默认=1，分页数大于最后一页时返回最后一页的数据
    /// - parameter finishCallBack:回调函数
    func requestSearchResult(word:String, page:Int, finishCallBack : @escaping () -> ()){
        NetworkTools.requestData(type: .GET, urlString: SEARCH_URL, parameters: ["word":word as NSString, "page": "\(page)" as NSString]) { (result) in
            guard let resultDict = result as? [String: NSObject] else { return }
            guard let resultCode = resultDict["code"] as? Int else { return }
            if resultCode == 200 {
                //搜索有结果
                guard let resultData = resultDict["result"] as? [[String:NSObject]]  else { return }
                self.searchResults = [SearchResultModel]()
                for result in resultData {
                    self.searchResults?.append(SearchResultModel(dict: result))
                }
            }else if resultCode == 201 {
                //搜索无结果
                self.searchResults = nil
            }
            finishCallBack()
        }
    }
    ///请求分类搜索数据
    /// - parameter cat:分类id
    /// - parameter page:分页数
    /// - parameter finishCallBack:回调函数
    func requestCategoryResult(cat:Int, page:Int, finishCallBack : @escaping () -> ()){
        NetworkTools.requestData(type: .GET, urlString: CATEGORYLIST_URL, parameters: ["cat" : "\(cat)" as NSString, "page" : "\(page)" as NSString]) { (result) in
            guard let resultDict = result as? [String: NSObject] else { return }
            guard let resultCode = resultDict["code"] as? Int else { return }
            if resultCode == 200 {
                //搜索有结果
                guard let resultData = resultDict["result"] as? [[String:NSObject]]  else { return }
                self.categoryResults = [SearchResultModel]()
                for result in resultData {
                    self.categoryResults?.append(SearchResultModel(dict: result))
                }
            }else if resultCode == 201 {
                //搜索无结果
                self.categoryResults = nil
            }
            finishCallBack()
        }
    }
}
