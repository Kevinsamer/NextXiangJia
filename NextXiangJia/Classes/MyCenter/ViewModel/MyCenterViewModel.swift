//
//  MyCenterViewModel.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/17.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class MycenterViewModel {
    ///添加地址结果信息
    var resultMsg:String = ""
    ///登录用户model
    var userMember:UserMemberModel?
    ///登录失败信息
    var errorInfo:String?
    ///用户所有地址信息model
    var userAddressInfo:[MyAddressModel]?
}
//默认地址请求参数枚举
enum IsDefault:Int {
    case yes = 1
    case no = 0
}

enum queryCondition:String {
    case all = "全部"
    case waitForPay = "待支付"
    case waitForReceived = "待收货"
    case completed = "已完成"
    case canceled = "已取消"
}



extension MycenterViewModel {
    ///请求登录
    /// - parameter username:登录用户名
    /// - parameter password:密码
    /// - parameter finishCallback:回调函数
    func requestLoginData(username login_info:String, password:String, finishCallback: @escaping ()->()){
        NetworkTools.requestData(type: MethodType.POST, urlString: LOGIN_URL, parameters: ["login_info":login_info as NSString, "password":password as NSString]) { (result) in
            self.userMember = nil
            self.errorInfo = nil
            guard let resultDict = result as? [String: NSObject] else {return}
//            print(result)
//            print(resultDict)
            guard let resultCode = resultDict["code"] as? Int else {return}
            guard let resultData = resultDict["result"] as? [String:NSObject] else {return}
            if resultCode == 200 {
                self.userMember = UserMemberModel(dict: resultData)
                self.userMember?.local_pd = password
            }else if resultCode == 201{
                guard let errorInfo = resultData["scalar"] as? String else {return}
                self.errorInfo = errorInfo
            }
            finishCallback()
        }
    }
    
    ///请求注册
    /// - parameter name:注册用户名
    /// - parameter pass:注册密码
    /// - parameter repass:重复密码
    /// - parameter captcha:验证码
    /// - parameter finishCallback:回调函数
    func requestResisterData(username name:String, password pass:String, repassword repass:String, captcha:String, finishCallback:@escaping ()->()){
        NetworkTools.requestData(type: .POST, urlString: REGISTER_URL, parameters: ["username":name as NSString, "password":pass as NSString, "repassword":repass as NSString, "captcha":captcha as NSString]) { (result) in
            self.userMember = nil
            self.errorInfo = nil
            guard let resultDict = result as? [String: NSObject] else {return}
            guard let resultCode = resultDict["code"] as? Int else {return}
            guard let resultData = resultDict["result"] as? [String:NSObject] else {return}
            if resultCode == 200 {
                //print(resultData)
                self.userMember = UserMemberModel(dict: resultData)
            }else if resultCode == 201{
                guard let errorInfo = resultData["scalar"] as? String else {return}
                self.errorInfo = errorInfo
            }
            finishCallback()
        }
    }
    
    ///请求验证码图片数据
    /// - parameter result:服务器返回的验证码图片数据流
    func requestCaptchaData(finishCallback:@escaping (_ result:Data?)->()){
        Alamofire.request(AUTHCODE_URL, method: HTTPMethod.get).responseString { (response) in
            finishCallback(response.data)
        }
    }
    
    ///请求退出登录
    func requestLoginOut(){
        Alamofire.request(LOGINOUT_URL, method: .get)
    }
    ///请求用户收货地址信息
    /// - parameter id:用户id
    /// - parameter finishCallback:回调方法
    func requestUserAddress(id:Int, finishCallback:@escaping ()->()){
        NetworkTools.requestData(type: .POST, urlString: GETADDRESS_URL, parameters: ["id":"\(id)" as NSString]) { (result) in
            self.userAddressInfo = []
            let resultJSON = JSON(result)
            //print(resultJSON)
            for json in resultJSON["result"].arrayValue{
//                print(json)
                self.userAddressInfo?.append(MyAddressModel(jsonData: json))
            }
//            for address in self.userAddressInfo!{
//                print("id=\(address.id)  详细=\(address.province)\(address.city)\(address.area)\(address.address)")
//            }
            finishCallback()
        }
    }
    ///请求设置默认地址
    /// - parameter id:地址id，请求地址信息时获得
    /// - parameter is_default:是否默认  1默认  0非默认
    /// - parameter finishCallback:回调方法
    func requestDefaultUserAddress(id:Int, is_default:IsDefault, finishCallback:@escaping ()->()){
//        NetworkTools.requestData(type: .POST, urlString: DEFAULTADDRESS_URL, parameters: ["id":"\(id)" as NSString, "is_default":"\(is_default.rawValue)" as NSString]) { (result) in
//            //接口无返回数据，直接重定向至网站的地址管理页面
//        }
        Alamofire.request(DEFAULTADDRESS_URL, method: HTTPMethod.post, parameters: ["id":"\(id)" as NSString, "is_default":"\(is_default.rawValue)" as NSString]).responseData { (result) in
            finishCallback()
        }
    }
    ///请求删除地址
    /// - parameter id:地址id，请求地址信息时获得
    /// - parameter finishCallback:回调
    func requestDelUserAddress(id:Int, finishCallback:@escaping ()->()){
        Alamofire.request(DELADDRESS_URL, method: HTTPMethod.post, parameters: ["id":"\(id)" as NSString]).responseData { (result) in
            finishCallback()
        }
    }
    ///请求添加地址
    /// - parameter acceptName: 收货人信息
    /// - parameter province: 省份编码
    /// - parameter city:城市编码
    /// - parameter area:地区编码
    /// - parameter address:详细地址
    /// - parameter zip:邮政编码
    /// - parameter telphone:电话号码
    /// - parameter mobile:手机号
    func requestAddAddress(acceptName:String, province:Int, city:Int, area:Int, address:String, zip:String, telphone:String, mobile:String, finishCallback:@escaping (_ msg:String)->()){
        self.resultMsg = ""
        NetworkTools.requestData(type: .POST, urlString: ADDADDRESS_URL, parameters: ["accept_name":"\(acceptName)" as NSString, "province":"\(province)" as NSString, "city":"\(city)" as NSString, "area":"\(area)" as NSString, "address":"\(address)" as NSString, "zip":"\(zip)" as NSString, "telphone":"\(telphone)" as NSString, "mobile":"\(mobile)" as NSString]) { (result) in
            
            //将返回的数据转为json数据
            let resultJSON = JSON(result)
            //如果添加失败，会返回错误信息，结果的key为result，错误信息的key为msg
            self.resultMsg = resultJSON["msg"].stringValue
            finishCallback(self.resultMsg)
//            print("resultJSON=\(resultJSON)")
//            print("data=\(data.dictionaryValue)")
//            print("result=\(self.addAddressErrorResult)")
//            print("msg=\(msg.stringValue)")
            
        }
    }
    
