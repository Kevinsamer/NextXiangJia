//
//  ItemCell.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/3/23.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    //MARK: - 控件属性
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemTextLabel: UILabel!
    
    //MARK: - 定义Model
    //var goods : GoodsGroup? {
    //    didSet{
    //        itemImageView.image = UIImage(goods.image)
    //        itemTextLabel.text = goods.goodsName
    //    }
    //}
}
