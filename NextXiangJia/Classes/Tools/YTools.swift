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
    public static func setNavigationBarAndTabBar(navCT:UINavigationController, tabbarCT:UITabBarController, color:UIColor = UIColor.white, fontSize:CGFloat = 18, titleName:String, navItem:UINavigationItem){
        //1.隐藏tabbar
        //tabbarCT.tabBar.isHidden = true
        //2.修改navigationBar
        navCT.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)]
        navCT.navigationBar.tintColor = color
        navItem.title = titleName
    }
    //显示toast
    public static func showMyToast(rootView: UIView, message:String, duration:TimeInterval = 3.0, position:ToastPosition = .bottom){
        var myStyle = ToastStyle()
        myStyle.backgroundColor = UIColor(named: "global_orange")!
        rootView.makeToast(message, duration: duration, position: position, style: myStyle)
    }
    
    public static func getCategoryLine(categoryNum : CGFloat,num : Int) -> Int{
        if (categoryNum / CGFloat(num)) - CGFloat(Int(categoryNum) / num) != 0{
            //print(categoryNum / CGFloat(num))
            return Int(categoryNum) / num + 1
        }else{
            return Int(categoryNum) / num
        }
    }
    
    //通过class_copyIvarList来查看类中所有的属性--p1:目标类  p2:属性个数的指针(返回时包含返回数组的长度)。该函数返回所有属性的地址
    public static func printKVCKey(_ cls: AnyClass?){
        var count : UInt32 = 0
        let ivars = class_copyIvarList(cls, &count)!
        //循环count次，查看所有属性
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            print(String(cString : name!))
        }
    }
    
    
}
//MARK: - objc func
extension YTools{
    
}
