//
//  UIBarButtonItem-Extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/2/24.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    convenience init(imageName : String, hightImageName : String = "", size : CGSize = CGSize.zero){
        //初始化控件
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        if hightImageName != "" {
             btn.setImage(UIImage.init(named: hightImageName), for: .highlighted)
        }
        
        if size == CGSize.zero{
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView: btn)
    }
}
