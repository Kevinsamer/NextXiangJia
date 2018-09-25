//
//  YTools.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/4/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
private var viewC:UIViewController?

public class YTools{
    
    class func setNavigationBarAndTabBar(navCT:UINavigationController, tabbarCT:UITabBarController? = nil, color:UIColor = UIColor.white, fontSize:CGFloat = 18, titleName:String? = nil, navItem:UINavigationItem){
        //1.隐藏tabbar
        //tabbarCT.tabBar.isHidden = true
        //2.修改navigationBar
        navCT.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)]
        navCT.navigationBar.tintColor = color
        if titleName != nil {
            navItem.title = titleName
        }
        
    }
    //显示toast
    class func showMyToast(rootView: UIView, message:String, duration:TimeInterval = 3.0, position:ToastPosition = .center){
        var myStyle = ToastStyle()
        myStyle.backgroundColor = UIColor(named: "global_orange")!
        rootView.makeToast(message, duration: duration, position: position, style: myStyle)
    }
    
    class func getCategoryLine(categoryNum : CGFloat,num : Int) -> Int{
        if (categoryNum / CGFloat(num)) - CGFloat(Int(categoryNum) / num) != 0{
            //print(categoryNum / CGFloat(num))
            return Int(categoryNum) / num + 1
        }else{
            return Int(categoryNum) / num
        }
    }
    
    //通过class_copyIvarList来查看类中所有的属性--p1:目标类  p2:属性个数的指针(返回时包含返回数组的长度)。该函数返回所有属性的地址
    class func printKVCKey(_ cls: AnyClass?){
        var count : UInt32 = 0
        let ivars = class_copyIvarList(cls, &count)!
        //循环count次，查看所有属性
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            print(String(cString : name!))
        }
    }
    //文字添加中划线，返回NSAttributedString
    class func textAddMiddleLine(text: String) -> NSAttributedString{
        let attributeText = NSMutableAttributedString(string: text)
        attributeText.addAttribute(NSAttributedStringKey.baselineOffset, value: 0, range: NSMakeRange(0, attributeText.length))
        attributeText.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeText.length))
        attributeText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: NSRange(location:0,length:attributeText.length))
        return attributeText
    }
    //获取当前navigationBar高度
    class func getCurrentNavigationBarHeight(navCT: UINavigationController) -> CGFloat{
        return navCT.navigationBar.frame.height
    }
    //测试模式打印信息
    class func myPrint(content: String, mode: Bool){
        if mode {
            print(content)
        }
    }
    //处理手机号，4-7位改为*
    class func changePhoneNum(phone: String) -> String{
        return phone.slicing(from: 0, length: 3)! + "****" + phone.slicing(from: 7, length: 4)!
    }
    
    //处理价格￥和小数点中间的数字加粗放大
    class func changePrice(price: String,fontNum: CGFloat) -> NSMutableAttributedString{
        let ￥ = price.slicing(from: 0, to: 1)
        let integer = price.splitted(by: ".")[0].slicing(at: 1)!
        let decimal = price.splitted(by: ".")[1]
        let attributedString = NSMutableAttributedString.init(string: price)
        let rang￥ = (price as NSString).range(of: ￥!)
        let rangInteger = (price as NSString).range(of: integer)
        let rangDecimal = (price as NSString).range(of: "." + decimal)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontNum).bold , NSAttributedStringKey.foregroundColor : UIColor.red], range: rang￥)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.red , NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontNum + 6).bold], range: rangInteger)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontNum).bold , NSAttributedStringKey.foregroundColor : UIColor.red], range: rangDecimal)
        return attributedString
    }
    //将date转为2018-11-11 11:11:11类型的字符串
    class func dateToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    //字符串转data,失败返回1970.1.1
    class func stringToDate(str:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: str) ?? Date(timeIntervalSince1970: 0)
    }
    //颜色数组中随机返回一个颜色
    class func randomColorIn(colors colorArray:[UIColor]) -> UIColor{
        return colorArray[Int.random(between: 0, and: colorArray.count - 1)].withAlphaComponent(0.3)
    }
    //将商品规格中的售价放入数组并由大到小排序后返回
    class func collectSellPriceFromGoodsProduct(goodsProducts products: [GoodsProduct]) -> [Double]{
        var priceArray:[Double] = [Double]()
        for product in products {
            priceArray.append(Double(product.sell_price) ?? 0.00)
        }
        //print(priceArray)精确到小数点后两位
        return priceArray.sorted(){$0 > $1}
    }
    
    //将商品规格中的原价放入数组并由大到小排序后返回
    class func collectMarketPriceFromGoodsProduct(goodsProducts products: [GoodsProduct]) -> [Double]{
        var priceArray:[Double] = [Double]()
        for product in products {
            priceArray.append(Double(product.market_price) ?? 0.00)
        }
        return priceArray.sorted(){$0 > $1}
    }
    //传入商品的货品数组，返回该商品的规格类型数组
    class func getSpecValuesFromProductSpec(products: [GoodsProduct]) -> [GoodsTypeModel]{
        let specNum = products[0].productSpecs.count
        var models:[GoodsTypeModel] = [GoodsTypeModel]()
        for i in 0..<specNum {
            models.append(GoodsTypeModel(selectIndex: -1, typeName: products[0].productSpecs[i].name, typeArray: [String]() as NSArray))
        }
        for productNo in 0..<products.count {
            let product = products[productNo]
            let specs = product.productSpecs
            for specNo in 0..<specNum {
                let spec = specs[specNo]
                var temp:[String] = [String]()
                if spec.type == 1 {
                    temp = models[specNo].typeArray.adding("\(spec.value)") as! [String]
                }else if spec.type == 2 {
                    temp = models[specNo].typeArray.adding("\(spec.tip)") as! [String]
                }
                temp = Array(Set(temp))
                models[specNo].typeArray = temp as NSArray
                //添加结束  去重
            }
        }
        return models
    }
    //传入一个货品信息，返回该货品的详细规格
    class func getGoodsProductSpecs(product: GoodsProduct) -> String{
        var strs:String = ""
        for spec in product.productSpecs {
            if spec.type == 1 {
                strs += (spec.value + "、")
            }else if spec.type == 2 {
                strs += (spec.tip + "、")
            }
        }
        strs.remove(at: strs.index(before: strs.endIndex))
        return strs
    }
    //通过productId和选择数量获取已选的货品
    class func getSelectedProductById(sizeModel model:SizeAttributeModel, goodsProducts products:[GoodsProduct]?) -> SelectedProduct{
        let selectedProduct:SelectedProduct = SelectedProduct()
        selectedProduct.selectedNum = Int(model.count)
        selectedProduct.productType = model.productType
        if model.productType == 0 {
            selectedProduct.good_Id = Int(model.goodsNo)
        }else if model.productType == 1 {
            selectedProduct.good_Id = Int(model.goodsNo)
            if products != nil {
                for product in products! {
                    if "\(product.id)" == model.productId {
                        selectedProduct.selectedProduct = product
                    }
                }
            }
        }
        return selectedProduct
    }
    //截取数组前num个
    class func splitArray(array:[NSObject], num:Int) -> [NSObject]{
        if array.count <= num {
            return array
        }else {
            var temp = [NSObject]()
            for i in 0..<num {
                temp.append(array[i])
            }
            return temp
        }
    }
    
}
//MARK: - objc func
extension YTools{
    
}
