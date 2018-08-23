//
//  ItemCell.swift
//  NextXiangJia
//
//  Created by DEV2018 on 2018/3/23.
//  Copyright © 2018年 DEV2018. All rights reserved.
//

import UIKit
import FontAwesome_swift
class ItemCell: UICollectionViewCell {
    
    //MARK: - 控件属性
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemTextLabel: UILabel!
    
    @IBOutlet var marketPrice: UILabel!
    @IBOutlet var sellPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - 定义Model
    //var goods : GoodsGroup? {
    //    didSet{
    //        itemImageView.image = UIImage(goods.image)
    //        itemTextLabel.text = goods.goodsName
    //    }
    //}
}
