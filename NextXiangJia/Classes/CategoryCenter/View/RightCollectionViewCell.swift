//
//  RightCollectionViewCell.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/9/11.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class RightCollectionViewCell: UICollectionViewCell {
    @IBOutlet var marketPriceLabel: UILabel!
    @IBOutlet var sellPriceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //适配各机型：经测试需改变整体布局为百分比布局
        //间隙=1/20  pic=1/2  label = 3/20
        let cellH = self.frame.height
        imageView.frame = CGRect(x: imageView.frame.origin.x, y: cellH / 20, width: imageView.frame.width, height: cellH / 2)
        nameLabel.frame = CGRect(x: nameLabel.frame.origin.x, y: cellH * 3 / 5, width: nameLabel.frame.width, height: cellH * 3 / 20)
        nameLabel.adjustsFontSizeToFitWidth = true
        sellPriceLabel.frame = CGRect(x: sellPriceLabel.frame.origin.x, y: cellH * 4 / 5, width: sellPriceLabel.frame.width, height: cellH * 3 / 20)
        marketPriceLabel.frame = CGRect(x: marketPriceLabel.frame.origin.x, y: cellH * 4 / 5, width: marketPriceLabel.frame.width, height: cellH * 3 / 20)
    }

}
