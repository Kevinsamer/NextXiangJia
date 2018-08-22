//
//  Common.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/2/26.
//  Copyright © 2018年 DEV2018. All rights reserved.
//  常量类

import UIKit
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

//let Areas = MyAreaPickerView.getDataFromTxt()!

