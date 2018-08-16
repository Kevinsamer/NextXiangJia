//
//  MyTextField.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/5/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class MyTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let myLeftView:UIView = UIView(frame: CGRect(x: 10, y: 0, width: 7, height: 26))
//        myLeftView.backgroundColor = UIColor.clear
//        self.leftView = myLeftView
//
//        self.leftViewMode = UITextFieldViewMode.always
//        self.contentVerticalAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        return bounds.insetBy(dx: 15, dy: 0)
    }
    
}
