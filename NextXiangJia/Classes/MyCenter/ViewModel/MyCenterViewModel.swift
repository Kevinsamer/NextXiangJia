//
//  MyCenterViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/17.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Alamofire
class MycenterViewModel {
    var userMember:UserMemberModel?
    var errorInfo:String?
}

extension MycenterViewModel {
    func requestLoginData(username login_info:String, password:String, finishCallback: @escaping ()->()){
        NetworkTools.requestData(type: MethodType.POST, urlString: LOGIN_URL, parameters: ["login_info":login_info as NSString, "password":password as NSString]) { (result) in
            self.userMember = nil
            self.errorInfo = nil
            guard let resultDict = result as? [String: NSObject] else {return}
            guard let resultCode = resultDict["code"] as? Int else {return}
            guard let resultData = resultDict["result"] as? [String:NSObject] else {return}
            if resultCode == 200 {
                print(resultData)
                self.userMember = UserMemberModel(dict: resultData)
            }else if resultCode == 201{
                guard let errorInfo = resultData["scalar"] as? String else {return}
                self.errorInfo = errorInfo
            }
            finishCallback()
        }
    }
    
    func requestResisterData(username name:String, password pass:String, repassword repass:String, captcha:String, finishCallback:@escaping ()->()){
        NetworkTools.requestData(type: .POST, urlString: REGISTER_URL, parameters: ["username":name as NSString, "password":pass as NSString, "repassword":repass as NSString, "captcha":captcha as NSString]) { (result) in
            self.userMember = nil
            self.errorInfo = nil
            guard let resultDict = result as? [String: NSObject] else {return}
            guard let resultCode = resultDict["code"] as? Int else {return}
            guard let resultData = resultDict["result"] as? [String:NSObject] else {return}
            if resultCode == 200 {
                print(resultData)
                self.userMember = UserMemberModel(dict: resultData)
            }else if resultCode == 201{
                guard let errorInfo = resultData["scalar"] as? String else {return}
                self.errorInfo = errorInfo
            }
            finishCallback()
        }
    }
    
    func requestCaptchaData(finishCallback:@escaping (_ result:Data?)->()){
//        NetworkTools.requestData(type: .GET, urlString: AUTHCODE_URL) { (result) in
//            finishCallback(result)
//        }
        Alamofire.request(AUTHCODE_URL, method: HTTPMethod.get).responseString { (response) in
            
            finishCallback(response.data)
        }
        
    }
}
