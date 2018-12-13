//
//  UIAlertController-extension.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/12/12.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import Foundation
extension UIAlertController{
    
    ///自定义alert的title和取消按钮的title
    func showMyAlert(title:String, cancelTitle:String){
        self.title = title
        self.addAction(UIAlertAction.init(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: nil))
        self.show()
    }
}
