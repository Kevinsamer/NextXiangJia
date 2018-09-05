//
//  MyCenterCell.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/4/24.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class MyCenterCell: UICollectionViewCell {
    var labelFA:UILabel?
    var labelText:UILabel?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let cellW = self.bounds.width
        labelFA = UILabel(frame: CGRect(x: cellW / 2 - 15, y: 20, width: 30, height: 30))
        labelFA?.textColor = UIColor.random.lighten(by: 0.4)
        labelText = UILabel(frame: CGRect(x: cellW / 2 - 40, y: 60, width: 80, height: 20))
//        labelText?.backgroundColor = UIColor.red.lighten(by: 0.8)
//        labelFA?.backgroundColor = UIColor.red.lighten(by: 0.8)
        labelFA?.textAlignment = .center
        labelText?.textAlignment = .center
        labelText?.font = UIFont.systemFont(ofSize: 13)
        labelFA?.font = UIFont.fontAwesome(ofSize: 25, style: .solid)
        self.addSubview(labelFA!)
        self.addSubview(labelText!)
    }
    
    
}
