//
//  SearchResultViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/5.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation

class SearchResultViewModel {
    var searchResults:[SearchResultModel]?
    var categoryResults:[SearchResultModel]?
}

extension SearchResultViewModel {
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