    ///请求编辑地址
    /// - parameter id:地址id
    /// - parameter acceptName: 收货人信息
    /// - parameter province: 省份编码
    /// - parameter city:城市编码
    /// - parameter area:地区编码
    /// - parameter address:详细地址
    /// - parameter zip:邮政编码
    /// - parameter telphone:电话号码
    /// - parameter mobile:手机号
    func requestEditAddress(id:Int, acceptName:String, province:Int, city:Int, area:Int, address:String, zip:String, telphone:String, mobile:String, finishCallback:@escaping (_ msg:String)->()){
        self.resultMsg = ""
        NetworkTools.requestData(type: .POST, urlString: ADDADDRESS_URL, parameters: ["id":"\(id)" as NSString, "accept_name":"\(acceptName)" as NSString, "province":"\(province)" as NSString, "city":"\(city)" as NSString, "area":"\(area)" as NSString, "address":"\(address)" as NSString, "zip":"\(zip)" as NSString, "telphone":"\(telphone)" as NSString, "mobile":"\(mobile)" as NSString]) { (result) in
            
            //将返回的数据转为json数据
            let resultJSON = JSON(result)
            //如果添加失败，会返回错误信息，结果的key为result，错误信息的key为msg
            self.resultMsg = resultJSON["msg"].stringValue
            finishCallback(self.resultMsg)
            //            print("resultJSON=\(resultJSON)")
            //            print("data=\(data.dictionaryValue)")
            //            print("result=\(self.addAddressErrorResult)")
            //            print("msg=\(msg.stringValue)")
            
        }
    }
    ///请求是否有默认地址
    /// - parameter id:用户id
    /// - parameter finishCallback:回调函数，接收返回结果并回调使用
    func requestIsDefaultAddress(user_id id:Int, finishCallback:@escaping(_ address:MyAddressModel)->()){
        NetworkTools.requestData(type: .POST, urlString: ISDEFAULTADDRESS_URL, parameters: ["user_id":"\(id)" as NSString]) { (result) in
            let resultJSON = JSON(result)
            let resultCode = resultJSON["code"].intValue
            if resultCode == 200 {
                let defaultAddress = MyAddressModel(jsonData: resultJSON["result"].arrayValue[0])
                finishCallback(defaultAddress)
            }else if resultCode == 201{
                //没有收货地址信息
            }
            
        }
    }
    ///请求用户所有订单数据
    /// - parameter id:用户id
    /// - parameter page:分页数
    /// - parameter finishCallback:回调函数
    /// - parameter query:分类查询条件["全部","待支付","待收货","已完成","已取消"]
    func requestOrderList(user_id id:Int, page:Int, query_what query:String, finishCallback:@escaping (_ orderLists:[OrderModel])->()){
        NetworkTools.requestData(type: .POST, urlString: MYORDERLIST_URL, parameters: ["user_id":"\(id)" as NSString, "page":"\(page)" as NSString, "query_what":"\(query)" as NSString]) { (result) in
            let resultData = JSON(result)
            let jsonData = resultData["result"].arrayValue
            print(query)
            var orderList:[OrderModel] = [OrderModel]()
            for json in jsonData {
                orderList.append(OrderModel(jsonData: json))
            }
            finishCallback(orderList)
        }
    }
    
