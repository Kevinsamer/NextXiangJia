//
//  Common.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/2/26.
//  Copyright © 2018年 DEV2018. All rights reserved.
//  常量类

import UIKit
import CoreData
let finalScreenW : CGFloat = UIScreen.main.bounds.width
let finalScreenH : CGFloat = UIScreen.main.bounds.height

let finalStatusBarH : CGFloat = UIApplication.shared.statusBarFrame.size.height
let finalNavigationBarH : CGFloat = 44
let finalTabBarH : CGFloat = 49
let notificationBarH : CGFloat = 20
let IphonexHomeIndicatorH :CGFloat = 34
public var searchContent : String = ""
public var finalContentViewHaveTabbarH = UIDevice.current.isX() ? finalScreenH - finalStatusBarH - finalNavigationBarH - finalTabBarH - IphonexHomeIndicatorH : finalScreenH - finalStatusBarH - finalNavigationBarH - finalTabBarH
public var finalContentViewNoTabbarH = UIDevice.current.isX() ? finalScreenH - finalStatusBarH - finalNavigationBarH - IphonexHomeIndicatorH : finalScreenH - finalStatusBarH - finalNavigationBarH
//public var finalContentViewHaveTabbarH = UIDevice.current.isX() ? finalScreenH - finalTabBarH - IphonexHomeIndicatorH : finalScreenH - finalStatusBarH - finalNavigationBarH - finalTabBarH
//public var finalContentViewNoTabbarH = UIDevice.current.isX() ? finalScreenH -  IphonexHomeIndicatorH : finalScreenH - finalStatusBarH - finalNavigationBarH


public var testMode : Bool = true//测试模式flag
public var showSearchButton = true//某些页面是否显示搜索按钮
//搜索栏显示状态标记 1隐藏  2显示
public var searchBarState = 2
public var loginState:Bool = false//登录状态
public var context:NSManagedObjectContext = {
    let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    return context
}()
//个人中心cell文字颜色集合
let myCenterColors:[UIColor] = [#colorLiteral(red: 0.1960784314, green: 0.6980392157, blue: 0.9254901961, alpha: 1),#colorLiteral(red: 0.2078431373, green: 0.7333333333, blue: 0.5960784314, alpha: 1),#colorLiteral(red: 0.1215686275, green: 0.6705882353, blue: 0.9215686275, alpha: 1),#colorLiteral(red: 0.9450980392, green: 0.2509803922, blue: 0.4823529412, alpha: 1),#colorLiteral(red: 0.968627451, green: 0.3529411765, blue: 0.3803921569, alpha: 1),#colorLiteral(red: 0.9725490196, green: 0.5529411765, blue: 0.568627451, alpha: 1),#colorLiteral(red: 1, green: 0.7019607843, blue: 0.3490196078, alpha: 1)]