    ///请求订单商品列表数据
    /// - parameter id:订单id
    /// - parameter finishCallback:回调函数
    /// - parameter goodsLists:服务器返回的订单商品数组
    func requestOrderGoodsList(order_id id:Int, finishCallback:@escaping (_ goodsLists:[OrderGoodsListModel])->()){
        NetworkTools.requestData(type: .POST, urlString: ORDERGOODS_URL, parameters: ["order_id":"\(id)" as NSString]) { (result) in
            let resultData = JSON(result)
            //print(resultData)
            let jsonData = resultData["result"].arrayValue
            var goodsList:[OrderGoodsListModel] = [OrderGoodsListModel]()
            for json in jsonData {
                goodsList.append(OrderGoodsListModel(jsonData: json))
            }
            finishCallback(goodsList)
        }
    }
    
    ///请求订单详情数据
    /// - parameter id:订单id
    /// - parameter isPhone:手机json数据标志位，传true返回json数据
    /// - parameter finishCallback:回调函数
    func requestOrderDetail(order_id id:Int, isPhone:Bool = true, finishCallback:@escaping (_ order:OrderModel)->()){
        NetworkTools.requestData(type: MethodType.POST, urlString: ORDERDETAIL_URL, parameters: ["id":"\(id)" as NSString, "is_phone":"\(isPhone)" as NSString]) { (result) in
            let jsonData = JSON(result)
            let orderModel = OrderModel(jsonData: jsonData)
            finishCallback(orderModel)
        }
    }
    
    ///取消订单||确认收货
    /// - parameter id:订单id
    /// - parameter op:操作类型，cancel为取消订单，confirm为确认订单
    func requestOrderStatus(order_id id:Int, op:String, finishCallback:@escaping ()->()){
        Alamofire.request(ORDERSTATUS_URL, method: .post, parameters: ["order_id":"\(id)" as NSString, "op":"\(op)" as NSString])
        finishCallback()
    }
    ///请求修改密码,服务器返回值对应关系如下：
    ///   1. 密码格式不正确，请重新输入
    ///   2. 两次输入的新密码不一致，请重新输入
    ///   3. 原密码输入错误
    ///   4. 密码修改成功
    ///   5. 密码修改失败
    /// - parameter fpassword:原密码
    /// - parameter password:新密码
    /// - parameter repassword:再次输入的新密码
    /// - parameter finishCallback:回调函数
    func requestPasswordEdit(fpassword:String, password:String, repassword:String, finishaCallback:@escaping (_ editResult:String)->()){
        NetworkTools.requestData(type: .POST, urlString: PASSWORDEDIT_URL, parameters: ["fpassword":"\(fpassword)" as NSString, "password":"\(password)" as NSString, "repassword":"\(repassword)" as NSString]) { (result) in
            let resultCode = result as! Int
            switch resultCode {
            case 1:
                finishaCallback("密码格式不正确，请重新输入")
                break
            case 2:
                finishaCallback("两次输入的新密码不一致，请重新输入")
                break
            case 3:
                finishaCallback("原密码输入错误")
                break
            case 4:
                finishaCallback("密码修改成功")
                break
            case 5:
                finishaCallback("密码修改失败")
                break
            default:
                finishaCallback("密码修改失败")
                break
            }
        }
    }
    
    /// 请求修改用户信息
    ///
    /// 服务器返回码对应关系如下
    /// 1. 邮箱已被注册
    /// 2. 手机已被注册
    /// 3. 资料修改成功
    /// - Parameters:
    ///   - name: 用户姓名(请求字段为true_name)
    ///   - sex: 性别  男1  女2
    ///   - birthday: 生日，eg:2018-07-03
    ///   - mobile: 手机号
    ///   - email: 邮箱
    ///   - zip: 邮编
    ///   - teltphone: 电话
    ///   - qq: qq号
    ///   - finishCallback: 回调函数
    ///   - resultCode: 服务器返回码
    func requestInfoEditAct(true_name name:String, sex:String, birthday:String, mobile:String, email:String, zip:String, teltphone:String, qq:String, finishCallback:@escaping (_ resultCode:Int)->()){
        NetworkTools.requestData(type: .POST, urlString: INFOEDITACT_URL, parameters: ["true_name":"\(name)" as NSString, "sex":"\(sex)" as NSString, "birthday":"\(birthday)" as NSString, "mobile":"\(mobile)" as NSString, "email":"\(email)" as NSString, "zip":"\(zip)" as NSString, "telephone":"\(teltphone)" as NSString, "qq":"\(qq)" as NSString]) { (result) in
            finishCallback(result as! Int)
        }
    }
    
    
    /// 请求当前用户的个人资料
    ///
    /// - Parameter finishCallback: 回调函数
    /// - parameter member:个人资料model
    func requestMyInfo(finishCallback:@escaping (_ member:UserMemberModel)->()){
        NetworkTools.requestData(type: MethodType.POST, urlString: MYINFO_URL) { (result) in
            guard let resultDict = result as? [String : NSObject] else {return}
            //print(resultDict)
            finishCallback(UserMemberModel(dict: resultDict))
        }
    }
}
